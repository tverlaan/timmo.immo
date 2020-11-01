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
        brand: '#b58900',
        golden: {
          '50': '#f9f7ea',
          '100': '#faf3c7',
          '200': '#f5ea85',
          '300': '#efd93f',
          '400': '#e2bd13',
          '500': '#d79d06',
          '600': '#be7904',
          '700': '#9a5b07',
          '800': '#79460d',
          '900': '#61380f',
        }
      }
    },
    typography: (theme) => ({
      default: {
        css: {
          'h1, h2, h3, h4, h5, h6': { color: theme('colors.brand') }
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
