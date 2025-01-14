document.addEventListener('DOMContentLoaded', () => {
  document.addEventListener('click', (event) => {
    if (event.target.matches('.report-form-submit')) {
      return handleReportFormSubmit(event)
    }
  })
})

const handleReportFormSubmit = (event) => {
  event.preventDefault()

  const buttonText = event.target.value

  event.target.disabled = 'disabled'
  event.target.value = 'Downloading mileage report'
  event.target.form.submit()

  setTimeout(() => {
    event.target.disabled = false
    event.target.value = buttonText
  }, 3000)
}
