with recursive aoc4_input(i) as (select '
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
'),
lines(y,line) as (
   select 0, substr(i,1,position(E'\n' in i)-1), substr(i,position(E'\n' in i)+1)
   from aoc4_input
   union all
   select y+1,substr(r,1,position(E'\n' in r)-1), substr(r,position(E'\n' in r)+1)
   from lines l(y,l,r) where position(E'\n' in r)>0
),
field(x,y,v) as (
   select x,y,substr(line,x::integer,1) as v
   from (select * from lines where line<>'') l, lateral generate_series(1,length(line)) g(x)
),
xfields(x,y) as (select x,y from field where v='X'),
mfields(x,y) as (select x,y from field where v='M'),
afields(x,y) as (select x,y from field where v='A'),
sfields(x,y) as (select x,y from field where v='S'),
msfields(x,y,v) as (select x,y,v from field where v in ('M','S')),
part1 as (
   select 1 from xfields c1, mfields c2, afields c3, sfields c4 where c1.x+1=c2.x and c1.y=c2.y and c2.x+1=c3.x and c2.y=c3.y and c3.x+1=c4.x and c3.y=c4.y
   union all
   select 1 from sfields c1, afields c2, mfields c3, xfields c4 where c1.x+1=c2.x and c1.y=c2.y and c2.x+1=c3.x and c2.y=c3.y and c3.x+1=c4.x and c3.y=c4.y
   union all
   select 1 from xfields c1, mfields c2, afields c3, sfields c4 where c1.x=c2.x and c1.y+1=c2.y and c2.x=c3.x and c2.y+1=c3.y and c3.x=c4.x and c3.y+1=c4.y
   union all
   select 1 from sfields c1, afields c2, mfields c3, xfields c4 where c1.x=c2.x and c1.y+1=c2.y and c2.x=c3.x and c2.y+1=c3.y and c3.x=c4.x and c3.y+1=c4.y
   union all
   select 1 from xfields c1, mfields c2, afields c3, sfields c4 where c1.x+1=c2.x and c1.y+1=c2.y and c2.x+1=c3.x and c2.y+1=c3.y and c3.x+1=c4.x and c3.y+1=c4.y
   union all
   select 1 from sfields c1, afields c2, mfields c3, xfields c4 where c1.x+1=c2.x and c1.y+1=c2.y and c2.x+1=c3.x and c2.y+1=c3.y and c3.x+1=c4.x and c3.y+1=c4.y
   union all
   select 1 from xfields c1, mfields c2, afields c3, sfields c4 where c1.x+1=c2.x and c1.y-1=c2.y and c2.x+1=c3.x and c2.y-1=c3.y and c3.x+1=c4.x and c3.y-1=c4.y
   union all
   select 1 from sfields c1, afields c2, mfields c3, xfields c4 where c1.x+1=c2.x and c1.y-1=c2.y and c2.x+1=c3.x and c2.y-1=c3.y and c3.x+1=c4.x and c3.y-1=c4.y
),
part2 as (
   select a.*
   from afields a, msfields d1, msfields d2, msfields d3, msfields d4
   where a.x-1=d1.x and a.y-1=d1.y and a.x+1=d2.x and a.y+1=d2.y
   and a.x-1=d3.x and a.y+1=d3.y and a.x+1=d4.x and a.y-1=d4.y
   and d1.v<>d2.v and d3.v<>d4.v
)
select (select count(*) from part1) as part1,
       (select count(*) from part2) as part2
