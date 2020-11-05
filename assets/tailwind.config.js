// tailwind.config.js
module.exports = {
  future: {
    removeDeprecatedGapUtilities: true,
    purgeLayersByDefault: true,
  },
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
      }
    },
    typography: (theme) => ({
      default: {
        css: {
          h1: { color: theme('colors.brand') },
          h2: { color: theme('colors.brand') },
          h3: { color: theme('colors.brand') },
          h4: { color: theme('colors.brand') },
          a: { color: theme('colors.avocado.600') },
          'a:hover': { color: theme('colors.avocado.700') }
        }
      },
      lg: {
        css: {
          h2: { fontSize: '1.25em' },
          h3: { fontSize: '1.125em' }
        }
      },
      xl: {
        css: {
          h2: { fontSize: '1.25em' },
          h3: { fontSize: '1.125em' }
        }
      }
    })
  },
  plugins: [
    require('@tailwindcss/typography'),
  ]
}
