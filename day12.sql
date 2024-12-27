with recursive aoc12_input(i) as (select '
RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE
'),
lines(y,line) as (
   select 0, substr(i,1,position(E'\n' in i)-1), substr(i,position(E'\n' in i)+1)
   from aoc12_input
   union all
   select y+1,substr(r,1,position(E'\n' in r)-1), substr(r,position(E'\n' in r)+1)
   from lines l(y,l,r) where position(E'\n' in r)>0
),
field(x,y,v) as (
   select x::smallint,y::smallint,substr(line,x::integer,1)
   from (select * from lines l where line<>'') s, lateral generate_series(1,length(line)) g(x)
),
neighbors(dx,dy,d) as (values(1::smallint,0::smallint,0),(0::smallint,1::smallint,1),(-1::smallint,0::smallint,2),(0::smallint,-1::smallint,3)),
flood(x,y,r,v) as (
   select x,y,200*x+y,v from field
   union
   select f.x,f.y,r,fl.v
   from flood fl, neighbors n, field f
   where fl.x+dx=f.x and fl.y+dy=f.y and fl.v=f.v),
mapped_field(x,y,v) as (select x,y,min(r) as v from flood group by x,y),
perimeter(x,y,d,r) as (
   select case when d%2=0 then f1.x else f1.y end, case when d%2=0 then f1.y else f1.x end, d, f1.v
   from (mapped_field f1 cross join neighbors) left join mapped_field f2 on f1.x+dx=f2.x and f1.y+dy=f2.y
   where f1.v is distinct from f2.v
),
area(r,c) as (select v, count(*) from mapped_field group by v),
perimeter_len(r,v) as (select r, count(*) from perimeter group by r),
edge_count(r,v) as (
   select r, count(*)
   from perimeter p1
   where not exists (select * from perimeter p2 where p2.x=p1.x and p2.y=p1.y-1 and p2.r=p1.r and p2.d=p1.d)
   group by r)
select (select sum(c*v) from area natural join perimeter_len) as part1,
       (select sum(c*v) from area natural join edge_count) as part2
