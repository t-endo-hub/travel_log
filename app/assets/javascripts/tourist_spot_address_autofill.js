$(function () {
  return $("#tourist_spot_postcode").jpostal({
    postcode: ["#tourist_spot_postcode"],
    address: {
      "#tourist_spot_prefecture_code": "%3",
      "#tourist_spot_address_city": "%4",
      "#tourist_spot_address_street": "%5%6%7"
    }
  });
});