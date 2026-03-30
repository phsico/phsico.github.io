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
/** @param {import(".").NS } ns */
export async function main(ns) {
  const target = ns.args[0];           // company name passed as argument
  if (!target) {
    ns.tprint("Usage: run script.js <companyName>");
    return;
  }

  const cycles = 3;                    // repeat grow+weaken this many times
  for (let i = 0; i < cycles; i++) {
    // grow
    await ns.grow(target);
    // weaken
    await ns.weaken(target);
  }

  // final hack
  await ns.hack(target);
}

```
