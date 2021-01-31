#!/usr/bin/env node

const path = require('path')
const { spawn } = require('child_process')
const { Command } = require('commander')
const fs = require('fs')
const program = new Command()

const fromRoot = (relative) => path.resolve(__dirname, '..', relative)

const run = (command, args, options = {}, spawner = spawn) =>
  new Promise((resolve) => {
    const proc = spawner(command, [].concat(args).filter(Boolean), {
      stdio: 'inherit',
      cwd: process.cwd(),
      env: process.env,
      ...options
    })

    proc.on('exit', resolve)
  })

const existsTemplates = ['cpp', 'kotlin', 'cpp', 'asm']

program.version('1.0.0')
  .command('init')
  .description('Inits project with chosen template')
  .requiredOption('-p, --pname <pname>', 'Name of initialized project')
  .requiredOption('-t, --template <template>', 'Name of initialized project')
  .action(async (options) => {
    const { template, pname } = options
    if (!existsTemplates.includes(template)) {
      console.log(`Specify the correct template(--template) 
                   [${existsTemplates.join(', ')}]`)
      return
    }
    await run('cp', ['-r', fromRoot('templates/' + template), pname])
  })

program.command('test')
  .description('Compare answers with correct(slow) and test (fast) solution')
  .action((options) => {
    if (!(fs.existsSync(path.resolve('./cc-app.json')))) {
      console.log('Create the file "cc-app.json" in root of working folder')
    }
  })
program.parse(process.argv)
