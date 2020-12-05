'use strict';

const {readFileSync} = require('fs');

const required = ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid'];
console.log(
  `part 1: ${
    readFileSync('input.txt')
    .toString()
    .split('\n\n')
    .map(data => data.split(/[\n\s]+/).reduce((passport, keyValue) => { 
      const [k, v] = keyValue.split(':');
      passport[k] = v;
      return passport
    }, {}))
    .filter(p => required.every(field => p[field] !== undefined))
    .length
  } valid passports`
);

const eyeColors = ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'];
console.log(
  `part 2: ${
    readFileSync('input.txt')
    .toString()
    .split('\n\n')
    .map(data => data.split(/[\n\s]+/).reduce((passport, keyValue) => { 
      const [k, v] = keyValue.split(':');
      passport[k] = v;
      return passport
    }, {}))
    .filter(p => {
      return (
        required.every(field => p[field] !== undefined) &&
        parseInt(p.byr) >= 1920 && parseInt(p.byr) <= 2002 &&
        parseInt(p.iyr) >= 2010 && parseInt(p.iyr) <= 2020 &&
        parseInt(p.eyr) >= 2020 && parseInt(p.eyr) <= 2030 &&
        (
          (
            p.hgt.match(/^[0-9]{3}cm$/) &&
            parseInt(p.hgt.substring(0, 3)) >= 150 &&
            parseInt(p.hgt.substring(0, 3)) <= 193
           ) ||
           (
            p.hgt.match(/^[0-9]{2}in$/) &&
            parseInt(p.hgt.substring(0, 2)) >= 59 &&
            parseInt(p.hgt.substring(0, 2)) <= 76
           )
         ) &&
        p.hcl.match(/^#[a-f0-9]{6}$/) &&
        eyeColors.includes(p.ecl) &&
        p.pid.match(/^[0-9]{9}$/)
      );
    })
    .length
  } valid passports`
);
