var BEERS = {};

BEERS.show = function(beers){
  $("#beertable tr:gt(0)").remove();

  var rows = _.map(beers, function(beer) {
    return '<tr>'
            +'<td>'+beer['name']+'</td>'
            +'<td>'+beer['style']['name']+'</td>'
            +'<td>'+beer['brewery']['name']+'</td>'
          +'</tr>';
  });
  $("#beertable").append(rows.join(''));
};

BEERS.sort_by_name = function(beers) {
  return _.sortBy(beers, function(a) { return a.name.toUpperCase(); });
}

BEERS.sort_by_style = function(beers) {
  return _.sortBy(beers, function(a) { return a.style.name.toUpperCase(); });
}

BEERS.sort_by_brewery = function(beers) {
  return _.sortBy(beers, function(a) { return a.brewery.name.toUpperCase(); });
}

$(document).ready(function () {
  _.each([["#name", BEERS.sort_by_name],
          ["#style", BEERS.sort_by_style],
          ["#brewery", BEERS.sort_by_brewery]], function(pair) {
            $(pair[0]).click(function (e) {
              BEERS.show(pair[1](BEERS.list));
              e.preventDefault();
            });
          });

  if( $("#beertable").length>0) {
    $.getJSON('beers.json', function (beers) {
      BEERS.list = beers;
      BEERS.show(beers);
    });
  };
});
