with recursive aoc25_input(i) as (select '
#####
.####
.####
.####
.#.#.
.#...
.....

#####
##.##
.#.##
...##
...#.
...#.
.....

.....
#....
#....
#...#
#.#.#
#.###
#####

.....
.....
#.#..
###..
###.#
###.#
#####

.....
.....
.....
#....
#.#..
#.#.#
#####
'),
lines(y,line) as (
   select 0, substr(i,1,position(E'\n' in i)-1), substr(i,position(E'\n' in i)+1)
   from aoc25_input
   union all
   select y+1,substr(r,1,position(E'\n' in r)-1), substr(r,position(E'\n' in r)+1)
   from lines l(y,l,r) where position(E'\n' in r)>0
),
islock(n,islock) as (
   select (y-1)>>3, substr(line,1,1)='#'
   from lines where y>0 and (y-1)%8=0
),
emptycount(n,x, c) as (
   select (y-1)>>3 as y,x,sum(case when substr(line,x::integer,1)='#' then 0 else 1 end) as c
   from (select * from lines where y>0 and line<>'') s, lateral generate_series(1,length(line)) s2(x)
   group by (y-1)>>3, x
),
depths(n,x,d) as (
   select n,x,6-c
   from emptycount natural join islock
)
select count(*)
from islock l, islock k
where l.islock=true and k.islock=false
and not exists(select * from depths d1, depths d2 where d1.n=l.n and d2.n=k.n and d1.x=d2.x and d1.d+d2.d>5)
