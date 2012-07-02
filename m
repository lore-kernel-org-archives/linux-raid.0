From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: [patch 2/3 v3] raid1: read balance chooses idlest disk for SSD
Date: Mon, 2 Jul 2012 01:33:11 -0300
Message-ID: <CABYL=Tofo65o7c5kg56v6yP-1Lf0NnkHg1EpX5cmpN-JEf-1-A@mail.gmail.com>
References: <20120702010840.197370335@kernel.org>
	<20120702011031.890864816@kernel.org>
	<CABYL=TpD7D0ec40fz6uo4LCPAKuxtkx5rD3JXfWTtuEYp3NLYQ@mail.gmail.com>
	<20120702030245.GB29770@kernel.org>
	<CABYL=TpnJpUUNouAE3QKrPj-kewZ9jE4g8PVw3jFjmTDP7hRDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABYL=TpnJpUUNouAE3QKrPj-kewZ9jE4g8PVw3jFjmTDP7hRDw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, axboe@kernel.dk
List-Id: linux-raid.ids

check that if you don=B4t what this algorithm, you could use:
distance time =3D1
read time=3D0
penalty =3D0
and it would work as today implementation... (ok must check if this
could work for single disk to full array read, but it=B4s near)

2012/7/2 Roberto Spadim <roberto@spadim.com.br>:
> hummm well that=B4s true... exist a queue inside disk hardware that w=
e
> can=B4t measure... but... if you want i can make tests to you :)
> i used a configuration a bit diferent some time ago, instead of a SSD
> and a harddisk, i used a disk with 7200rpm and a disk with 15000 the
> "time based" algorithm runs nice in this case, maybe could give just =
a
> little more 'performace' (maybe none), like i told the mean performac=
e
> that i got was 1% (i made tests with different disks speed and
> ssd+disks, i had a ocz vortex2, a sata 7200rpm (500gb) and a sas
> 15000rpm (142gb), some other guy here in kernel list tested too, but
> they didn=B4t confirmed if the performace was a mean performace or ju=
st
> a 'error' in measure
>
> when i done this i got some 'empirical' values to 'tune' the
> algorithm, i don=B4t remember all 'theory' but i done something like
> this:
>
>
> 1)  (distance * time/distance unit)
> time/distance unit,
>     i don=B4t remember distance unit, i think it=B4s 1 block =3D  512=
bytes
> right? well, just check the idea...
>     for disks:
>         total disk capacity in distance units / 1 revolution time
>         1 revolution time =3D 1/rpm for disk, for example
>               7200 rpm =3D> 120 hz =3D> 8.333ms =3D 8333us (near 10ms=
 like
> told in disk spec of random acess time)
>               15000 rpm =3D> 250hz =3D> 4ms =3D 4000us (near 5ms like=
 told
> in disk spec)
>     for ssd : 0 seconds
>         7200 =3D> 500gb (1024*1024*1024/512) / 8333 =3D   1048576000b=
locks /
> 8333us =3D 0.000'007'946'968'078 block/us
>         15000 =3D> 142gb (1024*1024*1024/512) / 4000us =3D 297795584b=
locks /
> 4000us =3D 0.000'013'432'032'625 block/us
>         ssd =3D> infinite blocks/us
>                 0.000007946 for 7200rpm,
>                 0.000013432 for 15000rpm,
>                 0 for ssd
>
>
>
> 2)(blocks to read/write * time to read/write 1 block)
>  this part i put dd to work...
>   dd if=3D/dev/sda of=3D/dev/null (there was some flags to remove cac=
he
> too but don=B4t remember now...)
>    and used iostat -d 1 -k to get mean read performace
>  i don=B4t remember the rights numbers but they was something near th=
is:
>     ssd - 230mb/s  =3D 230Mb(1024*1024)/512bytes =3D> 471040 blocks /
> second =3D  0.000'002'122 =3D> 2.122us / block
>     hd 7200 - 120mb/s =3D> 245760 blocks/second =3D> 0.000'004'069 =3D=
>
> 4.069us / block
>     hd 15000 - 170mb/s =3D> 348160 blocks/second =3D> 0.000'002'872 =3D=
>
> 2.872us / block
>
> 3) (non sequencial penalty time)
> here i used two dd to do this (some seconds between first and second =
dd)
> and got the new mb/s values
> ssd get a bit down but not much 230 -> 200
> hd 7200 120mb -> 90
> hd 15000 170 -> 150
>
> with this loses i done a 'penalty' value
> (230-200)/230 =3D 13.043%
> (120-90)/120 =3D 25%
> (170-150)/170 =3D 11.76%
>
> i don=B4t remember if i used the penalty with distance=3D0, or if i u=
sed
> it like in today implementation that select the previous disk when
> reading the full md device
>
> =3D=3D=3D=3D=3D=3D
> with this numbers.... some algorithms expected selects...
> sda=3Dssd, sdb=3D15000rpm, sdc=3D7200rpm
>
> sda|sdb|sdc
> disk positions: 0 | 0 | 0
> read 100 block at position 20000...
> sda=3D> distance =3D 20000, extimate time =3D 20000*0 + 2.122*100 + 1=
3.043%
>                 in other words...
>                         (        0 + 212.2) * 1.13043 =3D 239.877246
> sdb=3D> distance =3D 20000, extimate time =3D 20000*0.000013432 + 2.8=
72*100
> + 11.76% =3D
>                         (0.26864 + 287.2) * 1.1176 =3D 321.274952064
> sdc=3D> distance =3D 20000, extimate time =3D 20000*0.000007946 + 4.0=
69*100 + 25% =3D
>                         (0.15892 + 406.9) * 1.25 =3D 508.82365
>         HERE WE SELECT sda (239.877)
>
> disk positions: 200 | 0 | 0
> read 100 blocks at position 0...
> sda=3D> distance =3D 200, extimate time =3D 200*0 + 2.122*100 + 13.04=
3%
>                         (        0 + 212.2) * 1.13043 =3D 239.877246
> sdb=3D> distance =3D 0, extimate time =3D 0*0.000013432 + 2.872*100 +=
 0% =3D
>         (no penalty here since we are at the right place)
>                         (        0 + 287.2) * 1 =3D 287.2
> sdc=3D> distance =3D 0, extimate time =3D 0*0.000007946 + 4.069*100 +=
 0% =3D
>                         (        0 + 406.9) * 1 =3D 406.9
>         sda...
>         check that i will always select sda... since it=B4s fast for =
distance
> (0seconds) and have the highets transfer rate
>
> that=B4s here my algorithm didn=B4t worked fine... (i don=B4t know an=
ything
> about past and queue just the current read)
>
> but now... with someone that know the kernel code... we have this
> information of pendings requests =3DD
>
> i think we can go inside queue and calculate the total estimate time =
=3D), or not?
>         for each pending request we should calculate this times... an=
d sum
> the total time to select the 'best' disk
>         here i didn=B4t coded since i don=B4t know how to get informa=
tion from
> queue in kernel =3D( and my hobby ended =3D'(
>
> thanks to read....



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
