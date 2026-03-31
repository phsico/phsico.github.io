```js
export async function main(ns) {
  var target = ns.args[0];
  const sT = 5
  const mT = 0.75
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

```js
/** @param {NS} ns */
export async function main(ns) {
  var files = "script.js"
  var boss = ns.args[0];
  // Servers 0 port - 16 GB of RAM
  const servers0Port = ["sigma-cosmetics",
    "joesguns",
    "nectar-net",
    "hong-fang-tea",
    "harakiri-sushi",
    "n00dles",
    "foodnstuff"];

  // Servers 1 port - 32 GB of RAM
  const servers1Port = ["neo-net",
    "zer0",
    "max-hardware",
    "iron-gym",
    "neo-net"];

  // Server 2 port - 64 GB
  const servers2Port = ["johnson-ortho",
    //"avmnite-02h",
    "crush-fitness",
    "phantasy",
    "silver-helix",
    "omega-net",
    "the-hub"]
  // Copy scripts ; Nuke; Execute scripts
  for (let i = 0; i < servers0Port.length; ++i) {
    const target = servers0Port[i];
    if (!boss) {
      var boss = target
    } else {
      var boss = boss
    }
    ns.scp(files, target);
    ns.nuke(target);
    //ns.killall(target)
    ns.exec(files, target, 2, boss);
  }

  // Wait until we acquire the "BruteSSH.exe" program
  while (!ns.fileExists("BruteSSH.exe")) {
    await ns.sleep(60000);
  }

  // Copy scripts ; SSH ; Nuke; Execute scripts
  for (let i = 0; i < servers1Port.length; ++i) {
    const target = servers1Port[i];
    if (!boss) {
      var boss = target
    } else {
      var boss = boss
    }
    ns.scp(files, target);
    ns.brutessh(target);
    ns.nuke(target);
    //ns.killall(target)
    ns.exec(files, target, 4, boss);
  }

  while (!ns.fileExists("FTPCrack.exe")) {
    await ns.sleep(60000);
  }

  for (let i = 0; i < servers2Port.length; ++i) {
    const target = servers2Port[i];
    if (!boss) {
      var boss = target
    } else {
      var boss = boss
    }
    ns.scp(files, target);
    ns.brutessh(target);
    ns.ftpcrack(target);

    ns.nuke(target);
    //ns.killall(target)
    ns.exec(files, target, 8, boss);

  }
}
```
