This is a template to create new add-on using 'Cecile Style'.

This already include:

- Version control when you are in group
- Debug windows
- Slash command
- Blizzard options
- Profile system with dual spec
- Localization English and Spanish

To create a new module:

- Add new <module>.lua in the modules folder
- Add new reference to the new file in modules/load_modules.xml
- Add new localization files
	- locales/module/<module>en_US.lua
	- locales/module/<module>es_ES.lua
- Add references to the new files in locales/modules/modules_locales.xml

- Set-up default DB options in <module>.lua

	mod.Defaults = {
		profile = {
			<variable> = <value>,
		},
		global = {
			<global_variable> = <value>,
		}
	};

- To access the variables we will do :

	Engine.Profile.<module>.<variable>

	Engine.GLOBAL.<module>.<global_variable>

- Set-up configuration options

	mod.Options = {
		order = <order in the option UI>,
		type = "group",
		name = L[<description>],
		args = {
			<ACE options widgets>
		}

	};

 - If we need to handle profile changes

	function mod.OnProfileChanged(event)

		<handle stuff, profile already updated...>

	end

- If we like to add slash command handler

	function mod.handleCommand(args)

		--has this module handle the command?
		handleIt = false;

		--if the command is '<what ever>'
		if args=="<what ever>" then

			<do stuff...>

			--this module has handle the command
			handleIt = true;

		end

		return handleIt;

	end
