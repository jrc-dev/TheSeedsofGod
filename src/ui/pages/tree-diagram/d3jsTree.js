import d3 from '../../../3rd/d3.v3.js'

var height = 450;
var width = 800 * 3;
function getValueField() {
    return valueField;
}
var valueField = "Amount (TC)";
var aColors = [
    //"#fee08b",
    //"#e6f598",
    "#d53e4f",
    "#f46d43",
    "#fdae61",
    "#abdda4",
    "#66c2a5",
    "#3288bd",
];

var draw = (dataset) => {
    var svg = d3.select("svg");
    var chart = svg.node();
    // clear
    d3.select(chart).html("");

    var tree = WeightedTree()
        .svg(chart)
        .width(width)
        .height(height)
        .dataset(dataset)
        .fnValueField(function (d) {
            return d[valueField];
        });
    tree();
};

function WeightedTree() {

    var width,
        height,
        margin = { top: 20, right: 10, bottom: 20, left: 50 },
        levelWidth = [1],
        // Data related
        i = 0,
        dataset,
        dataRoot,
        _rootNode,
        aRootHistory = [],
        aOpenNodesUid = [],
        valueFormatter = d3.format(".2s"),
        duration = 750,
        // Vertical Gap between adjacent nodes
        iNodeSize = 30,
        iLevelGap = 250,
        iDefaultLevel = 2,
        colorScale = d3.scale.category10().range(aColors),
        nodeSizeScale = d3.scale.sqrt().range([2, 22]).clamp(true),
        fnValueField = function (d) {
            return d.value;
        },
        fnChildren = function (d) {
            return d.values;
        },
        isResized = false,
        // Layout related
        tree,
        diagonal,
        // DOM related
        svg,
        gOuter,
        gLinks,
        gNodes;

    function graph() {
        // re-initialise variables
        //
        init();
    }

    function init() {
        nodeSizeScale.domain([0, fnValueField(dataset)]);

        tree = d3.layout
            .tree()
            .size([height, width])
            .nodeSize([iNodeSize, iNodeSize])
            .children(fnChildren);

        diagonal = d3.svg.diagonal().projection(function (d) {
            return [d.y, d.x];
        });

        gOuter = d3
            .select(svg)
            .attr("width", width + margin.right + margin.left)
            .attr("height", height + margin.top * 0 + margin.bottom * 0)
            .classed("weighted-tree", true)

            // Reset to root node when clicked on the SVG
            .on("click", function (d) {
                _rootNode = dataRoot;
                update(dataRoot);
            })
            .append("g")
            .attr(
                "transform",
                "translate(" +
                margin.left +
                "," +
                (iNodeSize / 2 + height / 2) +
                ")"
            );

        gLinks = gOuter.append("g").classed("links", true);

        gNodes = gOuter.append("g").classed("nodes", true);

        dataRoot = _rootNode = dataset;
        dataRoot.x0 = height / 2;
        dataRoot.y0 = 0;

        // Collapse upto default level
        function visitNode(d) {
            if (d.depth < iDefaultLevel) {
                fnChildren(d).forEach(visitNode);
            } else if (d.depth >= iDefaultLevel) {
                collapseNode(d);
            }
        }

        // Collapse a Node; Recursively
        function collapseNode(d) {
            if (d.values && !isExpanded(d)) {
                d._children = d.values;
                d._children.forEach(collapseNode);
                d.children = null;
                d.values = null;
            } else if (d.values) {
                // expanded node
                // only close the non expanded nodes
                d.values.forEach(collapseNode);
            }
        }

        // is this node expanded
        function isExpanded(d) {
            return aOpenNodesUid.indexOf(d.uid) > -1;
        }

        visitNode(dataRoot);

        update(dataRoot);

        // reset default open nodes
        aOpenNodesUid = [];

        //centerNode(dataRoot);
    }

    /**
     * Returns an array of nodes that are open in the graph
     * @return {array}
     */
    function getExpandedNodes() {
        var aNodeIds = [];

        function visitNode(d) {
            if (d.children) {
                aNodeIds.push(d.uid);
                d.children.forEach(visitNode);
            }
        }

        visitNode(dataRoot);

        return aNodeIds;
    }

    function getRootNode() {
        return _rootNode;
    }

    function _getGradientId(d) {
        return "lgd-" + d.source.uid + "-" + d.target.uid;
    }

    function _getLinkUrl(d) {
        return "url(#" + _getGradientId(d) + ")";
    }

    function _getLinkColor(d, bIsSource) {
        var sName = bIsSource ? "source" : "target",
            vf = getValueField() + "-net",
            bIsNegative = d.target[vf] < 0;

        if (bIsNegative) {
            // reverse color if link's net Value is negative
            sName = bIsSource ? "target" : "source";
        }
        return d[sName].color;
    }

    function update(source) {
        // Compute the new tree layout.
        var nodes = tree.nodes(getRootNode()).reverse(),
            links = tree.links(nodes);

        // Normalize for fixed-depth.
        nodes.forEach(function (d) {
            d.y = d.depth * iLevelGap;
        });

        // Update the nodes…
        var node = gNodes.selectAll("g.node").data(nodes, function (d) {
            return d.id || (d.id = ++i);
        });

        // Enter any new nodes at the parent's previous position.
        var nodeEnter = node
            .enter()
            .append("g")
            .attr("class", "node")
            .attr("transform", function (d) {
                return "translate(" + source.y0 + "," + source.x0 + ")";
            })
            .on("click", click);

        nodeEnter
            .append("circle")
            .attr("r", 1e-6)
            .style("opacity", function (d) {
                return d._children ? 1 : 0.5;
            })
            .style("fill", function (d) {
                return (d.color = colorScale(d.key));
            });

        nodeEnter.append("path");

        var firstNode = node.filter(function (d, i) {
            return d.depth === 0;
        });

        firstNode
            .select("path")
            .style("fill", function (d) {
                return (d.color = colorScale(d.key));
            })
            .attr("transform", function (d) {
                return "translate(" + -50 + "," + -35 + ")";
            })
            .attr("d", "m53.36992,1.03081c-0.08236,-0.00663 -0.15475,0.00276 -0.23324,0.00184c-0.00508,0 -0.01037,-0.00184 -0.01545,-0.00184c-23.25674,-0.72931 -47.70186,11.50219 -45.58924,35.1689c0.00834,0.09588 0.03457,0.18072 0.05368,0.26997c-0.0305,0.24494 -0.0305,0.5013 0.03518,0.77992c1.27522,5.40089 -0.68204,10.14903 -5.58079,13.46008c-0.2245,0.15127 -0.39654,0.32518 -0.54681,0.50645c-0.49516,0.29445 -0.886,0.74587 -1.09668,1.29244c-0.91895,2.38667 -0.22084,4.81641 1.8867,6.47691c0.34732,0.27273 0.74976,0.45878 1.16846,0.55871c1.36042,0.68036 2.78287,1.13252 4.26002,1.44849c-0.3036,1.48217 -0.15434,2.98091 0.63446,4.39204c-1.47288,2.59794 -0.49516,5.46401 2.41277,7.02826c0.1641,0.0887 0.3278,0.15514 0.48886,0.20648c0.49353,0.53184 0.54112,1.38592 0.35932,2.20743c-0.05633,0.2512 -0.06345,0.50258 -0.0423,0.74753c-0.01281,0.22249 -0.00508,0.44866 0.0423,0.67668c0.76664,3.63881 4.20125,5.64804 8.13123,5.71263c0.21169,0.00386 0.40691,-0.01601 0.59114,-0.04969c0.1818,0.00755 0.37234,-0.00184 0.56898,-0.03073c6.31143,-0.92622 13.49748,-0.40854 15.86815,5.86483c0.47401,1.25324 1.74049,1.67835 2.87539,1.5129c0.3825,0.25985 0.886,0.40744 1.52066,0.36732c11.43671,-0.72342 22.77276,-2.22694 34.12854,-3.60624c0.40182,-0.04877 0.74976,-0.16636 1.05011,-0.33291c1.37669,-0.38867 2.48862,-1.78287 1.59957,-3.28566c-7.58767,-12.80254 7.79407,-26.76962 10.71339,-39.06848c0.06406,-0.26592 0.06507,-0.51215 0.03925,-0.74679c3.08546,-20.19997 -12.35932,-39.68571 -35.32363,-41.55748zm30.47959,40.65665c-0.02989,0.18697 -0.03396,0.36585 -0.02257,0.53773c-3.17127,13.15974 -17.0783,25.88187 -11.57255,39.66105c-10.34146,1.27091 -20.676,2.57549 -31.0931,3.23523c-0.07382,0.0046 -0.13828,0.02245 -0.20905,0.03276c-3.72317,-7.49937 -12.38616,-8.84408 -20.95744,-7.66942c-0.08561,-0.00939 -0.16512,-0.02632 -0.25704,-0.02797c-0.97589,-0.01693 -1.48549,-0.10839 -2.24704,-0.5289c0.0667,0.01877 -0.39125,-0.31211 -0.38718,-0.30659c-0.06548,-0.05981 -0.10635,-0.09533 -0.13625,-0.1187c0,-0.01785 -0.02623,-0.07104 -0.12242,-0.21219c-0.14499,-0.21035 -0.25195,-0.50645 -0.34082,-0.84101c0.44188,-2.76228 -0.4248,-5.16202 -2.98256,-6.92815c-0.20559,-0.14115 -0.43578,-0.22047 -0.6737,-0.27292c-0.07382,-0.05613 -0.1456,-0.11023 -0.22308,-0.18108c0.01403,0.00552 0.00102,-0.02245 -0.04331,-0.08705c0,-0.05705 -0.00427,-0.07564 -0.01139,-0.07012c0.0305,-0.11943 0.05979,-0.23924 0.10635,-0.35518c0.00102,-0.0046 0.37234,-0.52596 0.49516,-0.68312c0.34326,-0.43836 0.41362,-0.97002 0.30564,-1.48125c0.10208,-0.50442 0.02949,-1.03148 -0.30564,-1.47076c-0.94213,-1.23539 -0.75688,-2.28675 0,-3.58563c1.08387,-1.85888 -0.86852,-3.55563 -2.59802,-3.3819c-0.0181,-0.00202 -0.03416,-0.00755 -0.05165,-0.01031c-1.75452,-0.20943 -3.45047,-0.67391 -4.97094,-1.49616c-0.109,-0.05797 -0.21596,-0.09349 -0.32272,-0.13747c-0.07605,-0.09993 -0.14662,-0.20188 -0.21027,-0.30733c-0.01078,-0.02908 -0.01912,-0.05429 -0.03396,-0.09551c-0.0124,-0.05226 -0.02115,-0.08686 -0.02949,-0.12054c-0.00427,-0.10361 -0.00102,-0.20556 0.00407,-0.30935c0.00834,-0.02797 0.0244,-0.09257 0.04555,-0.19249c6.32729,-4.4743 9.04509,-10.62419 7.50551,-17.81237c0.00305,-0.09017 0.01342,-0.17428 0.00508,-0.27015c-1.8991,-21.27341 19.96996,-31.30742 40.60529,-30.66092c0.06507,0.00184 0.12282,-0.00847 0.18586,-0.01031c0.02278,0.00184 0.04128,0.00828 0.06385,0.01031c19.59091,1.59719 33.271,18.88802 30.47979,36.14775z")

        var NotfirstNode = node.selectAll("path").filter(function (d, i) {
            return d.depth != 0;
        });

        NotfirstNode.attr("d", "");

        nodeEnter
            .append("text")
            .attr("x", function (d) {
                return fnChildren(d) || d._children ? -15 : 15;
            })
            .attr("dy", ".35em")
            .attr("text-anchor", function (d) {
                if (!d.parent)
                    return "middle"
                return fnChildren(d) || d._children ? "end" : "start";
            })
            .text(function (d) {
                return d.key;
            })
            .style("fill-opacity", 1e-6);

        node
            .on("click", click)
            .on("mousemove", onEdgeMouseover)
            .on("mouseout", onMouseout);

        // Transition nodes to their new position.
        var nodeUpdate = node
            .transition()
            .duration(duration)
            .attr("transform", function (d) {
                return "translate(" + d.y + "," + d.x + ")";
            });

        nodeUpdate
            .select("circle")
            .attr("r", function (d) {
                return nodeSizeScale(fnValueField(d));
            })
            .style("opacity", function (d) {
                return d._children ? 1 : 0.5;
            })
            .style("fill", function (d) {
                return d.color || (d.color = colorScale(d.key));
            });

        nodeUpdate.select("text").style("fill-opacity", 1);

        // Transition exiting nodes to the parent's new position.
        var nodeExit = node
            .exit()
            .transition()
            .duration(duration)
            .attr("transform", function (d) {
                return "translate(" + source.y + "," + source.x + ")";
            })
            .remove();


        nodeExit.select("circle").attr("r", 1e-6);

        nodeExit.select("text").style("fill-opacity", 1e-6);

        // Update the links…
        var link = gLinks.selectAll("g.link").data(links, function (d) {
            return d.target.id;
        });

        // Enter any new links at the parent's previous position.
        var newLink = link
            .enter()
            .append("g")
            .style("mix-blend-mode", "multiply")
            .classed("link", true);

        var gradient = newLink
            .append("linearGradient")
            .attr("gradientUnits", "userSpaceOnUse")
            .attr("id", function (d) {
                return _getGradientId(d);
            })
            .attr("x1", function (d) {
                return d.source.y;
            })
            .attr("x2", function (d) {
                return d.target.y;
            });

        gradient
            .append("stop")
            .attr("offset", "10%")
            .attr("stop-color", function (d) {
                return _getLinkColor(d, true);
            });

        gradient
            .append("stop")
            .attr("offset", "90%")
            .attr("stop-color", function (d) {
                return _getLinkColor(d);
            });

        newLink
            .append("path")
            .attr("d", function (d) {
                var o = { x: source.x0, y: source.y0 };
                return diagonal({ source: o, target: o });
            })
            .attr("stroke", function (d) {
                //return d.source.color;
                return _getLinkUrl(d);
            })
            .attr("stroke-width", function (d) {
                return (
                    2 *
                    nodeSizeScale(
                        (fnChildren(d.target) || d.target._children || []).length
                    )
                );
            })
            .on("click", function (d) {
                highlightNode(d.source);
            });

        // Update
        //

        var uGradient = link
            .select("linearGradient")
            .attr("id", function (d) {
                return _getGradientId(d);
            })
            .attr("x1", function (d) {
                return d.source.y;
            })
            .attr("x2", function (d) {
                return d.target.y;
            });

        // reset
        uGradient.selectAll("stop").remove();

        uGradient
            .append("stop")
            .attr("offset", "10%")
            .attr("stop-color", function (d) {
                return _getLinkColor(d, true);
            });

        uGradient
            .append("stop")
            .attr("offset", "90%")
            .attr("stop-color", function (d) {
                return _getLinkColor(d);
            });

        link
            .on("click", function (d) {
                highlightNode(d.source);
            })
            .on("mousemove", onFlowMouseover)
            .on("mouseout", onMouseout);

        // Transition links to their new position.
        link
            .select("path")
            .transition()
            .duration(duration)
            .attr("d", diagonal)
            .attr("stroke", function (d) {
                //return d.source.color;
                return _getLinkUrl(d);
            })
            .attr("stroke-width", function (d) {
                return 2 * nodeSizeScale(fnValueField(d.target));
            });

        // Transition exiting nodes to the parent's new position.
        link.exit().transition().duration(duration).remove();

        link
            .exit()
            .select("path")
            .transition()
            .duration(duration)
            .attr("d", function (d) {
                var o = { x: source.x, y: source.y };
                return diagonal({ source: o, target: o });
            });
        //.remove();

        // Stash the old positions for transition.
        nodes.forEach(function (d) {
            d.x0 = d.x;
            d.y0 = d.y;
        });

        // pan the source node
        panSourceNode(nodes, source);
    }

    function childCount(level, n) {
        if (n.children && n.children.length > 0) {
            if (levelWidth.length <= level + 1) levelWidth.push(0);

            levelWidth[level + 1] += n.children.length;
            n.children.forEach(function (d) {
                childCount(level + 1, d);
            });
        }
    }

    function getTopmostNode(d) {
        while (d.depth > 1 || (d.depth == 0 && d.parent)) {
            d = d.parent;
        }
        return d;
    }

    function onEdgeMouseover(d, i) {
        d3.event.stopPropagation();

        var oPayload = {
            iDepthOffset: -1,
            datapoint: d,
            tree: [d],
        };
    }

    function onFlowMouseover(d, i) {
        d3.event.stopPropagation();

        var oPayload = {
            iDepthOffset: -1,
            datapoint: d.target,
            tree: [d.source, d.target],
        };
    }

    function onMouseout(d, i) { }

    // Toggle children on click.
    function click(d) {
        //debugger
        d3.event.preventDefault();
        d3.event.stopPropagation();

        if (d.children) {
            d._children = d.children;
            d.children = null;
            d.values = null;
        } else {
            d.values = d._children;
            d.children = d._children;
            d._children = null;
        }

        this.emit('onSelectedNode', d);
        update(d);
    }

    /**
     * Highlight a node.
     * This node will replace the root node.
     * @param  {[type]} source [description]
     */
    function highlightNode(sourceNode) {
        d3.event.preventDefault();

        d3.event.stopPropagation();

        // if already highlighted, return to normal state
        if (sourceNode.bHighlighted) {
            delete sourceNode.bHighlighted;

            // get last root node from history
            //
            _rootNode = aRootHistory.length ? aRootHistory.pop() : dataRoot;
        } else {
            // push current node in history
            //
            aRootHistory.push(_rootNode);

            // mark current node as highlighted
            sourceNode.bHighlighted = true;
            // replace as root node
            _rootNode = sourceNode;
        }

        update(_rootNode);

        // Update breadcrumb
        // do not update for root node
        if (_rootNode.iDepth > 0) {
        }
    }

    // Center currently opened/clicked node
    // Only to be used when tree.size() is in use
    /*
function centerNode(source) {
  
  var scale = 1,
    x = -source.y0,
    y = -source.x0,
    marginRight = 100;
    
  // put root node at center of the screen.
  // other nodes to a little on the right to
  // maximise screen space usage
  x = source.depth == 0 ? (x * scale + width / 2) : (x * scale + width - marginRight),
  y = y * scale + height / 2;
  
  gOuter.transition()
    .duration(duration)
    .attr("transform", "translate(" + x + "," + y + ")scale(" + scale + ")");
  

}
*/

    /**
     * Update the svg dimensions and position the
     * souce node such that it is in focus
     * @param  {array} nodes  current nodes
     * @param  {object} source clicked node
     */
    function panSourceNode(nodes, source) {
        var depth = d3.max(nodes, function (d) {
            return d.depth;
        }),
            xExtent = d3.extent(nodes, function (a) {
                return a.x;
            }),
            yMax = d3.max(nodes, function (a) {
                return a.y;
            }),
            minY = xExtent[0],
            maxY = xExtent[1],
            bbox = gOuter.node().getBBox(),
            bIsSourceCollpasing = !!source._children,
            marginRight = 100,
            iPossibleNextWidth =
                bbox.width + (bIsSourceCollpasing ? -iLevelGap : iLevelGap),
            wCalc = depth * iLevelGap,
            hCalc = maxY - minY,
            w = (wCalc < width ? width : wCalc) + margin.left + marginRight, //Math.min(width, depth * iLevelGap)
            h = (hCalc < height ? height : hCalc) + margin.top, //Math.max(height, maxY - minY)
            translateY = h / 2 + iNodeSize / 2,
            scrollTop,
            scrollLeft,
            midY = height / 2,
            elSvg = d3.select(svg),
            elSvgParent = elSvg.node().parentNode,
            elSvgParentWidth = elSvgParent.getBoundingClientRect().width,
            midYSourceDiff = midY + minY;

        elSvg
            //.transition()
            //.duration(duration)
            .style("height", h + 100 + "px")
            .style("width", w + "px");

        /**
         * Determine gOuter translateY position
         */
        if (midYSourceDiff < 0) {
            translateY = minY * -1 + iNodeSize;
        } else if (midYSourceDiff > 0 && midYSourceDiff < midY) {
            translateY = midY;
        }

        /**
         * Determine svg container's scrollTop
         * when the content size gets bigger than pre-defined height
         */
        if (h > height) {
            if (translateY < height) {
                var currentScrollTop = elSvgParent.scrollTop;
                if (source.x0 < 0) {
                    //var newScrollTop = (height - translateY);
                    var newScrollTop = Math.min(
                        0,
                        translateY - Math.abs(source.x0) - elSvgParent.scrollTop
                    );
                    if (
                        Math.abs(minY) + maxY < height &&
                        newScrollTop <= midY &&
                        currentScrollTop < midY
                    ) {
                    } else {
                        scrollTop = newScrollTop;
                    }
                } else {
                    scrollTop = currentScrollTop || 0;
                }
            } else {
                scrollTop = source.x0 + translateY - midY;
            }

            elSvgParent.scrollTop = scrollTop;
        }

        /**
         * Determine svg container's scrollLeft
         * when the content size gets bigger than pre-defined width
         */
        //if (w > yMax && source.depth > 0) {
        if (w > yMax && yMax > elSvgParentWidth && source.depth > 0) {
            scrollLeft = w - yMax + marginRight + margin.left + iNodeSize * 2;
        } else if (!bIsSourceCollpasing) {
            scrollLeft = 0;
        }

        if (bIsSourceCollpasing && yMax < elSvgParentWidth - margin.left) {
            scrollLeft = 0;
        }

        if (scrollLeft !== undefined) {
            elSvgParent.scrollLeft = scrollLeft;
        }

        // For root node
        if (source.depth == 0) {
            gOuter
                .transition()
                .duration(duration)
                .attr(
                    "transform",
                    "translate(" + margin.left + "," + translateY + ")"
                ); //(iNodeSize + height/2)
        } else {
            // For non-root nodes
            gOuter
                .transition()
                .duration(duration)
                .attr(
                    "transform",
                    "translate(" +
                    (margin.left - marginRight * 0) +
                    "," +
                    translateY +
                    ")"
                );
        }
    }

    /**
     * Re-renders the graph using dataset and parameters
     * @return {[type]} [description]
     */
    graph.update = function () {
        // re-initialise variables

        nodeSizeScale.domain([0, fnValueField(dataset)]);

        d3.select(svg)
            .attr("width", width + margin.right + margin.left)
            .attr("height", height + margin.top * 0 + margin.bottom * 0);

        gOuter.attr(
            "transform",
            "translate(" + margin.left + "," + (iNodeSize / 2 + height / 2) + ")"
        );

        _rootNode.x0 = height / 2;
        _rootNode.y0 = 0;

        // Update graph
        //
        update(getRootNode());
    };

    // Public Methods / APIs
    // ---------------------

    /**
     * Handle Resizing after the graph has been rendered once
     */
    graph.resize = function () {
        isResized = true;

        graph.update();
    };

    graph.width = function (_) {
        if (!arguments.length) {
            return width;
        }
        width = _;
        return graph;
    };

    graph.height = function (_) {
        if (!arguments.length) {
            return height;
        }
        height = _;
        return graph;
    };

    graph.valueFormatter = function (_) {
        if (!arguments.length) {
            return valueFormatter;
        }
        valueFormatter = _;
        return graph;
    };

    graph.colorScale = function (_) {
        if (!arguments.length) {
            return colorScale;
        }
        colorScale = _;
        return graph;
    };

    graph.fnValueField = function (_) {
        if (!arguments.length) {
            return fnValueField;
        }
        fnValueField = _;
        return graph;
    };

    graph.fnChildren = function (_) {
        if (!arguments.length) {
            return fnChildren;
        }
        fnChildren = _;
        return graph;
    };

    graph.svg = function (_) {
        if (!arguments.length) {
            return svg;
        }
        svg = _;
        return graph;
    };

    graph.dataset = function (_) {
        if (!arguments.length) {
            return dataset;
        }
        dataset = _;
        return graph;
    };

    graph.defaultDepth = function (_) {
        if (!arguments.length) {
            return iDefaultLevel;
        }
        iDefaultLevel = Math.max(1, _);
        return graph;
    };

    graph.openNodes = function (_) {
        if (!arguments.length) {
            return aOpenNodesUid;
        }
        aOpenNodesUid = _;
        return graph;
    };

    graph.getExpandedNodes = getExpandedNodes;

    return graph;
}

exports.draw = draw;