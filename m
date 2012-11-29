From: NeilBrown <neilb@suse.de>
Subject: Re: System runs with RAID but fails to reboot [explanation?]
Date: Thu, 29 Nov 2012 12:45:09 +1100
Message-ID: <20121129124509.55f3194b@notabene.brown>
References: <1353517137.5795.55.camel@corn.betterworld.us>
	<20121122155236.0e7689c6@notabene.brown>
	<1353716131.18439.29.camel@corn.betterworld.us>
	<1353973722.7078.51.camel@markov.biostat.ucsf.edu>
	<20121127131527.4d0d81d5@notabene.brown>
	<1354071275.27664.90.camel@corn.betterworld.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tWuwcGminDCVy2EFv.MvV=+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1354071275.27664.90.camel@corn.betterworld.us>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Boylan <ross@biostat.ucsf.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/tWuwcGminDCVy2EFv.MvV=+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Nov 2012 18:54:35 -0800 Ross Boylan <ross@biostat.ucsf.edu> wrot=
e:

> It still doesn't seem to me the 1 device arrays should have been
> started, since they were inconsistent with mdadm.conf and not subject to
> incremental assembly.  This is an understanding problem, not an
> operational problem: I'm glad the arrays did come up.  Details below,
> along with some other questions.

Probably "mdadm -As"  couldn't find anything to assemble based on the
mdadm.conf file, so tried to auto-assemble anything it could find without
concern for the ARRAY details in mdadm.conf.

>=20
>=20
> On Tue, 2012-11-27 at 13:15 +1100, NeilBrown wrote:
> > On Mon, 26 Nov 2012 15:48:42 -0800 Ross Boylan <ross@biostat.ucsf.edu> =
wrote:
> >=20
> > > I may have an explanation for what happened, including why md0 and md1
> > > were treated differently.
> > > On Fri, 2012-11-23 at 16:15 -0800, Ross Boylan wrote:
> > > > On Thu, 2012-11-22 at 15:52 +1100, NeilBrown wrote:
> > > > > On Wed, 21 Nov 2012 08:58:57 -0800 Ross Boylan <ross@biostat.ucsf=
.edu> wrote:
> > > > >=20
> > > > > > I spent most of yesterday dealing with the failure of my (md) R=
AID
> > > > > > arrays to come up on reboot.  If anyone can explain what happen=
ed or
> > > > > > what I can do to avoid it, I'd appreciate it.  Also, I'd like t=
o know if
> > > > > > the failure of one device in a RAID 1 can contaminate the other=
 with bad
> > > > > > data (I think the answer must be yes, in general, but I can hop=
e).
> > > > > >=20
> > > > > > In particular, I'll need to reinsert the disks I removed (descr=
ibed
> > > > > > below) without getting everything screwed up.
> > > > > >=20
> > > > > > Linux 2.6.32 amd64 kernel.
> > > > > >=20
> > > > > > I'll describe what I did for md1 first:
> > > > > >=20
> > > > > > 1. At the start, system has 3 physically identical disks. sda a=
nd sdc
> > > > > > are twins and sdb is unused, though partitioned. md1 is a raid1=
 of sda3
> > > > > > and sdc3.  Disks have DOS partitions.
> > > > > > 2. Add 2 larger drives to the system.  They become sdd and sde.=
  These 2
> > > > > > are physically identical to each other, and bigger than the fir=
st batch
> > > > > > of drives.
> > > > > > 3. GPT format the drives with larger partitions than sda.
> > > > > > 4. mdadm --fail /dev/md1 /dev/sdc3
> > > > > > 5. mdadm --add /dev/md1 /dev/sdd4.  Wait for sync.
> > > > > > 6. madadm --add /dev/md1 /dev/sde4.
> > > > > > 7. mdadm --grow /dev/md1 -n 3.  Wait for sync.
> > > > > >=20
> > > > > > md0 was same story except I only added sdd (and I used partitio=
ns sda1
> > > > > > and sdd2).
> > > > > >=20
> > > > > > This all seemed to be working fine.
> > > > > >=20
> > > > > > Reboot.
> > > > > >=20
> > > > > > System came up with md0 as sda1 and sdd2, as expected.
> > > > > > But md1 was the failed sdc3 only.  Note I did not remove the pa=
rtition
> > > > > > from md1; maybe I needed to?
> > > First, the Debian initrd I'm using does recognize GPT partitions, and=
 so
> > > unrecognized partitions did not cause the problem.
> > >=20
> > > Second, the initrd executes mdadm --assemble --scan --run --auto=3Dye=
s.
> > > This uses conf/conf.d/md and etc/mdadm/mdadm.conf.   The latter inclu=
des
> > > --num-devices for each array.
> >=20
> > Yes, having an out-of-date "devices=3D" in mdadm.conf would cause the p=
roblems
> > you are having.  You don't really want that at all.
> I've removed the num-devices=3D2 from mdadm.conf.
> >=20
> >=20
> > >                                 Since I did not regenerate this after
> > > changing the array sizes, it was 2 for both arrays.  man mdadm.conf s=
ays
> > > ARRAY  The ARRAY lines identify actual arrays.  The second word on  t=
he
> > >     line  should  be  the name of the device where the array is nor-
> > >     mally assembled, such as /dev/md1.   Subsequent  words  identify
> > >     the  array,  or  identify  the  array as a member of a group. If
> > >     multiple identities are given,  then  a  component  device  must
> > >     match  ALL  identities  to be considered a match. [ num-devices is
> > > one of the identity keywords].
> > >=20
> > > This was fine for md0 (unless it should have been 3 because of the
> > > failed device),=20
> >=20
> > It should be the number of "raid devices"  i.e. the number of active de=
vices
> > when the array is optimal.  It ignores spares.
>=20
> This recent report seems slightly inconsistent with that description:
> mdadm --examine --scan
> ARRAY /dev/md0 level=3Draid1 num-devices=3D3 UUID=3D313d5489:7869305b:c42=
90e12:319afc54
> ARRAY /dev/md1 level=3Draid1 num-devices=3D3 UUID=3Db77027df:d6aa474a:c42=
90e12:319afc54
>    spares=3D1
> and mdadm --detail /dev/md1 shows, in part,
>  Rebuild Status : 0% complete
>=20
>            UUID : b77027df:d6aa474a:c4290e12:319afc54
>          Events : 0.5075732
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8        3        0      active sync   /dev/sda3
>        1       8       20        1      active sync   /dev/sdb4
>        3       8       36        2      spare rebuilding   /dev/sdc4
> I would expect md1 to show either num-devices=3D2 and spares=3D1 or -num-=
devices=3D3 and no spares,
> with the latter being better if the output is fed into mdadm.conf.

The correct size of the array is 3, so devices=3D3 is correct.

Quite separately from that, there is one device which is not failed and not
part of the array, so it is a spare.  "spares=3D1".

So really it is correct.

>=20
> >=20
> > >                 and at least consistent with the metadata on sdc3,
> > > formerly part of md1.  It was inconsistent with the metadata for md1 =
on
> > > its current components, sda3, sdd4, and sde4, all of which indicates a
> > > size of 3 (or 4 if failed devices count).
> > >=20
> > > I do not know if the "must match" logic applies to --num-devices (sin=
ce
> > > the manual says the option is mainly for compatibility with the output
> > > of --examine --scan), nor do I know if the --run option overrides the
> > > matching requirement.  But md0's components might match the num-devic=
es
> > > in mdadm.conf, while md1's current components do not match. md1's old
> > > commponent does match.
> >=20
> > Yes, "must match" means "must match".
> >=20
> > And this is exactly what md1's old component was made into an array whi=
le the
> > new components were ignored.
> >=20
> > >=20
> > > I don't know if, before all that, udev triggers attempts to assemble
> > > arrays incrementally.=20
> Review of my system and the source code both indicate no incremental
> assembly was attempted.
> >  Nor do I know how such incremental assembly works
> > > when some of the candidate devices are out of date.
> >=20
> > "mdadm -I" (run from udev) pays more attention to the uuid than "mdadm =
-A"
> > does - it can only assemble one array with a given uuid. (mdadm -A will
> > sometimes assemble 2.  That is the bug I mentioned in a previous email =
which
> > will be fixed in mdadm-3.3).
> >=20
> > So it would see several devices with the same uuid, but some are incons=
istent
> > with mdadm.conf so would be rejected (I think).
> Suppose there were no inconsistency, e.g., because mdadm.conf was in its
> new form and had no num-devices.  And suppose udev was attempting
> incremental assembly.  Then what happens if components with inconsistent
> time stamps are presented for assembly?  Especially, what happens if the
> older one is added first?  You said that incremental assembly will not
> make 2 md devices with the same UUID, but that leaves many possibilities
> open.

It won't start the array until it finds everything it expects.
If it find the old device it will still expect another one (because that
device thinks there are two working devices in the array).
When it find the new device, it will discard the old one because it is olde=
r,
will note that the new device thinks everything else has failed, and so will
start the array with just that one device.

>=20
> My hope is that mdadm recognizes the inconsistency and kicks out the
> older components.

Sure does.

>=20
> >=20
> > >=20
> > > So the mismatch between the array size for md0, but not md1, might
> > > explain why md0 came up as expected, but md1 came up as a single, old
> > > partition instead of the 3 current ones.
> md1 came up using sdc3 only; sdc3's metadata says it was in a 2 device
> array, but the resulting array had only one device.  So the "must match"
> condition is on the array component's metadata, not the array.  This is
> consistent with the man page statement that the matching is done for the
> "component device."

Yep.

> >=20
> > s/might/does/
> >=20
> >=20
> > >=20
> > > However, it is awkward for this account that after I set the array si=
zes
> > > to 1 for both md0 and md1 (using partitions from sda)--which would be
> > > inconsistent with the size in mdadm.conf--they both came up.  There w=
ere
> > > fewer choices at that point, since I had removed all the other disks.
> >=20
> > I guess that as "all" the devices with a given UUID were consistent, md=
adm -I
> > accepted them even as "not present in mdadm.conf".
> Here's the problem. mdadm -I did not run, and the num-devices in the
> component metadata was 1, which did not match mdadm.conf.
>=20
> So why did the arrays come up anyway?

mdadm does 'auto assembly' both with "mdadm -I" and "mdadm -As".
I was assuming it was the former, but maybe it is the latter.

Can you shut down the arrays will the system is still up (obviously not if
one holds '/').
If so you could try that, then

 mdadm -Asvvv

and see what it says.


NeilBrown


>=20
> Ross
>=20
> >=20
> > >=20
> > > Third, my recent experience suggests something more is going on, and
> > > perhaps the count considerations just mentioned are not that importan=
t.
> > > I'll put what happened at the end, since it happened after everything
> > > else described here.
> > > > > >=20
> > > > > > Shutdown, removed disk sdc for the computer.  Reboot.
> > > > > > /md0 is reassembled to but md1 is not, and so the system can no=
t not
> > > > > > come up (since root is on md0).  BTW, md1 is used as a PV for L=
VM; md0
> > > > > > is /boot.
> > > > > >=20
> > > > > > In at least some kernels the GPT partitions were not recognized=
 in the
> > > > > > initrd of the boot process (Knoppix 6--same version of the kern=
el,
> > > > > > 2.6.32, as my system, though I'm not sure the kernel modules ar=
e same as
> > > > > > for Debian).  I'm not sure if the GPT partitions were recognize=
d under
> > > > > > Debian in the initrd, though they obviously were in the running=
 system
> > > > > > at the start.
> > > > >=20
> > > > > Well if your initrd doesn't recognise GPT, then that would explai=
n your
> > > > > problems.
> > > > I later found, using the Debian initrd, that arrays with fewer than=
 the
> > > > expected number of devices (as in the n=3D paramter) do not get act=
ivated.
> > > > I think that's what you mean by "explain your problems." Or did you=
 have
> > > > something else in mind?
> > > >=20
> > > > At least I  think I found arrays with missing parts are not activat=
ed;
> > > > perhaps there was something else about my operations from knoppix 7
> > > > (described 2 paragraps below this) that helped.
> > > >=20
> > > > The other problem with that discovery is that the first reboot acti=
vated
> > > > md1 with only 1 partition, even though md1 had never been configured
> > > > with <2.
> > > >=20
> > > > Most of my theories have the character of being consistent with some
> > > > behavior I saw and inconsistent with other observed behavior.  Poss=
ibly
> > > > I misperceived or misremembered something.
> > > > >=20
> > > > > >=20
> > > > > > After much trashing, I pulled all drives but sda and sdb.  This=
 was
> > > > > > still not sufficient to boot because the md's wouldn't come up.=
 md0 was
> > > > > > reported as assembled, but was not readable.  I'm pretty sure t=
hat was
> > > > > > because it wasn't activated (--run) since md was waiting for the
> > > > > > expected number of disks (2).  md1, as before, wasn't assembled=
 at all.=20
> > > > > >=20
> > > > > > >From knoppix  (v7, 32 bit) I activated both md's and shrunk th=
em to size
> > > > > > 1 (--grow --force -n 1).  In retrospect this probably could hav=
e been
> > > > > > done from the initrd.
> > > > > >=20
> > > > > > Then I was able to boot.
> > > > > >=20
> > > > > > I repartitioned sdb and added it to the RAID arrays.  This led =
to hard
> > > > > > disk failures on sdb, though the arrays eventually were assembl=
ed.  I
> > > > > > failed and removed the sdb partitions from the arrays and shrun=
k them.
> > > > > > I hope the bad sdb has not screwed up the good  sda.
> > > > >=20
> > > > > Its not entirely impossible (I've seen it happen) but it is very =
unlikely
> > > > > that hardware errors on one device will "infect" the other.
> > > > Our local sysadmin also believes the errors in sdb were either
> > > > corrected, or resulted in an error code, rather than ever sending b=
ad
> > > > data back.  I'm proceeding on the assumption sda is OK.
> > > > >=20
> > > > > >=20
> > > > > > Thanks for any assistance you can offer.
> > > > >=20
> > > > > What sort of assistance are you after?
> > > > I'm trying to understand what happened and how to avoid having it h=
appen
> > > > again.
> > > >=20
> > > > I'm also trying to understand under what conditions it is safe to i=
nsert
> > > > disks that have out of date versions of arrays in them.
> > > >=20
> > > > >=20
> > > > > first questions is: does the initrd handle GPT.  If not, fix that=
 first.
> > > > That is the first thing I'll check when I'm at the machine.  The pr=
oblem
> > > > with the "initrd didn't recognize GPT theory" was that in my very f=
irst
> > > > reboot md0 was assemebled from two partitions, one of which was on =
a GPT
> > > > disk. (another example of "all my theories have contradictory evide=
nce")
> > > >=20
> > > > Ross
> > > After running for awhile with both RAIDs having size 1 and using sda
> > > exclusively, I shut down the sytem, removed the physically failing sd=
b,
> > > and added the 2 GPT disks, formerly known as sdd and sde.  sdd has
> > > partitions that were part of md0 and md1; sde has a partition that was
> > > part of md1.  For simplicity I'll continue to refer to them as sdd and
> > > sde, even though they were called sdb and sdc in the new configuratio=
n.
> > >=20
> > > This time, md0 came up with sdd2 (which is old) only and md1 came up
> > > correctly with sda3 only.  Substantively sdd2 and sda1 are identical,
> > > since they hold /boot and there have been no recent changes to it. =20
> > >=20
> > > This happened across 2 consecutive boots.  Once again, the older devi=
ce
> > > (sdd2) was activated in preference to the newer one (sda1).
> > >=20
> > > In terms of counts for md0, mdadm.conf continued to indicate 2; sda1
> > > indicates 1 device; and sdd2 indicates 2 devices + 1 failed device.
> >=20
> > That is why mdadm preferred sdd2 to sda1 - it matched mdadm.conf better.
> >=20
> > I strongly suggest that you remove all "devices=3D" entries from mdadm.=
conf.
> >=20
> > NeilBrown
> >=20
> >=20
> > >=20
> > > BTW, by using break=3Dbottom as a kernel parameter one can interrupt =
the
> > > initrd just after mdadm has run and see if the mappings are right.  F=
or
> > > the 2nd boot I did just that, and then manually shutdown md0 and brou=
ght
> > > it back with sda1.  The code appears to offer break=3Dpost-mdadm as an
> > > alternative, but that did not work for me (there was no break).  These
> > > are Debian-specific tweaks, I believe.
> > >=20
> > > Ross
> >=20


--Sig_/tWuwcGminDCVy2EFv.MvV=+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBULa+JTnsnt1WYoG5AQKV2g/+NQ7keYuKM9YIigvf2jFn4POOkR99GQce
ppc0/ZVJ/boyTvrijJ8olJ2rzH5AerzZZowc6/FPsJyc6Xa9VBdm98bFti0uW0f3
4N7hvaBDEHYD0E2u4NbzWtFGcuc4fNRbBcwzOwkmXBITUuMNIvXeIozaZWqKwwIV
us2eEAziMxq/MDtKAoiqqSRLpr4WJMw1xN2Xj2LeTMbl/Z24zDvkzp+xWFvtm1NC
xupp/PeBj8lt7Y6YhcRUKLVZsNSia8N2RaNV9OzFJN5yyKp4nWhrNzA5gwqRHfeT
XNLLZb56Igif+/F9ue7KgmrNLQx6YGEno74UFeD4lf435UL4NkP9RkL0b7sZgZYz
bxEtGLKdSPTrC3J5o7zRfvsiVXsGzAWXO7vLhK18mEKKyto/egusXDrUTHaabE/b
YAf9I/Gyu8IYphuDaCZUmyUPq9MMK1nifawo60qR3xaGTik1PhEJLN/w2vEekeYF
1yPYuJqsP4T2QOKWfTq643uhueJEel2iWndvTJr88F2PgcstA1r5957LoiMpYlGm
lDoUhYdwkydnHnHymn5e0oHBM6Aoya/eBGXCGyNfcfDZUugCeaROL5HP98G8OD6V
BGdWnXN7V2jLuJHhw2wi8CvVur7SBL6NaC1LQGEqXGOBbvDI2b/Mzv2+lbsEEMOm
tCcTCVzhw9Y=
=YI28
-----END PGP SIGNATURE-----

--Sig_/tWuwcGminDCVy2EFv.MvV=+--
