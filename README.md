<div align="center">

# `Phoenix LiveView` Realtime Cursor Tracking Tutorial

Learn how to create a **simple cursor tracking app** using **Phoenix LiveView** </br>
and _learn_ it step-by-step!

</div>

# Why? 🤷

As we're building our [MVP](https://github.com/dwyl/mvp),
we are always trying to leverage the _awesome_ real-time
features of `Phoenix` and `LiveView`. 

Live cursor tracking will enable _us_ to create a
team-friendly environment in w hich users will _know_
what the others are doing.

# What? 💭

This tutorial creates a stylized simple landing page
showing the cursor of everyone that is connected
to it. It should take you no less than 30 minutes
to get up and running!

# Who? 👤

This tutorial is aimed at LiveView beginners 
who want to understand the ins and outs, while 
sparkling a bit of [TailwindCSS](https://tailwindcss.com/)
magic :sparkles:.

If you are completely new to Phoenix and LiveView,
we recommend you follow the **LiveView _Counter_ Tutorial**:
https://github.com/dwyl/phoenix-liveview-counter-tutorial

### Prerequisites  - this is what you need before you start
This tutorial requires you have `Elixir` and `Phoenix` installed.
If you you don't, please see [how to install Elixir](https://github.com/dwyl/learn-elixir#installation)
and [Phoenix](https://hexdocs.pm/phoenix/installation.html#phoenix).

# How? 💻

## Step 0: Run the finished app locally
To get a feel of what you are going to build and
to be _make sure_ it's working in 1 minute, do the
following steps:

### Clone the repo
Run the following commands to clone the repo.

```
git clone https://github.com/dwyl/phoenix-liveview-realtime-cursor-tracking-tutorial.git
cd phoenix-liveview-realtime-cursor-tracking-tutorial
```

### Download the Dependencies

Install the dependencies by running the command:

```sh
mix setup
```

This will download dependencies and
compile your files. It might take a few
minutes!

### Run the App

Start the Phoenix server by running the command:

```sh
mix phx.server
```

Now you can visit
[`localhost:4000`](http://localhost:4000)
in your web browser.

> 💡 Open a _second_ browser window (**in incognito mode**, if you want to),
> and you will see the a new cursor with a new name!

## Step 1: Create the App 🆕

In your terminal run the following `mix` command
to generate the new Phoenix app:

```sh
mix phx.new live_cursors --no-ecto
```

This command will setup the dependencies (including the liveView dependencies)
and boilerplate for us a Phoenix project without
a database. 

When you see the following prompt in your terminal, 
press `Y` to install the dependencies.

```sh
Fetch and install dependencies? [Yn]
```

Type <kbd>Y</kbd> followed by the <kbd>Enter</kbd> key.
That will download all the necessary dependencies.

### Setting up TailwindCSS
We are going to be using TailwindCSS to style our page. 
If this is the first time using TailwindCSS, you 
can check [our tutorial](https://github.com/dwyl/learn-tailwind)
for a primer. 

The reason we are using TailwindCSS is is to showcase you
how to also integrate a *mature* styling library and
get it running with Phoenix so you can create your 
own awesome and beautiful web pages :smile:.

#### Installing TailwindCSS
Let's first add the TailwindCSS depedency to our project,
by opening the `mix.exs` file and adding
the following line to the `deps` section:

```elixir
{:tailwind, "~> 0.1.9", runtime: Mix.env() == :dev},
```

Next, in the `config?config.exs` file, 
let's specify the Tailwind version we are 
going to be using.

```elixir
config :tailwind,
  version: "3.2.0",
  default: [
      args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
      ),
      cd: Path.expand("../assets", __DIR__)
  ]
```

Now, simply run the following command to install
the dependency:


```sh
mix deps.get
```

And then run the following Tailwind tasks. These 
will download the standalone Tailwind CLI and 
generate a `tailwind.config.js` file
in the `./assets` directory.

#### Setup watcher, minification and loading Tailwind
Throughout development we want Tailwind CLI 
to track our files for changes. For this, add
the following watcher in `onfig/dev.exs` file.

```elixir
  watchers: [
    //...
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]},
  ]
```

After developing our application, we want tailwind to 
minify our CSS files in production. For this to happen,
update the following line in the `mix.exs` file.

```elixir
  defp aliases do
    [
      setup: ["deps.get"],
      "assets.deploy": ["esbuild default --minify", "tailwind default --minify", "phx.digest"]
    ]
  end
```

All we have to do now is make sure tailwind classes
are loaded in our `assets/css/app.css`. The tasks
you ran previously probably already took care of this,
but make sure you have these added to your file.

```elixir
@import "tailwindcss/base";
@import "tailwindcss/components";
@import "tailwindcss/utilities";

//@import "./phoenix.css";   -> deleted
```

Also make sure your `assets/js/app.js`
was changed as well. Make sure the 
`import "../css/app.css";` line is commented
or removed.

After all of this, you should be done! You can 
start styling your webpages with some sweet CSS :tada:.



setup do tailwind com o debug e o porque de termos a view separada
PRESENCE GUARDA EM COOKIES
MOSTRAR A CRASHAR, LIMPAR COOKIES, VOLTAR