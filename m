From: Doug Ledford <dledford@redhat.com>
Subject: Re: mdadm-2.5.4 issues and 2.6.18.1 kernel md issues
Date: Thu, 09 Nov 2006 14:33:44 -0500
Message-ID: <1163100824.4138.375.camel@fc6.xsintricity.com>
References: <1162479503.2898.338.camel@fc6.xsintricity.com>
	 <17746.48465.156017.828602@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-27zUGZjWh76DvfpjMwzL"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17746.48465.156017.828602@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-27zUGZjWh76DvfpjMwzL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2006-11-09 at 16:32 +1100, Neil Brown wrote:
> On Thursday November 2, dledford@redhat.com wrote:
> > If I use mdadm 2.5.4 to create a version 1 superblock raid1 device, it
> > starts a resync.  If I then reboot the computer part way through, when
> > it boots back up, the resync gets cancelled and the array is considered
> > clean.  This is against a 2.6.18.1 kernel.
>=20
> I cannot reproduce that (I tried exactly 2.6.18.1).
> Do you have kernel logs of the various stages?

No, I don't.  It could however be related to the fact that I built the
array, let it sync completely, then rebuilt the array with a new
superblock without doing an mdadm --zero-superblock on each device first
(I was playing with different options).  After that second build, it was
about 66% done resyncing when I decided to reboot and try out the
"restart from where it left off" feature of the version 1 superblock and
when I rebooted, to my dismay, it was marked as clean and no sync was in
progress.  So, I used mdadm to fail/remove/add the second device from
the array.  To my surprise, it went in clean *again*.  This time I think
that was intentional though, I don't think I had dirtied the array
between the fail and add, so the generation counts matched and mdadm or
the kernel decided it was safe to put it back in the array without a
resync (I know a *lot* of our customers are going to question the safety
of that...the logic may be sound, but it's going to make them nervous
when a fail/remove/add cycle doesn't trigger a resync, so I don't know
if you've documented the exact logic in use when doing that, but it's no
doubt going to fall under scrutiny).  So, the next time I did a
fail/remove/zero-superblock/add cycle and that triggered the full resync
that I wanted.  So, my guess is that because I didn't zero the
superblocks between the initial creation and recreation with a different
--name option (I think that was the only thing I changed), it may have
triggered something in the code path that detects what *should* be a
safe remove/add cycle and stopped the resync on reboot from happening.

> >=20
> > If I create a version 1 superblock raid1 array, mdadm -D <constituent
> > device> says that the device is not part of a raid array (and likewise
> > the kernel autorun facility fails to find the device).
>=20
>    mdadm -D <constituent device>
> is incorrect usage.  You want
>    mdadm -E <constituent device>
> or
>    mdadm -D <assembled array>
>=20
> in-kernel autorun does not work with version 1 metadata as it does not
> store a 'preferred minor'.

No, but it has a name, so theoretically, it could assemble it and use
the name component without regard to the minor number.  Regardless, now
that FC6 is out the door, I want to make some change for FC7 and I'm
trying to get the changes in place so we don't use autorun, so it may
very well be a moot point as far as we are concerned (although the
messages from the kernel that the devices don't have a superblock might
confuse people, I think it would be better to print out a kernel message
to the effect that autorun doesn't work on version 1 superblocks:
skipping instead of <sda1> no superblock found or whatever it says now).

> > If I create a version 1 superblock raid1 array, mdadm -E <constituent
> > device> sees the superblock.  If I then run mdadm -E --brief on that
> > same device, it prints out the 1 line ARRAY line, but it misprints the
> > UUID such that is a 10 digit hex number: 8 digit hex number: 8 digit he=
x
> > number: 6 digit hex number.
>=20
> Oops, so it does.  Fix below.  Thanks.

Thanks.

> >                              It also prints the mdadm device in the
> > ARRAY line as /dev/md/# where as mdadm -D --brief prints the device
> > as /dev/md#.  Consistency would be nice.
>=20
> It would be nice .... but how important is it really?
> If you create the same array with --name=3Dfred, then
> -Eb with give /dev/md/fred, while -Db will give /dev/md2.
> Both a right in a sense.
>=20
> Ofcourse if you say
>   mdadm -Db /dev/md/2
> then you get /dev/md/2.
> You only have /dev/md2 force on you with=20
>   mdadm -Ds
> In that case mdadm doesn't really know what name you want to use for
> the md device....  I guess it could scan /dev.

Well, given the clarification above about the difference between -D and
-E, and that no minor information is stored in version 1 superblocks, I
can see where -Eb has no choice but to use the name and omit the minor
information entirely (unless you did something like checked to see if
that array was currently assembled, and if so what minor it is currently
on, but that's overkill IMO).  However, what that means to me is that in
future products, I need to teach the OS to ignore major/minor of the
device and *only* use the name if we switch to version 1 superblocks
(which I would like to do).  The reason is that if you ever loose your
mdadm.conf file, you can't get consistent major/minor information back
by going to the device, only the name information.  So, ignore
major/minor completely, let the md stack use whatever minor it wants
from boot to boot, and rely entirely on the name the device would get
under /dev/md/ for uses in things like lvm2 configs, fstab, etc.

Now, the only question that leaves for me is some way to tell a
partitioned device from a normal device.  Obviously, this isn't
something that needs to be in upstream, but a standardized way of
telling the difference for the purpose of rescue disks and the like will
be necessary for our distribution I think.  I'm thinking that if the
name ends in _p# where # is some integer, then lop off the _p# part from
the part of the name we use when making the whole device and make a
partitioned array with that number of partitions ending in _p1 to _p#.
It would preclude the use of certain possible names, but I think that
should be sufficient.

> >=20
> > Does the superblock still not store any information about whether or no=
t
> > the array is a single device or partitionable?  Would be nice if the
> > superblock gave some clue as to that fact so that it could be used to
> > set the auto=3D param on an mdadm -E --brief line to the right mode.
>=20
> No the superblock does not store any information about where or not
> the array has partitions.  Presumably the partition table does ...
>=20
> I would recommend that if you want to do everything automatically,
> then assemble all arrays as partitionable.  Then you can use it with
> or without partitions.

I'd prefer not to go this route just in case a non-partitioned array
might end up having some bogus info that looks similar to a partitioned
array and results in out of range partitions.

> > Mdadm assumes that the --name option passed in to create an array means
> > something in particular to the md array name and modifies subsequent
> > mdadm -D --brief and mdadm -E --brief outputs to include the name optio=
n
> > minus the hostname.  Aka, if I set the name to firewall:/boot, mdadm -E
> > --brief will then print out the ARRAY line device as /dev/md//boot.  I
> > don't think this is documented anywhere.  This also raises the question
> > of how partitionable md devices will be handled in regards to their nam=
e
> > component.
>=20
> The 'Auto Assembly' section talks about this a bit, though not in the
> context of --examine.
>=20
> The documentation for --auto suggest that in the above case,
> partitions would be
>    /dev/md/boot1
>    /dev/md/boot2
>=20
> I'm always keen to improve the documentation.  What would you like
> included where?

Well, the main thing I was pointing out was that if the name matches the
filesystem's label on the device, aka /boot for the boot partition and
firewall:/boot for the md device, that mdadm double prints the slash.
That wasn't a typo in my comment, that's what mdadm does.

On a separate note, can you let me know what difference the version 1.0,
1.1, and 1.2 superblocks would make to the possible size of internal
write intent bitmaps?  With my particular disks I'm testing on, they're
about 320G each, and the intent bitmap is limited to 5 pages with
internal and superblock format 1.0.  For larger arrays, I could see
wanting a larger internal bitmap.  Do any of the other superblock
options allow for that?

Another thing I'm thinking about doing is defaulting to an mdadm setup
that precludes the information from being easily accessible when the
array isn't running.  Aka, a superblock at the beginning of the array
instead of at the end.  While being able to mount a constituent md
device when the array isn't running may be good for convenience, it
presents a special problem for consistency guarantees since you can
mount the device rw and the md stack would never know about it and not
know to resync the array should you get it repaired.  Now imagine if you
have a partitionable array, and you repartitioned the constituent device
by mistake, and then the array was reassembled.  You wouldn't know for
sure whether you would get the old or new partition.  Talk about a
nightmare.  I wouldn't worry so much about this if in my testing I
didn't have it happen to me when the initrd failed to assemble the right
array and as a result the lvm stack found its metadata on both
constituent devices and then randomly chose which one to use to start
the lvm logical volumes.  If it hadn't been for the init sequence
dropping into maintenance mode, my system would have been screwed
royally.  Bad, bad, bad, bad, bad.

If I do things the other way around, where the superblock is at the
front and shifts all data down the device, then at least that would mean
that if the array fails to start, nothing else will get found.  And a
rescue CD could always start the array in degraded mode to allow you to
get to your data, and at least when you start in degraded mode future
reboots will always know which device is up to date and which device was
left out in degraded mode and resync appropriately.

The only real problem I see with this approach is getting grub/lilo to
work with the /boot partition.  It would probably have to be taught how
to calculate the proper offset into the array depending on whether it
was partitioned or not.  So, for example, if it's not a partitioned
array, you would have to teach grub that, let's say you have your boot
data on (hd0,0), then if (hd0,0) is part of a raid array with certain
superblock types (probably have to read /proc/mdstat to know), then the
start of (hd0,0) is not the start of the partition, but instead
something like partition size in blocks - whole md device size in blocks
=3D offset into partition to start of md device, and consequently the ext
filesystem that /boot is comprised of.  If it is partitioned, then you
could teach it the notion of (hd0,0,0), aka chained partition tables,
where you use the same offset calculation above to get to the chained
partition table, then read that partition table to get the offset to the
filesystem.  I don't think it would be too difficult for grub, but it
would have to be added.  This does, however, point out that the md
stack's decision to use a geometry on it's devices that is totally
different than the real constituent device geometry means that grub
would have to perform conversions on that chained partition table to get
from md offset to real device offset.  That may not matter much in the
end, but it will have to be done.

The difference in geometry also precludes doing a whole device md array
with the superblock at the end and the partition table where the normal
device partition table would be.  Although that sort of setup is risky
in terms of failure to assemble like I pointed out above, it does have
it's appeal for certain situations like multipath or the ability to have
a partitioned raid1 device with /boot in the array without needing to
modify grub, especially on machines that don't have built in SATA raid
that dm-raid could make use of.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-27zUGZjWh76DvfpjMwzL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFU4KYTzP9PM7pjw8RAnn8AJ9tYenraD7ObgSxIvOjVF92AmqnxQCfRf+f
sb4B9qxMAO4XLjiJ0n+AyR8=
=d0VQ
-----END PGP SIGNATURE-----

--=-27zUGZjWh76DvfpjMwzL--

