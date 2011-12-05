From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: RAID1 round robin read support in md?
Date: Mon, 5 Dec 2011 10:28:54 -0200
Message-ID: <CABYL=TpNk57nska4cwOgL9RyF7ez23DKx9sAd9XNGFFVBSjy4Q@mail.gmail.com>
References: <CAAs5ODuHAE=K-nbd=YuMq-FL33x-22TM2cnmBHud9mEhwuJFOw@mail.gmail.com>
	<CALFpzo48C2-HHgw=iOefdHaAUCwEJfjoiXjq=Ngv62a-0yEpcQ@mail.gmail.com>
	<CAAs5ODv01LE6HRZjteYYsaMF5stTNv-8pdK9JDP18u4QeNGUOQ@mail.gmail.com>
	<CALFpzo7WqkXNF9DcCNJn_D1ZP=Jgpb85u6H=5_KPONQMy7FpYQ@mail.gmail.com>
	<CAAs5ODtObyOaSebofD-Kf2HcYU_7zRv0+oUmWPnnzU=gYn24Ug@mail.gmail.com>
	<CAFx4rwRKUvVaJtCv=+qurYp9C7V5iJKn0MhO-aJFsB3Fs5VjEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFx4rwRKUvVaJtCv=+qurYp9C7V5iJKn0MhO-aJFsB3Fs5VjEw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: doug@easyco.com
Cc: Borg Onion <borg.onion@gmail.com>, Marcus Sorensen <shadowsor@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

check this old topic... (kernel 2.6.37 i think)
http://www.spadim.com.br/raid1/
http://www.issociate.de/board/post/507493/raid1_new_read_balance,_first=
_test,_some_doubt,_can_anyone_help?.html


but you will not have a veeeery big read speed....
raid1 is for multi thread work
raid10 far is for less threads with more sequencial reads
check what is better to you

this code at top of email, implement a round robin, if you do each
read one device you will have a slow md device, but changing to
10,100,1000 reads to change device, is better (i think the problme is
cpu use or another problem... must check with iostat and others
statistics softwares)

2011/12/5 Doug Dumitru <doug@easyco.com>
>
> What you are seeing is very SSD specific.
>
> With rotating media, it is very important to intentionally stay on on=
e
> disk even if it leaves other mirrors quiet. =A0Rotating disks do "in =
the
> drive" read-ahead and take advantage of the heads being on the correc=
t
> track, so streaming straight-line reads are efficient.
>
> With SSDs in an array, things are very different. =A0Drives don't rea=
lly
> read ahead at all (actually they do, but this is more of a side effec=
t
> of error correction than performance tuning, and the lengths are
> short). =A0If your application is spitting out 4MB read requests, the=
y
> get cut into 512K (1024 sector) bio calls, and sent to a single drive
> if they are linear. =A0Because the code is optimized for HDDs, future
> linear calls should go to the same drive because an HDD is very likel=
y
> to have at least some of the read sectors in the read-ahead cache.
>
> A different algorithm for SSDs would be better, but one concern is
> that this might slow down short read requests in a multi-threaded
> environment. =A0Actually managing a mix intelligently is probably bes=
t
> started with a Google literature search for SSD scheduling papers. =A0=
I
> suspect that UCSD's super-computing department might have done some
> work in this area.
>
> With the same data available from two drives, for low thread count
> applications, it might be better to actually cut up the inbound
> requests into even smaller chunks, and send them in parallel to the
> drives. =A0A quick test on a Crucial C300 shows the following transfe=
r
> rates at different block sizes.
>
> 512K =A0319 MB/sec
> 256K =A0299 MB/sec
> 128K =A0298 MB/sec
> 64K =A0287 MB/sec
> 32K =A0275 MB/sec
>
> This is with a single 'dd' process and 'iflag=3Ddirect' bypassing lin=
ux
> read-ahead and buffer caching. =A0The test was only a second long or =
so,
> so the noise could be quite high. =A0Also, C300s may behave very
> differently with this workload than other drives, so you have to test
> each type of disk.
>
> What this implies is that if the md raid-1 layer "were to be" SSD
> aware, it should consider cutting up long requests and keeping all
> drives busy. =A0The logic would be something like:
>
> * If any request is >=3D 32K, split it into 'n' parts', and issue the=
m
> in parallel.
>
> This would be best implemented "down low" in the md stack.
> Unfortunately, the queuing where requests are collated, happens below
> md completely (I think), so there is no easy point to insert this.
>
> The idea of round-robin scheduling the requests is probably a little
> off-base. =A0The important part is, with SSDs, to cut up the requests
> into smaller sizes, and push them in parallel. =A0A round-robin might
> trick the scheduler into this sometimes, but is probably only an
> edge-case solution.
>
> This same logic applies to raid-0, raid-5/6, and raid-10 arrays. =A0W=
ith
> HDDs is is often more efficient to keep the stripe size large so that
> individual in-drive read-ahead is exploited. =A0With SSDs, smaller
> stripes are often better (at least on reads) because it tends to keep
> all of the drive busy.
>
> Now it is important to note that this discussion is 100% about reads.
> SSD writes are a much more complicated animal.
>
> --
> Doug Dumitru
> EasyCo LLC
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html




--
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
