import d3 from './d3.v3.js'

var height = 500;
var width = 800 * 3;
function getValueField() {
    return valueField;
}
var valueField = "Amount (TC)";
var aColors = [
    "#d53e4f",
    "#f46d43",
    "#fdae61",
    "#fee08b",
    "#e6f598",
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

        nodeEnter
            .append("text")
            .attr("x", function (d) {
                return fnChildren(d) || d._children ? -15 : 15;
            })
            .attr("dy", ".35em")
            .attr("text-anchor", function (d) {
                if(!d.parent)
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
        console.log(d)
        
        
        if (d.children) {
            d._children = d.children;
            d.children = null;
            d.values = null;
        } else {
            d.values = d._children;
            d.children = d._children;
            d._children = null;
        }
        
        this.emit('onSelectedNode',d);
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