function random(n) {
    return Math.floor(Math.random()*n)
}

function pair_line(len) {
    var pl = '({[<\\';
    var pr = {'(':')', '{':'}', '[':']', '<':'>', '\\':'/'}

    var n = len / 2;
    var l = '';
    for(var i=0; i<n; i++)
	l += pl[random(pl.length)];

    var lr = l.split('').reverse().join('')
    var r = '';
    for(var i=0; i<n; i++)
	r += pr[lr[i]];

    return l + r;
}

var l = 4;
var h = 64;

document.write('<div id="logo">');
document.write('<pre>');
document.write(pair_line(random(h)+l) + '<br>');
document.write(pair_line(random(h)+l) + '<br>');
document.write(pair_line(random(h)+l) + '<br>');
document.write(pair_line(random(h)+l) + '<br>');
document.write('</pre>');
document.write('</div>');
