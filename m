From: Nagilum <nagilum@nagilum.org>
Subject: Re: RAID5 to RAID6 reshape?
Date: Sat, 23 Feb 2008 21:40:08 +0100
Message-ID: <20080223214008.hd9t63ddm0oosc8g@cakebox.homeunix.net>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>
	<18360.8065.335494.142060@tree.ty.sabi.co.UK>
	<20080217074526.29d3c5c5@hardcode42.net>
	<18361.55006.23018.546040@tree.ty.sabi.co.UK>
	<20080220073915.a1f3s54ua8ckk8gk@cakebox.homeunix.net>
	<18366.33809.731697.907687@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_5df9ku5ptjco";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18366.33809.731697.907687@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg_lxra@lxfra.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_5df9ku5ptjco
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

----- Message from pg_lxra@lxfra.for.sabi.co.UK ---------
     Date: Fri, 22 Feb 2008 08:13:05 +0000
     From: Peter Grandi <pg_lxra@lxfra.for.sabi.co.UK>
Reply-To: Peter Grandi <pg_lxra@lxfra.for.sabi.co.UK>
  Subject: Re: RAID5 to RAID6 reshape?
       To: Linux RAID <linux-raid@vger.kernel.org>


> [ ... ]
>
>>> * Suppose you have a 2+1 array which is full. Now you add a
>>> disk and that means that almost all free space is on a single
>>> disk. The MD subsystem has two options as to where to add
>>> that lump of space, consider why neither is very pleasant.
>
>> No, only one, at the end of the md device and the "free space"
>> will be evenly distributed among the drives.
>
> Not necessarily, however let's assume that happens.
>
> Since the the free space will have a different distribution
> then the used space will also, so that the physical layout will
> evolve like this when creating up a 3+1 from a 2+1+1:
>
>    2+1+1       3+1
>   a b c d    a b c d
>   -------    -------
>   0 1 P F    0 1 2 Q=09P: old parity
>   P 2 3 F    Q 3 4 5    F: free block
>   4 P 5 F    6 Q 7 8    Q: new parity
>   .......    .......
>              F F F F
                ^^^^^^^
...evenly distributed. Thanks for the picture. I don't know why you =20
are still asking after that?

> How will the free space become evenly distributed among the
> drives? Well, sounds like 3 drives will be read (2 if not
> checking parity) and 4 drives written; while on a 3+1 a mere
> parity rebuild only writes to 1 at a time, even if reads from
> 3, and a recovery reads from 3 and writes to 2 drives.
>
> Is that a pleasant option? To me it looks like begging for
> trouble. For one thing the highest likelyhood of failure is
> when a lot of disk start running together doing much the same
> things. RAID is based on the idea of uncorrelated failures...

A forced sync before a reshape is advised.
As usual a single disk failure during reshape is not a bigger problem =20
than when it happens at another time.

>   An aside: in my innocence I realized only recently that online
>   redundancy and uncorrelated failures are somewhat contradictory.
>
> Never mind that since one is changing the layout an interruption
> in the process may leave the array unusable, even if with no
> loss of data, evne if recent MD versions mostly cope; from a
> recent 'man' page for 'mdadm':
>
>  =C2=ABIncreasing the number of active devices in a RAID5 is much
>   more effort.  Every block in the array will need to be read
>   and written back to a new location.=C2=BB
>
>   From 2.6.17, the Linux Kernel is able to do this safely,
>   including restart and interrupted "reshape".
>
>   When relocating the first few stripes on a raid5, it is not
>   possible to keep the data on disk completely consistent and
>   crash-proof. To provide the required safety, mdadm disables
>   writes to the array while this "critical section" is reshaped,
>   and takes a backup of the data that is in that section.
>
>   This backup is normally stored in any spare devices that the
>   array has, however it can also be stored in a separate file
>   specified with the --backup-file option.=C2=BB
>
> Since the reshape reads N *and then writes* to N+1 the drives at
> almost the same time things are going to be a bit slower than a
> mere rebuild or recover: each stripe will be read from the N
> existing drives and then written back to N+1 *while the next
> stripe is being read from N* (or not...).

Yes, it will be slower but probably still faster than getting the data =20
off and back on again. And of course you don't need the storage for =20
the backup..

>>> * How fast is doing unaligned writes with a 13+1 or a 12+2
>>> stripe? How often is that going to happen, especially on an
>>> array that started as a 2+1?
>
>> They are all the same speed with raid5 no matter what you
>> started with.
>
> But I asked two questions questions that are not "how does the
> speed differ". The two answers to the questions I aked are very
> different from "the same speed" (they are "very slow" and
> "rather often"):

And this is where you're wrong.

> * Doing unaligned writes on a 13+1 or 12+2 is catastrophically
>   slow because of the RMW cycle. This is of course independent
>   of how one got to the something like 13+1 or a 12+2.

Changing a single byte in a 2+1 raid5 or a 13+1 raid5 requires exactly =20
two 512byte blocks to be read and written from two different disks.
Changing two bytes which are unaligned (the last and first byte of two =20
consecutive stripes) doubles those figures, but more disks are involved.

> * Unfortunately the frequency of unaligned writes *does* usually
>   depend on how dementedly one got to the 13+1 or 12+2 case:
>   because a filesystem that lays out files so that misalignment
>   is minimised with a 2+1 stripe just about guarantees that when
>   one switches to a 3+1 stripe all previously written data is
>   misaligned, and so on -- and never mind that every time one
>   adds a disk a reshape is done that shuffles stuff around.

One can usually do away with specifying 2*Chunksize.

>> You read two blocks and you write two blocks. (not even chunks
>> mind you)
>
> But we are talking about a *reshape* here and to a RAID5. If you
> add a drive to a RAID5 and redistribute in the obvious way then
> existing stripes have to be rewritten as the periodicity of the
> parity changes from every N to every N+1.

Yes, once, during the reshape.

>>> * How long does it take to rebuild parity with a 13+1 array
>>> or a 12+2 array in case of single disk failure? What happens
>>> if a disk fails during rebuild?
>
>> Depends on how much data the controllers can push. But at
>> least with my hpt2320 the limiting factor is the disk speed
>
> But here we are on the Linux RAID mailing list and we are
> talking about software RAID. With software RAID a reshape with
> 14 disks needs to shuffle around the *host bus* (not merely the
> host adapter as with hw RAID) almost 5 times as much data as
> with 3 (say 14x80MB/s ~=3D 1GB/s sustained in both directions at
> the outer tracks). The host adapter also has to be able to run
> 14 operations in parallel.

I'm also talking about software raid. I'm not claiming that my hpt232x =20
can push that much but then again it handles only 8 drives anyway.

> It can be done -- it is just somewhat expensive, but then what's
> the point of a 14 wide RAID if the host bus and host adapter
> cannot handle the full parallel bandwidth of 14 drives?

In most uses your are not going to exhaust the maximum transfer rate =20
of the disks. So I guess one would do it for the (cheap) space?

>> and that doesn't change whether I have 2 disks or 12.
>
> Not quite

See above.

> , but another thing that changes is the probability of
> a disk failure during a reshape.
>
> Neil Brown wrote recently in this list (Feb 17th) this very wise
> bit of advice:
>
>  =C2=ABIt is really best to avoid degraded raid4/5/6 arrays when at all
>   possible. NeilBrown=C2=BB
>
> Repeatedly expanding an array means deliberately doing something
> similar...

It's not quite that bad. You still have redundancy when doing reshape.

> One amusing detail is the number of companies advertising disk
> recovery services for RAID sets. They have RAID5 to thank for a
> lot of their business, but array reshapes may well help too :-).

Yeah, reshaping is putting a strain on the array and one should take =20
some precautions.

>>> [ ... ] In your stated applications it is hard to see why
>>> you'd want to split your arrays into very many block devices
>>> or why you'd want to resize them.
>
>> I think the idea is to be able to have more than just one
>> device to put a filesystem on. For example a / filesystem,
>> swap and maybe something like /storage comes to mind.
>
> Well, for a small number of volumes like that a reasonable
> strategy is to partition the disks and then RAID those
> partitions. This can be done on a few disks at a time.

True, but you loose flexibility. And how do you plan on increasing the =20
size of any of those volumes if you only want to add one disk and keep =20
the redundancy?
Ok, you could by a disk which is only as large as the raid-devs that =20
make up the colume in question, but I find it a much cleaner setup to =20
have a bunch of identically sized disks in one big array.

> For archiving stuff as it accumulates (''digital attic'') just
> adding disks and creating a large single partition on each disk
> seems simplest and easiest.

I thinks this what we're talking about here. But with your proposal =20
you have no redundancy.

>> Yes, one could to that with partitioning but lvm was made for
>> this so why not use it.
>
> The problem with LVM is that it adds an extra layer of
> complications and dependencies to things like booting and system
> management. Can be fully automated, but then the list of things
> that go wrong increases.

Never had any problems with it.

> BTW, good news: DM/LVM2 are largely no longer necessary: one can
> achieve the same effect, including much the same performance, by
> using the loop device on large files on a good filesystem that
> supports extents, like JFS or XFS.

*yeeks* no thanks, I rather use what has been made for it.
No need for another bikeshed.

> To the point that in a (slightly dubious) test some guy got
> better performance out of Oracle tablespaces as large files
> than with the usually recommended raw volumes/partitions...

Should not happen but who knows what Oracle does when it accesses =20
block devices...

----- End message from pg_lxra@lxfra.for.sabi.co.UK -----



=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 #
#   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 #
#  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   #
# /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux #
#           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 #
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..


--=_5df9ku5ptjco
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (FreeBSD)

iEYEABECAAYFAkfAhKYACgkQAKWN2UY+sLzRgACgnD9sCrnNHqu8CXeICjp6HfxO
Gp8An1erDyuM0eOkNeZeh2qxHAaxYow4
=B8OR
-----END PGP SIGNATURE-----

--=_5df9ku5ptjco--
