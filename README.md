# The Seeds of God

PoW Mnemonic sentence generator for Bitcoin.

## Advise!!

- :fearful:: Still under development and validation, do not use until first version is released!!

## Install

```
npm install

```


## Demo

[The Seeds Of God](https://theseedsofgod-production.up.railway.app)

```
Hosted for demo only by railway!
```

## Usage

Download and execute the index.html inside of /Dist folder 

```
/dist/index.html
```

## Building

Prerequisites:

- Node JS
- Npm or Yarn

Use the provided build command:

```bash
npm run build
```

Use the provided command to run as a developer:

```bash
npm run dev
```

## License

[GNU](https://www.gnu.org/licenses/gpl-3.0.en.html)

## Contact me
<div id="badges">
  <a href="https://twitter.com/jrcdev">
    <img src="https://img.shields.io/badge/Twitter-blue?style=for-the-badge&logo=twitter&logoColor=white" alt="Twitter Badge"/>
  </a>
</div>


<script src="https://cdn.jsdelivr.net/npm/web-bip39@1.0.0/dist/bip39.min.js"></script>
<script>
    const seed = 'your_bip39_seed';
    const mnemonic = bip39.entropyToMnemonic(seed);
    const rootNode = new TreeNode(mnemonic);
    const childNode1 = rootNode.createChild(85);
    const childNode2 = rootNode.createChild(86);
    const childNode3 = rootNode.createChild(87);
    console.log(childNode1.getPrivateKey());
    console.log(childNode2.getPrivateKey());
    console.log(childNode3.getPrivateKey());
</script>

<script>
    const rootNode = new TreeNode(name);
    const childAdded1 = rootNode.addChild(UidNodeSelected,name,description)
    //childAdded1 is a new child with the correct depth and depth Index attribute number
    const removed = rootNode.removeChild(UidNodeSelected);
    console.log(rootNode.toJSON());
    // to json print:
    /**
     [{
      uid: xxx,
      depth: 0,
      depthIndex:0
      color: "#393b79",
      "Amount (TC)": 8695349.610000001,
      values:[
        {
          uid: uuuu,
          depth: 1,
          depthIndex:0
          color: "#393b79",
          "Amount (TC)-net": 8695349.610000001,
          "Amount (TC)": 8695349.610000001,
          values:[
            {
              uid: uuuu,
              depth: 2,
              depthIndex:0
              color: "#393b79",
              "Amount (TC)-net": 8695349.610000001,
              "Amount (TC)": 8695349.610000001,
              values:[]
            }
          ]
        },
        {
          uid: uuuu,
          depth: 1,
          depthIndex:2
          color: "#393b74",
          "Amount (TC)-net": 8695349.610000002,
          "Amount (TC)": 8695349.610000003,
          values:[]
        }
      ]
    }];
    **/
    
</script>

function addNode(node, parentUid) {
    if(dataset === null) {
        dataset = {
            key: "",
            depth: 0,
            iDepth: 0,
            values: [],
            uid: 0,
            color: "#393b79",
            "Amount (TC)-net": 8695349.610000001,
            "Amount (TC)": 8695349.610000001,
            REF_Amount: "USD",
        }
    }
    if(parentUid === undefined) {
        dataset.values.push(node);
        return;
    }
    for (var i = 0; i < dataset.values.length; i++) {
        if (dataset.values[i].uid === parentUid) {
            dataset.values[i].values.push(node);
            return;
        } else {
            addNode(node, parentUid, dataset.values[i].values);
        }
    }
}


var dataset = {
    key: "",
    depth: 0,
    iDepth: 0,
    values:[
        {
            key: "",
            depth: 0,
            iDepth: 0,
            values:[]
            uid: 0,
            color: "#393b79",
            "Amount (TC)-net": 8695349.610000001,
            "Amount (TC)": 8695349.610000001,
            REF_Amount: "USD",
        }
    ],
    uid: 0,
    color: "#393b79",
    "Amount (TC)-net": 8695349.610000001,
    "Amount (TC)": 8695349.610000001,
    REF_Amount: "USD",
};

function addNode(node, parentUid) {
    for (var i = 0; i < dataset.values.length; i++) {
        if (dataset.values[i].uid === parentUid) {
            dataset.values[i].values.push(node);
            return;
        } else {
            addNode(node, parentUid, dataset.values[i].values);
        }
    }
}

function removeNode(uid) {
    for (var i = 0; i < dataset.values.length; i++) {
        if (dataset.values[i].uid === uid) {
            dataset.values.splice(i, 1);
            return;
        } else {
            removeNode(uid, dataset.values[i].values);
        }
    }
}

function updateNode(node, uid) {
    for (var i = 0; i < dataset.values.length; i++) {
        if (dataset.values[i].uid === uid) {
            dataset.values[i] = node;
            return;
        } else {
            updateNode(node, uid, dataset.values[i].values);
        }
    }
}



<script src="https://cdn.jsdelivr.net/npm/bip32@0.3.2/dist/index.min.js"></script>
<script>
    var dataset = {
        uid: 0,
        color: "#393b79",
        "Amount (TC)": 8695349.610000001,
        values:[
            {
                uid: 0,
                color: "#393b79",
                "Amount (TC)-net": 8695349.610000001,
                "Amount (TC)": 8695349.610000001,
                values:[],
                mnemonic: ""
            }
        ]
    };
    var rootSeed = 'your_bip39_seed';
    function addNode(node, parentUid) {
        for (var i = 0; i < dataset.values.length; i++) {
            if (dataset.values[i].uid === parentUid) {
                var newSeed = bip39.mnemonicToSeedSync(dataset.values[i].mnemonic, "your_passphrase").toString('hex');
                var root = bip32.fromSeed(Buffer.from(newSeed, 'hex'));
                var path = `m/44'/0'/0'/0/${node.path}`;
                var derived = root.derivePath(path);
                node.mnemonic = bip39.entropyToMnemonic(derived.toSeed().toString('hex'));
                dataset.values[i].values.push(node);
                return;
            } else {
                addNode(node, parentUid, dataset.values[i].values);
            }
        }
    }
    function removeNode(uid) {
        for (var i = 0; i < dataset.values.length; i++) {
            if (dataset.values[i].uid === uid) {
                dataset.values.splice(i, 1);
                return;
            } else {
                removeNode(uid, dataset.values[i].values);
            }
        }
    }
    // initilize the root seed
    dataset.values


function addNode(node, parentUid) {
    for (var i = 0; i < dataset.values.length; i++) {
        if (dataset.values[i].uid === parentUid) {
            var newSeed = bip39.mnemonicToSeedSync(dataset.values[i].mnemonic, "your_passphrase").toString('hex');
            var root = bip32.fromSeed(Buffer.from(newSeed, 'hex'));
            var path = `m/44'/0'/0'/0/${currentPath}`;
            var derived = root.derivePath(path);
            node.mnemonic = bip39.entropyToMnemonic(derived.toSeed().toString('hex'));
            node.path = currentPath;
            currentPath++;
            dataset.values[i].values.push(node);
            return;
        } else {
            addNode(node, parentUid, dataset.values[i].values);
        }
    }
}


<script src="https://cdn.jsdelivr.net/npm/bip39-web@1.0.0/dist/bip39.min.js"></script>
<script>
    function derivePath(node) {
        var path = `m/85'/0'/0'/0/${node.depth}`;
        var seed = bip39.mnemonicToSeedSync(node.mnemonic, 'your_passphrase');
        var root = bip32.fromSeed(seed);
        var derived = root.derivePath(path);
        var newSeed = derived.toSeed().toString('hex');
        return newSeed;
    }
    var rootNode = {
        mnemonic: 'your_bip39_seed',
        depth: 0,
        parent: null,
        children: []
    };
    var childNode1 = {
        mnemonic: derivePath(rootNode),
        depth: 1,
        parent: rootNode,
        children: []
    };
    rootNode.children.push(childNode1);
    var childNode2 = {
        mnemonic: derivePath(childNode1),
        depth: 2,
        parent: childNode1,
        children: []
    };
    childNode1.children.push(childNode2);
    console.log(rootNode);
    console.log(childNode1);
    console.log(childNode2);
</script>


The coin_type, account, and change fields in the BIP85 path are used to further specify the key that is being derived.

    coin_type: is used to specify the coin or token that is being used. It is an constant value assigned by BIP44 and BIP49. For example: Bitcoin is 0, Litecoin is 2, Ethereum is 60.

    account: is used to specify the account within the coin type that is being used. For example, you might have one account for your personal use and another for your business. Each account has its own set of addresses and private keys.

    change: is used to distinguish between the external and internal chains (i.e. addresses used for receiving and change). A value of 0 for the change field is used for external addresses, which are addresses that are used to receive funds. A value of 1 for the change field is used for internal addresses, which are addresses that are used as the change addresses for transactions.

Here's an example of how the coin_type, account, and change fields can be used in a BIP85 path:

    An example of a path to derive the external address of the first account of a Bitcoin wallet : m/85'/0'/0'/0/0
    An example of a path to derive the internal address of the second account of an Ethereum wallet: m/85'/60'/1'/1/0

It's important to note that the use of the coin_type, account, and change fields is not mandatory, you can use them or not, it depends on your use case, but if you are using a specific coin, you should use the coin_type.
Also, the values for the account and change fields can be any value you want, it's up to you to manage them.
It's also important to note that you should use a different seed or mnemonic for different coins or tokens.

function countNodes(node) {
    var count = 0;
    if (node.children) {
        for (var i = 0; i < node.children.length; i++) {
            count += countNodes(node.children[i]);
        }
    }
    return count + 1;
}
console.log(countNodes(rootNode));


function countNodes(node, level) {
    var count = 0;
    if (node.depth === level) {
        count++;
    }
    if (node.children) {
        for (var i = 0; i < node.children.length; i++) {
            count += countNodes(node.children[i], level);
        }
    }
    return count;
}
console.log(countNodes(rootNode, 2)); // this will give you the number of nodes in level 2


class TreeNode {
    constructor(name) {
        this.name = name;
        this.depth = 0;
        this.depthIndex = 0;
        this.color = "#393b79";
        this.Amount = 8695349.610000001;
        this.values = [];
    }

    addChild(UidNodeSelected, name, description) {
        let depth = this.depth + 1;
        let depthIndex = this.values.length;
        let child = new TreeNode(name);
        child.depth = depth;
        child.depthIndex = depthIndex;
        child.UidNodeSelected = UidNodeSelected;
        child.description = description;
        this.values.push(child);
        return child;
    }

    removeChild(UidNodeSelected) {
        this.values = this.values.filter(function(node) {
            return node.UidNodeSelected != UidNodeSelected;
        });
    }

    toJSON() {
        return JSON.stringify(this);
    }
}

const rootNode = new TreeNode("root");
const childAdded1 = rootNode.addChild("UidNodeSelected1","Child1","Description1")
const removed = rootNode.removeChild("UidNodeSelected1");
console.log(rootNode.toJSON());


<script src="https://cdn.jsdelivr.net/npm/bip32-utils@1.0.0/dist/bip32-utils.min.js"></script>
<script>
    var seed = bip39.mnemonicToSeedSync('your_bip85_seed_phrase', 'your_passphrase');
    var root = bip32.fromSeed(seed);
    var path = "m/85'/0'/0'/0/0";
    var derived = root.derivePath(path);
    var privateKey = derived.privateKey;
    var publicKey = derived.publicKey;
    console.log("Private key: " + privateKey.toString('hex'));
    console.log("Public key: " + publicKey.toString('hex'));
</script>

<script src="https://cdn.jsdelivr.net/npm/bip32-utils@1.0.0/dist/bip32-utils.min.js"></script>
<script>
    var seed = bip39.mnemonicToSeedSync('your_bip85_seed_phrase', 'your_passphrase');
    var root = bip32.fromSeed(seed);
    var path = "m/85'/0'/0'/0/0";
    var derived = root.derivePath(path);
    var privateKey = derived.privateKey;
    var privateKeyHex = bip32.toHex(privateKey);
    console.log("Private key: " + privateKeyHex);
</script>

<div id="private-key-qrcode"></div>
<div id="public-key-qrcode"></div>

<script src="https://cdn.jsdelivr.net/npm/bip32-utils@1.0.0/dist/bip32-utils.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/qrcode@0.14.0/build/qrcode.min.js"></script>

<script>
    var seed = bip39.mnemonicToSeedSync('your_bip85_seed_phrase', 'your_passphrase');
    var root = bip32.fromSeed(seed);
    var path = "m/85'/0'/0'/0/0";
    var derived = root.derivePath(path);
    var privateKey = derived.privateKey;
    var privateKeyHex = bip32.toHex(privateKey);
    var publicKey = derived.publicKey;
    var publicKeyHex = bip32.toHex(publicKey);
    new QRCode(document.getElementById("private-key-qrcode"), privateKeyHex);
    new QRCode(document.getElementById("public-key-qrcode"), publicKeyHex);
</script>


<div class="relative inline-flex rounded-md bg-white text-[0.8125rem] font-medium leading-5 text-slate-700 shadow-sm ring-1">
  <div class="flex py-2 px-3">
    <svg class="mr-2.5 h-5 w-5 flex-none fill-slate-400">
      <path d="M5 4a2 2 0 0 1 2-2h6a2 2 0 0 1 2 2v14l-5-2.5L5 18V4Z"></path>
    </svg>
    Bookmark
  </div>
  <div class="border-l border-slate-400 py-2 px-2.5">12k</div>
</div>

.relative{
  position: relative;
}

.inline-flex{
  display: inline-flex;
}

.rounded-md{
  border-radius: .375rem;
}

.bg-white{
  background-color: white;
}

.text-[0.8125rem]{
  font-size: 0.8125rem;
}

.font-medium{
  font-weight: 500;
}

.leading-5{
  line-height: 1.25;
}

.text-slate-700{
  color: #718096;
}

.shadow-sm{
  box-shadow: 0 1px 3px 0 rgba(0,0,0,0.1),0 1px 2px 0 rgba(0,0,0,0.06);
}

.ring-1{
  border-width: 2px;
}

.fill-slate-400{
  fill: #718096;
}

.border-l {
  border-left-style: solid;
}

.border-slate-400{
  border-color: #718096;
}
