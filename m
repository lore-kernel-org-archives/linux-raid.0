From: Doug Ledford <dledford@redhat.com>
Subject: Re: Auto Rebuild on hot-plug
Date: Tue, 30 Mar 2010 11:53:59 -0400
Message-ID: <4BB21E97.1020406@redhat.com>
References: <20100325113543.0e2124c5@notabene.brown>	 <905EDD02F158D948B186911EB64DB3D11C510278@irsmsx503.ger.corp.intel.com> <e9c3a7c21003261737k1e753b08xc6f8eb45d0320be9@mail.gmail.com> <4BB0ED13.6020507@redhat.com> <4BB0F32F.9030803@anonymous.org.uk> <4BB0F820.4030707@redhat.com> <4BB12B77.8030902@anonymous.org.uk> <4BB13942.3030400@redhat.com> <4BB1EA4F.5070803@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig72C56A9A34795A25136536F5"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB1EA4F.5070803@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, Neil Brown <neilb@suse.de>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig72C56A9A34795A25136536F5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/30/2010 08:10 AM, John Robinson wrote:
> On 30/03/2010 00:35, Doug Ledford wrote:
>> On 03/29/2010 06:36 PM, John Robinson wrote:
>>> On 29/03/2010 19:57, Doug Ledford wrote:
>>>> On 03/29/2010 02:36 PM, John Robinson wrote:
>>> [...]
>>>>> Yes, but do create the partition(s), boot sector, etc and set up th=
e
>>>>> spare(s).
>>>> Really, we should never have to do this in the situation I listed: a=
ka
>>>> no degraded arrays exist.  This implies that if you had a raid1 /boo=
t
>>>> array, that it's still intact.  So partitioning and setting up boot
>>>> loaders doesn't make sense as the new disk isn't going in to replace=

>>>> anything.  You *might* want to add it to the raid1 /boot, but we don=
't
>>>> know that so doing things automatically doesn't make sense.
>>> Actually I've just recently had the scenario where it would have made=

>>> perfect sense. I hooked up the RAID chassis SATA[0-4] ports to the RA=
ID
>>> chassis and put 3 drives in the first 3 slots. Actually it turned out=

>>> I'd wired it up R-L not L-R so if I'd added a new drive in one of the=

>>> two right-hand slots it would have turned up as sda on the next boot.=

>>
>> Yes, but how do you want to fix that situation?  Would you want to mak=
e
>> the new drives be new boot drives, or would you prefer to shut down,
>> move all the previous drives over two slots, and then put the new driv=
e
>> into the fourth slot that you previously thought was the second slot? =
 I
>> understand your situation, but were I in that position I'd just shuffl=
e
>> my drives to correct my original mistake and go on with things, I
>> wouldn't make the new drives be boot drives.  So I'm still not sure I
>> see the point to making a new drive that isn't replacing an existing
>> drive automatically get set up for boot duty.
>=20
> I wouldn't want to take the server down to shuffle the drives or cables=
=2E
> But my point really is that if I have decided that I would want all the=

> drives in my chassis to have identical partition tables and carry an
> active mirror of an array - in my example /boot - I would like to be
> able to configure the hotplug arrangement to make it so, rather than
> leaving me to have to manually regenerate the partition table, install
> grub, add the spare and perhaps even grow the array.

I can (sorta) understand this.  I personally never create any more /boot
partitions than the number of drives I can loose from my / array + 1.
So, if I have raid5 / array, I do 2 /boot partitions.  Anything more is
a waste since if you loose both of those boot drives, you also have too
few drives for the / array.  But, if you want any given drive bootable,
that's possible.  However...see below for an issue relating to this.

> Of course this is a per-installation policy decision of what to do when=

> an extra drive is added to a non-degraded array, I'm certainly not
> suggesting this should be the default action, though I think it would b=
e
> nice if it were possible to configure an action in this case.
>=20
>>> OK, to some extent that's me being stupid, but at the same time I
>>> correctly hooked up the first 5 SATA ports to the hot-swap chassis an=
d
>>> would want them considered the same group etc.
>>
>> I understand wanting them in the same group, but unless something is
>> degraded, just being in the same group doesn't tell us if you want to
>> keep it as a spare or use it to grow things.
>=20
> I quite agree. All I'm getting at is that I'd like to be able to say
> something in my mdadm.conf or wherever to say what I'd like done. This
> might mean that I end up something like the following:
> DOMAIN path=3Dpci-0000:00:1f.2-scsi-[0-4]:0:0:0       action=3Dinclude
> DOMAIN path=3Dpci-0000:00:1f.2-scsi-[0-4]:0:0:0-part1 action=3Dgrow
> DOMAIN path=3Dpci-0000:00:1f.2-scsi-[0-4]:0:0:0-part2 action=3Dreplace
> DOMAIN path=3Dpci-0000:00:1f.2-scsi-[0-4]:0:0:0-part3 action=3Dinclude

This I'm not so sure about.  I can try to make this a reality, but the
issue here is that when you are allowed to specify things on a partition
by partition basis, it becomes very easy to create conflicting commands.
 For example, lets say you have part1 action=3Dgrow, but for the bare dis=
k
you have action=3Dincremental.  And let's assume you plug in a bare disk.=

 In order to honor the part1 action=3Dgrow, we would have to partition th=
e
disk, which is in conflict with the bare disk action of incremental
since that implies we would only use preexisting md raid partitions.  I
could *easily* see the feature of allowing per partition actions causing
the overall code complexity to double or more.  You know, I'd rather
provide a simple grub script that automatically setup all raid1 members
as boot devices any time it was ran than try to handle this
automatically ;-)  Maybe I should add that to the mdadm package on
x86/x86_64, something like mdadm-grub-install or similar.

> The first line gets the partition table and grub boot code regenerated
> even when nothing's degraded. This in turn may trigger the other lines.=

> In the second line my action=3Dgrow means fix up my /boot if it's degra=
ded
> and both --add and --grow so it gets mirrored onto a fresh disc. The
> third lines says fix up my swap array if it's degraded, but leave alone=

> otherwise. The fourth line says fix up my data array if it's degraded,
> and add as a spare if it's a fresh disc. This last lets me decide later=

> what (if any) kind of --grow I want to do - make it larger or reshape
> from RAID-5 to RAID-6.

As pointed out above, some of these are conflicting commands in that
they tell us to modify the disk in one place, and leave it alone in
another.  The basic assumption you are making here is that we will
always be able to duplicate the partition table because all drives in a
domain will have the same partition table.  And that's not always the cas=
e.

> But as you say, the default should be
> DOMAIN path=3D* action=3Dincremental
>=20
> and the installer (automated or human) probably wants to edit that to
> include at least
> DOMAIN path=3Dsomething action=3Dreplace
> to take advantage of this auto-rebuild on hot-plug feature.
>=20
> Sorry if I'm being long-winded, but hopefully you can see how I'd like
> to be able to configure things. In the first instance, though, just
> getting as far as the replace option would be great.

I see where you are going, I'm a little worried about getting there ;-)


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig72C56A9A34795A25136536F5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuyHpcACgkQg6WylM+/8ZRslgCdFjCqYzyqoxU64Iz1pxoRz7Ew
Bf8AnRA9LI4aeL3nZl6nIBI7DUhj4yxq
=Rl4m
-----END PGP SIGNATURE-----

--------------enig72C56A9A34795A25136536F5--
