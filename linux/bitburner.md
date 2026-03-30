Tutorial Commands

help

ls

scan

scan-analyze 

scan-analyze 2

connect n00dles 
  
  analyze 

  run NUKE.exe // root

  hack

  weaken 

  grow

home

nano n00dles.js

```js
/** @param {NS} ns */
export async function main(ns) {
  while (true) {
    await ns.hack("n00dles");
  }
}

```
free   / show mem

run n00dles.js

tail n00dles.js



```js
export async function main(ns) {
    var target = ns.args[0];
    var securityLevel = ns.getServerSecurityLevel(target)
    var securityThresh = ns.getServerMinSecurityLevel(target) * 3
    var serverMoney = ns.getServerMoneyAvailable(target)
    var moneyThresh = ns.getServerMaxMoney(target) * 0.8

    while (true) {
        if (securityLevel > securityThresh) {
            await ns.weaken(target)
            var securityLevel = ns.getServerSecurityLevel(target)
            var securityThresh = ns.getServerMinSecurityLevel(target) * 3
        } else if (serverMoney < moneyThresh) {
            await ns.grow(target)
            var serverMoney = ns.getServerMoneyAvailable(target)
            var moneyThresh = ns.getServerMaxMoney(target) * 0.8
        } else {
            await ns.hack(target)
            var serverMoney = ns.getServerMoneyAvailable(target)
        }
    }
}
```
