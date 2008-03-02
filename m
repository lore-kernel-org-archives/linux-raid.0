From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: 2x6 or 3x4 raid10 arrays ?
Date: Sun, 2 Mar 2008 01:30:57 +0100
Message-ID: <20080302003057.GA6958@rap.rap.dk>
References: <1204195554.16924.16.camel@franck-gusty> <loom.20080228T223023-79@post.gmane.org> <20080301204020.GC10278@rap.rap.dk> <loom.20080301T213935-669@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <loom.20080301T213935-669@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Nat Makarevitch <nat@makarevitch.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Mar 01, 2008 at 10:05:06PM +0000, Nat Makarevitch wrote:
> Keld J=F8rn Simonsen <keld <at> dkuug.dk> writes:
>=20
> > I believe that a full chunk is read for each read access.
>=20
> I've read various definitions for "chunk". Is a "stripe" a 'cluster' =
(in the
> "group of disk sectors" meaning) on a single physical drive (device, =
let's say
> "spindle"), and a 'chunk' a set of stripes made with a single stripe =
of each
> spindle? For what I understand this is the definition used in the 'md=
' world
> (see 'man mdadm'), therefore I will use it thereafter.

I have understood chunk to be a set of sectors on a single device.
If it was to be understood as a set of space on multiple devices, then
the chunk size would normaly be relative to the number of devices
involved. And that is not what we talk about in eg mdadm chunk=3D256

> Yes, AFAIK a full chunk is concerned by each access.

Given your definition of chunk, I do not beleve so. A read of a chunk o=
n
eg a 12 device raid, would not involve 12 reads, one on each device.

> > This would lead to that it is not important whether to use=20
> > two arrays of 6 disks each, or 3 arrays of 4 disks each.=20
> > Or for that sake 1 array of 12 disks.
>=20
> I beg to disagree. Creating more than one array may be OK when you ve=
ry
> precisely know your load profile per table, but in most cases this is=
 not true,
> or this profile will vary, therefore your best bet is "to maintain, f=
or each
> request, as much disk heads available as possible", carpet-bomb the a=
rray with
> all requests and let the elevator(s) optimize. Another way to see it,=
 in some
> reciprocal way, is to say that you don't want to have any head sleepi=
ng when
> there is a request to serve.=20

This is for bigger operations. I believe that for smaller operations,
such as a random read in a database, you would only like to have one IO
operation on one device. Seek times are important here. You can in one
average seek time of say 10 milliseconds on SATA-II transfer 800 kB
data, which is much more than normal size of a record in a table.
Having 12 operations for a record of say 1 kB would be very expensive.
The elevator is better of serving a number of concurrent requests.

> > Some other factors may be more important: such as the ability to su=
rvive
> > disk crashes
>=20
> That's very true, however one may not neglect logistics. If I'm prett=
y sure that
> I can change a spindle in less than 2 hours after a failure I will pr=
efer using
> all disks less one on a single array and letting the last one as a co=
nnected
> (but powered off) spare. The alarm trips, some automatic or manual pr=
ocedure
> powers the spare and mounts it in the array, while the procedure aimi=
ng at
> physically extracting the failed device and replacing it (it will bec=
ome the new
> spare) rolls. With more latency-prone logistics one may reserve more =
disks as
> spares.

Yes, rebuild time would also be a factor. Smaller raids are quicker to
rebuild, I think. Or maybe this is irrelevant, at least for raid10,f2 -
as rebuilding is done concurrently from all devices involved, and
probebly limited by the write speed of the replacing device.

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
