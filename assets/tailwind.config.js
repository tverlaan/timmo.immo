const colors = require('tailwindcss/colors')

module.exports = {
  future: {},
  darkMode: 'media',
  purge: [
    "../lib/timmo_web/live/**/*.leex",
    "../lib/timmo_web/templates/**/*.eex",
    "../lib/timmo_web/templates/**/*.leex",
    "./js/**/*.js"
  ],
  theme: {
    extend: {
      colors: {
        brand: '#bc8d02',
        gray: colors.gray,
        golden: {
          '100': '#f8f4e6',
          '200': '#eee3c0',
          '300': '#e4d19a',
          '400': '#d0af4e',
          '500': '#bc8d02',
          '600': '#a97f02',
          '700': '#715501',
          '800': '#553f01',
          '900': '#382a01',
        },
        avocado: {
          '100': '#f1f3ef',
          '200': '#dde0d6',
          '300': '#c8cdbd',
          '400': '#9ea88c',
          '500': '#75825a',
          '600': '#697551',
          '700': '#464e36',
          '800': '#353b29',
          '900': '#23271b',
        },
      },
      screens: {
        print: { raw: 'print' }
      },
      typography: (theme) => ({
        DEFAULT: {
          css: {
            color: theme('colors.gray.600'),
            h1: { color: theme('colors.brand') },
            h2: { color: theme('colors.brand') },
            h3: { color: theme('colors.brand') },
            h4: { color: theme('colors.brand') },
            a: {
              color: theme('colors.avocado.600'),
              '&:hover': { color: theme('colors.avocado.700') }
            },
          }
        },
        lg: {
          css: {
            h2: { fontSize: '1.5em' },
            h3: { fontSize: '1.25em' }
          }
        },
        xl: {
          css: {
            h2: { fontSize: '1.5em' },
            h3: { fontSize: '1.25em' }
          }
        },
        dark: {
          css: {
            color: theme('colors.gray.400'),
            'code, strong': { color: theme('colors.gray.200') },
            pre: { backgroundColor: theme('colors.gray.900') },
            a: {
              color: theme('colors.avocado.400'),
              '&:hover': { color: theme('colors.avocado.300') }
            },

          }
        }
      })
    }
  },
  plugins: [
    require('@tailwindcss/typography'),
  ],
  variants: {
    typography: ["responsive", "dark"]
  }
}
