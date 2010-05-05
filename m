From: Doug Ledford <dledford@redhat.com>
Subject: Re: converting to raid - Error 2
Date: Wed, 05 May 2010 12:25:15 -0400
Message-ID: <4BE19BEB.1040009@redhat.com>
References: <4BDB4076.7010909@vorgon.com> <4BDB4358.80009@redhat.com> <4BDB5268.8050102@vorgon.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE648DF61880B90C1D01FF7C1"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BDB5268.8050102@vorgon.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Timothy D. Lenz" <tlenz@vorgon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE648DF61880B90C1D01FF7C1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/30/2010 05:58 PM, Timothy D. Lenz wrote:
>=20
>=20
> On 4/30/2010 1:53 PM, Doug Ledford wrote:

>> You can't use the setup macro (can't remember why, I just know it
>> generally doesn't work) when putting grub on your raid1 array.  You ne=
ed:
>>
>> install --stage2=3D/grub/stage2 /grub/stage1 (hd0) /grub/e2fs_stage1_5=

>> /grub/stage2 /grub/grub.conf
>>
>> and if that doesn't work in your particular configuration, you can add=

>> the d option after stage1 and before (hd0), but if you use it, then yo=
ur
>> boot disk must always be BIOS device 0x80, which means setting your BI=
OS
>> to boot off of some disk other than the first disk found usually won't=

>> work and instead you just have to make whatever disk you want to boot
>> off of the first disk found by the BIOS.  You can switch (hd0) to
>> (hd0,0) if you want and if you have a normal DOS master boot record.
>>
>>>   grub>device (hd0) /dev/sdb
>>>   grub>root (hd0,0)
>>>   grub>setup (hd0)
>>>
>>> To copy the current boot drive hda1 over to md0, I use a GRML boot di=
sk,
>>> mount /dev/md0 to /mnt/md0 and /dev/sdd1 (/dev/hda1) to /mnt/sdd1,
>>> then do:
>>>
>>> rsync -caHh --progress --delete /mnt/sdd1/ /mnt/md0.
>>>
>>> Then I reboot normally. I have 2 copies of /boot/grub/device.map,
>>> /boot/grub/menu.lst and /etc/fstab. one for normal boot and one for
>>> raid. On /mnt/md0 I swap the normal boot files for the raid files by
>>> adding .old to the names of normal boot and removing .raid from the r=
aid
>>> versions. Then reboot again and in cmos move the pata drive to the
>>> bottom of the list so cmos tries the sata drives first. That worked f=
or
>>> the 32bit linux 2 drive system. But on this 64bit 3 drive I get:
>>>
>>> Grub loading stage 1.5
>>> Grub loading, please wait
>>> Error 2
>>>
>>> I can't remove the 3rd drive because it has part of md2 and I shouldn=
't
>>> need to anyway. Copies of the above mentioned files I put at:
>>> http://24.255.17.209:2400/vdr/local/raid/
>=20
> grrr, used reply instead of reply all again, sorry:
>=20
> I don't understand why using those commands at the grub> prompt won't
> work. It worked on the other computer.

Can't answer that for you.  I didn't bother to work out *why* it didn't
work, just that it's known to fail in some situations (the setup
command).  Maybe it's because it pulls information from the device map
and gets the device line wrong (and yes, the setup macro redoes whatever
device line you put in based upon the information in the device map
file).  Maybe it's something else.  Regardless, it's known to fail.

> This is grub 1, not grub 2.

Yes, my instructions were for grub1.

> I
> haven't updated it yet. It is using lenny. I did start the upgrade to
> grub2 on the other computer a short time ago, but haven't yet done the
> final command to finish the change. Trying to solve one thing at a time=

> and right now this is the oldest. I don't recall ever doing any install=

> --stage2=3D/grub/st.... on the other system.
>=20
> Here is what I get when I do this for sda:
> ---------------------------------------
> grub> device (hd0) /dev/sda
>=20
> grub> root (hd0,0)
>  Filesystem type is ext2fs, partition type 0xfd
>=20
> grub> setup (hd0)
>  Checking if "/boot/grub/stage1" exists... yes
>  Checking if "/boot/grub/stage2" exists... yes
>  Checking if "/boot/grub/e2fs_stage1_5" exists... yes
>  Running "embed /boot/grub/e2fs_stage1_5 (hd0)"...  15 sectors are
> embedded.
> succeeded
>  Running "install /boot/grub/stage1 (hd0) (hd0)1+15 p
> (hd0,0)/boot/grub/stage2 /boot/grub/menu.l
> st"... succeeded
> Done.
> ---------------------------------------

I know, it looks fine.  But it screws it up anyway.  It isn't reliable.
 You have to use the bare install command like I pointed out above.  You
also need to make sure that your boot partitions on the two drives are
*identical* in terms of placement on the drives (aka, the partitions
need to occupy the same logical sector numbers on both drives, which is
normal when they are both the first partition on each drive and the
drives use the same sector/head counts per track which is typical now a
days).

> And I just noticed something.I used sda, not sda1. I can't remember
> which I did before with the other, but my notes show sda. Would that
> matter?

Normally sda would be the one I would use, but sda1 would work as long
as you have a normal DOS master boot record on the drive.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigE648DF61880B90C1D01FF7C1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkvhm+sACgkQg6WylM+/8ZSLKACeKOXvjxF4xbjamkkxMTrDFxg1
CeQAn3epjoQ0/BO9ISnvX+V+c+xZxUpt
=DfAi
-----END PGP SIGNATURE-----

--------------enigE648DF61880B90C1D01FF7C1--
