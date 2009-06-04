From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Awful RAID5 random read performance
Date: Thu, 4 Jun 2009 13:23:57 +0200
Message-ID: <20090604112357.GA2605@rap.rap.dk>
References: <20090531154159405.TTOI3923@cdptpa-omta04.mail.rr.com> <200905311056.30521.tfjellstrom@shaw.ca> <4A25754F.5030107@tmr.com> <20090602194704.GA30639@rap.rap.dk> <4A25B201.2000705@anonymous.org.uk> <4A26C313.6080700@tmr.com> <4A26D5AE.2000003@anonymous.org.uk> <878wk9q7qp.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <878wk9q7qp.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: John Robinson <john.robinson@anonymous.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Jun 04, 2009 at 12:21:02AM +0200, Goswin von Brederlow wrote:
> John Robinson <john.robinson@anonymous.org.uk> writes:
>=20
> > On 03/06/2009 19:38, Bill Davidsen wrote:
> >> John Robinson wrote:
> >>> On 02/06/2009 20:47, Keld J=F8rn Simonsen wrote:
> > [...]
> >>>> In your case, using 3 disks, raid5 should give about 210 % of th=
e
> >>>> nominal
> >>>> single disk speed for big file reads, and maybe 180 % for big fi=
le
> >>>> writes. raid10,f2 should give about 290 % for big file reads and=
 140%
> >>>> for big file writes. Random reads should be about the same for r=
aid5 and
> >>>> raid10,f2 - raid10,f2 maybe 15 % faster, while random writes sho=
uld be
> >>>> mediocre for raid5, and good for raid10,f2.
> >>>
> >>> I'd be interested in reading about where you got these figures fr=
om
> >>> and/or the rationale behind them; I'd have guessed differently...

See more on our wiki for actual benchmarks,
http://linux-raid.osdl.org/index.php/Performance
http://blog.jamponi.net/2008/07/raid56-and-10-benchmarks-on-26255_10.ht=
ml
The latter reports on arrays with 4 disks, som downscale it and you get
a good idea of expected values for 3 disks.

> >> For small values of N, 10,f2 generally comes quite close to N*Sr,
> >> where N is # of disks and Sr is single drive read speed. This is
> >> assuming fiarly large reads and adequate stripe buffer
> >> space. Obviously for larger values of N that saturates something
> >> else in the system, like the bus, before N gets too large. I don't
> >> generally see more than (N/2-1)*Sw for write, at least for large
> >> writes. I came up with those numbers based on testing 3-4-5 drive
> >> arrays which do large file transfers. If you want to read more tha=
n
> >> large file speed into them, feel free.
>=20
> With far copies reading is like reading raid0 and writing is like
> raid0 but writing twice with a seek between each. So (N/2) and (N/2-a
> bit) are the theoretical maximums and raid10 comes damn close to thos=
e.

My take on theoretical maxima is:
raid10,f2 for sequential reads: N * Sr
Raid10,f2 for sequential writes:  N/2 * Sw

>=20
> > Actually it was the RAID-5 figures I'd have guessed differently. I'=
d
> > expect ~290% (rather than 210%) for big 3-disc RAID-5 reads, and ~1=
40%
> > (rather than "mediocre") for random small writes. But of course I
> > haven't tested.
>=20
> That kind of depends on the chunk size I think.
>=20
> Say you have a raid 5 with chunk size << size of 1 track. Then on eac=
h
> disk you read 2 chunks, skip a chunk, read 2 chunks, skip a chunk. Bu=
t
> skipping a chunk means waiting for the disk to rotate over it. That
> takes as long as reading it. You shouldn't even get 210% speed.
>=20
> Only if chunk size >> size of 1 track could you seek over a
> chunk. And you have to hope that by the time you have seeked the star=
t
> of the next chunk hasn't rotated past the head yet.
>=20
> Anyone know what the size of a track is on modern disks? How many
> sectors/track do they have?

I believe Goswins analyses here is valid, skipping sectors is as
expensive as reading them.=20

Anyway, using somewhat bigger chunk sizes you may get into the effect o=
f
not reading/seeking over data, and thus go beyond the N-1 mark. As I wa=
s
trying to report best values obtainable, then I chose to report this
factor also. Actually some figures show a loss of only 0.50 for
sequential reads on raid5 with a chunk size of 2 MB.

=46or sequential writes I was asuming that you were writing 2 data stri=
pes and 1
parity stripe, and that the theoretical effective writing speed would
get close to 2 (for a 3 disk raid5). Jon's benchmark does not support
this. His best figures for raid5 is a loss of 2.25 write speed,
where I would expect somethng like a little more than 1. Maybe the fact
that the test is on raw partitions, and not on a file system with an
active elevator is in play here. Maybe it is because there is quite som=
e
calculations involved for the parity calculation, and because of no
elevator, the system have to wait for completion of parity calculation
before parity writes can be done.


=46or random writes on raid5 I reported "mediocre". This is because tha=
t
if you write randomly in raid5, you need to first read the chunk, read
the parity chunk, do updating and then write the chunk and the parity
chunk again. And you need to read full chuncks. So at most you
will something like N/4 if your data size is close to the chunk size.
If you have a big chunk size and smallish payload size than a lot of
read/writes are done on uninteresting data. This probably also goes for
other raid types, and the fs elevator may help a little here, especiall=
y
for writing.=20

In general I think raid5 random writes would be in the order of N/4
where mirrored raid types would be N/2 (with 2 copies) - making raid5
half speed of mirrored raid types like raid1 and raid10. I am not sure =
I
have data to back that statement up.

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
