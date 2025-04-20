self.onmessage = function(event) {
  const { timeseries, test_frequencies, sample_rate } = event.data;
  const amplitudes = compute_correlations(timeseries, test_frequencies, sample_rate);
  self.postMessage({
    timeseries,
    frequency_amplitudes: amplitudes
  });
};

function compute_correlations(timeseries, test_frequencies, sample_rate) {
  const scale = 2 * Math.PI / sample_rate;

  return test_frequencies.map(freqObj => {
    const f = freqObj.frequency;
    let re = 0, im = 0;

    for (let t = 0; t < timeseries.length; t++) {
      const angle = scale * f * t;
      re += timeseries[t] * Math.cos(angle);
      im += timeseries[t] * Math.sin(angle);
    }

    return [re, im];
  });
}
