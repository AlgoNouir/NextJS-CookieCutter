# --------------------------------+
#           preinstalling         |
# --------------------------------+

# loger function clear all outputs and echo steps
logs=()
function echoLog {
    clear
    logs+=("$1")
    for logStr in "${!logs[@]}"; do
        echo "${logs[logStr]} ($((logStr + 1))/5)"
    done
    return
}

# get app name and set it to defualt
read -r -p "app name:(app) " appName
if [[ -z "${appName}" ]]; then
    appName="app"
fi

# --------------------------------+
#         install expo app        |
# --------------------------------+

# install blank typescript expo app
npx create-expo-app "$appName" --typescript
cd "$appName" || exit

echoLog "✅ $appName install done"
# --------------------------------+
#         create home page        |
# --------------------------------+

# create home file
cat > "./pages/index.tsx" <<- EOM
// base
import * as React from "react";

export default function Home(props: NativeStackScreenProps<pagesType, "home">) {
    return (
        <div className="w-screen h-screen items-center justify-center">
            <label>your app is ready !!!</label>
        </div>
    );
}
EOM


mkdir components

# --------------------------------+
#   install and config tailwind   |
# --------------------------------+

echo "installing tailwind ..."

# install tailwind
npm install tailwindcss
npm install prettier prettier-plugin-tailwindcss
npx tailwindcss init


# config tailwind
cat > "./tailwind.config.js" <<- EOM
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './App.{js,jsx,ts,tsx}', 
    './pages/**/*.{js,jsx,ts,tsx}', 
    './components/**/*.{js,jsx,ts,tsx}'
  ],
  theme: {
    colors: {
        primary: "#EDEDED",
        secondary: "#3C414A",
        background: "#EDEDED",
        card: "#FFF",
        text: "#3C414A",
        border: "#3C414A99",
        notification: "#AEBC4A",
        error: "#C4716C",
        success: "#1DC322",
        info: "#3A5290",
        warning:"#E7B10A",
    
        white: "#FFF",
        black: "#000",
        red: "#C4716C",
        green: "#AEBC4A",
        blue: "#3A5290",
    },
  },
  plugins: [],
}
EOM

# create core folder for export tailwind
mkdir core
cat > "./core/index.ts" <<- EOM
export const colors = require("../tailwind.config").theme.colors
EOM

echoLog "✅ nativewind install done"

# --------------------------------+
#    install navigation and set   |
# --------------------------------+

echo "installing redux ..."

# install dependencies
npm install @reduxjs/toolkit react-redux

# create file
mkdir store
cat > "./store/store.ts" <<- EOM
import {
  Action,
  configureStore,
  ThunkAction,
} from '@reduxjs/toolkit';

export const store = configureStore({
  reducer: {
// This is where we add reducers.
// Since we don't have any yet, leave this empty
  },
});

export type AppDispatch = typeof store.dispatch;
export type RootState = ReturnType<typeof store.getState>;
export type AppThunk<ReturnType = void> = ThunkAction<
   ReturnType,
   RootState,
   unknown,
   Action<string>
 >;
EOM

cat > "./store/HOCs.ts" <<- EOM
import {
  TypedUseSelectorHook,
  useDispatch,
  useSelector,
} from 'react-redux';
import type {
  AppDispatch,
  RootState,
} from './store';

export const useAppDispatch = () => useDispatch<AppDispatch>();
export const useAppSelector: TypedUseSelectorHook<RootState> = useSelector;
EOM

echoLog "✅ redux install done"

# --------------------------------+
#        git init and commit      |
# --------------------------------+
echo "initial git and commit ..."

git init
git add -A
git commit -m "install the project via cookie"

echoLog "✅ git commited"

echo "happy hacking!!! 👑"