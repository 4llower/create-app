#!/usr/bin/env node

const path = require('path')
const { spawn } = require('child_process')
const _ = require('lodash')
const { Command } = require('commander')
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

const existsTemplates = {
  cpp: true,
  kotlin: true,
  python: false
}

program.version('1.0.0')
  .command('init')
  .description('Inits project with chosen template')
  .requiredOption('-p, --project <project>', 'Name of initialized project')
  .requiredOption('-t, --template <template>', 'Name of initialized project')
  .action(async (options) => {
    const { template, project } = options
    if (!_.has(existsTemplates, template) || !existsTemplates[template]) {
      console.log(`Please specify the correct template(--template) 
                   [${Object.keys(existsTemplates).filter(key => !!existsTemplates[key]).join(', ')}]`)
      return
    }
    await run('cp', ['-r', fromRoot('templates/' + template), project])
  })

program.parse(process.argv)
