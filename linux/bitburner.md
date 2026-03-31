## script.js
```js
export async function main(ns) {
  var target = ns.args[0];
  const sT = 5
  const mT = 0.8
  const cycle = 4
  while (true) {
    for (let i=0 ; i < cycle ; i++){
      var securityLevel = ns.getServerSecurityLevel(target)
      var securityThresh = ns.getServerMinSecurityLevel(target) * 1 + sT
      var serverMoney = ns.getServerMoneyAvailable(target)
      var moneyThresh = ns.getServerMaxMoney(target) * mT
      if (securityLevel > securityThresh) {
        await ns.weaken(target)
      } else if (serverMoney < moneyThresh) {
        await ns.grow(target)
      } else {
        await ns.hack(target)
      }
    }
    //await ns.hack(target)
  }
}
```
## server.js
```js
/** @param {NS} ns */
export async function main(ns) {
  const files = "script.js";
  const boss = ns.args[0];
  // Thread counts for each server group
  const threadCounts = [1, 1, 2, 6, 12, 24, 48];

  const allServers = [
    //0GB
    ["darkweb", //1
      "crush-fitness", //251
      "johnson-ortho", //284
      "computek", //367
      "syscore", //580
      "snap-fitness", //778
      "zb-def", //790
      "zeus-med", //814
      "galactic-cyber", //831
      "nova-med", //832
      "deltaone", //856
      "infocomm", //879
      "aerocorp", //886
      "taiyang-digital", //894
      "icarus", //900
      "defcomm"], //933
    //4GB
    ["n00dles"], //1
    //8GB
    ["CSEC", //57
      "the-hub"], //322
    //16GB
    ["foodnstuff", //1
      "sigma-cosmetics", //5
      "joesguns", //10
      "nectar-net", //20
      "hong-fang-tea", //30
      "harakiri-sushi", //40
      "aevum-police", //405
      "catalyst", //445
      "summit-uni", //453
      "solaris", //759
      "unitalife", //796
      "univ-energy", //827
      "omnia"], //898
    //32GB
    ["neo-net", //50
      "zer0", //75
      "max-hardware", //80
      "phantasy", //100
      "iron-gym", //100
      "omega-net", //205
      "rothman-uni", //395
      "millenium-fitness", //482
      "global-pharm"], //767
    //64GB
    ["silver-helix", //150
      "avmnite-02h", //203
      "netlink", //420
      "zb-institute"], //728
    //128GB
    ["alpha-ent", //507
      "lexo-corp"] //691
  ];

  // Wait for all exploit tools
  const requiredFiles = ["BruteSSH.exe", "FTPCrack.exe", "relaySMTP.exe", "HTTPWorm.exe", "SQLInject.exe"];
  for (const file of requiredFiles) {
    while (!ns.fileExists(file)) {
      ns.print(`Waiting for ${file}...\n`);
      await ns.sleep(60000);
    }
    ns.print(`${file} acquired!\n`);
  }

  // Setup and execute on all servers
  for (let y = 0; y < allServers.length; ++y) {
    ns.print(`Processing server group ${y} with ${threadCounts[y]} threads\n`);
    for (let i = 0; i < allServers[y].length; ++i) {
      const target = allServers[y][i];
      await setupServer(ns, target, files, threadCounts[y], boss);
    }
  }
}

// Function to setup a single server
async function setupServer(ns, target, files, threads, boss) {
  ns.scp(files, target);
  ns.brutessh(target);
  ns.ftpcrack(target);
  ns.relaysmtp(target);
  ns.httpworm(target);
  ns.sqlinject(target);
  ns.nuke(target);
  ns.exec(files, target, threads, boss);
}

```

### hsetup.js
```js 

/** @param {NS} ns */
export async function main(ns) {
  var byte = 1020
  var file = 2.4
  var calc = (byte / file) - 1
  var files = "script.js"
  var boss = "iron-gym"
  var home = "home"
  
  //ns.exec("qsetup.js", "home", 1, boss)
  ns.exec("server.js", home, 1, boss)
  //ns.tail("server.js", home, boss)
  await ns.sleep(100)
  ns.print(byte + " / " + file + " = "  + calc + "\n")
  ns.exec(files, "home", calc, boss)
}
```

## All server
```js
const allServers = [
  //0GB
  ["darkweb", //1
  "crush-fitness", //251
  "johnson-ortho", //284
  "computek", //367
  "syscore", //580
  "snap-fitness", //778
  "zb-def", //790
  "zeus-med", //814
  "galactic-cyber", //831
  "nova-med", //832
  "deltaone", //856
  "infocomm", //879
  "aerocorp", //886
  "taiyang-digital", //894
  "icarus", //900
  "defcomm"], //933
  //4GB
  ["n00dles"], //1
  //8GB
  ["CSEC", //57
  "the-hub"], //322
  //16GB
  ["foodnstuff", //1
  "sigma-cosmetics", //5
  "joesguns", //10
  "nectar-net", //20
  "hong-fang-tea", //30
  "harakiri-sushi", //40
  "aevum-police", //405
  "catalyst", //445
  "summit-uni", //453
  "solaris", //759
  "unitalife", //796
  "univ-energy", //827
  "omnia"], //898
  //32GB
  ["neo-net", //50
  "zer0", //75
  "max-hardware", //80
  "phantasy", //100
  "iron-gym", //100
  "omega-net", //205
  "rothman-uni", //395
  "millenium-fitness", //482
  "global-pharm"], //767
  //64GB
  ["silver-helix", //150
  "avmnite-02h", //203
  "netlink", //420
  "zb-institute"], //728
  //128GB
  ["alpha-ent", //507
  "lexo-corp"] //691
];
```
