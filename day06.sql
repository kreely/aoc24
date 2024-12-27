with recursive aoc6_input(i) as (select '
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
'),
lines(y,line) as (
   select 0, substr(i,1,position(E'\n' in i)-1), substr(i,position(E'\n' in i)+1)
   from aoc6_input
   union all
   select y+1,substr(r,1,position(E'\n' in r)-1), substr(r,position(E'\n' in r)+1)
   from lines l(y,l,r) where position(E'\n' in r)>0
),
rawfield(x,y,v) as (
   select x::smallint,y::smallint,substr(line,x::integer,1)
   from lines l, lateral generate_series(1,length(line)) g(x)
),
field(x,y,v) as (select x,y,case when v='^' then '.' else v end from rawfield),
startpos(x,y) as (select x,y from rawfield where v='^'),
bounds(maxx,maxy) as (select max(x) as maxx, max(y) as maxy from field),
directions(dd,dx,dy) as (values(0,0::smallint,-1::smallint),(1,1::smallint,0::smallint),(2,0::smallint,1::smallint),(3,-1::smallint,0::smallint)),
part1(px,py,pd) as (
   select x,y,0 from startpos
   union all
   select case when s then px+dx else px end, case when s then py+dy else py end, case when s then pd else (pd+1)%4 end
   from (select *, f.v is distinct from '#' as s
      from (part1 p join directions d on pd=dd) left join field f on f.x=px+dx and f.y=py+dy), bounds b
      where px>0 and py>0 and px<=maxx and py<=maxy
),
part1pos(vx,vy) as (select distinct px, py from part1, bounds where px>0 and py>0 and px<=maxx and py<=maxy),
candidates(vx,vy) as (select * from part1pos, startpos where vx<>x or vy<>y)
select (select count(*) from part1pos) as part1,
    (select count(*) from
     candidates where not exists (
     with recursive part2(px,py,pd) as (
        select x,y,0 from startpos
        union
        select case when s then px+dx else px end, case when s then py+dy else py end, case when s then pd else (pd+1)%4 end
        from (select *, (f.v is distinct from '#' and ((px+dx<>vx) or (py+dy<>vy))) as s
            from (part2 p join directions d on pd=dd) left join field f on f.x=px+dx and f.y=py+dy), bounds b
            where px>0 and py>0 and px<=maxx and py<=maxy
        )
    select * from part2, bounds where px<1 or py<1 or px>maxx or py>maxy
    )) as part2
