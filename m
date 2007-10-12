From: Nagilum <nagilum@nagilum.org>
Subject: Re: Help RAID5 reshape Oops / backup-file
Date: Fri, 12 Oct 2007 08:43:28 +0200
Message-ID: <20071012084328.2f6vk4cdw80kscw0@cakebox.homeunix.net>
References: <20071011142518.igm1jud7ms408ggg@cakebox.homeunix.net>
	<18190.46828.156191.300754@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_6de10qlsseck";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18190.46828.156191.300754@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_6de10qlsseck
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

----- Message from neilb@suse.de ---------
     Date: Fri, 12 Oct 2007 09:51:08 +1000
     From: Neil Brown <neilb@suse.de>
Reply-To: Neil Brown <neilb@suse.de>
  Subject: Re: Help RAID5 reshape Oops / backup-file
       To: Nagilum <nagilum@nagilum.org>
       Cc: linux-raid@vger.kernel.org


> On Thursday October 11, nagilum@nagilum.org wrote:
>> Ok, after looking in "Grow.c" I can see that the backup file is
>> removed once the critial section has passed:
>>
>> =09=09if (backup_file)
>> =09=09=09unlink(backup_file);
>>
>> =09=09printf(Name ": ... critical section passed.\n");
>>
>> Since I had passed that point I'll try to find out where
>> Grow_restart() stumbles. By looking at it I'm not even sure it's able
>> to "resume" and not just restart. :-/
>>
>
> It isn't a problem that you didn't specify a backup-file.
> If you don't, mdadm uses some spare space on one of the new drives.
> After the critical section has passed, the backup file isn't needed
> any longer.
> The problem is that mdadm still wants to find and recover from it.
>
> I throughly tested mdadm restarting from a crash during the critical
> section, but it looks like I didn't properly test restarting from a
> later crash.
>
> I think if you just change the 'return 1' at the end of Grow_restart
> to 'return 0' it should work for you.
>
> I'll try to get this fixed properly (and tested) and release a 2.6.4.
>
> NeilBrown
>


----- End message from neilb@suse.de -----

Thanks, I changed Grow_restart as suggested, now I get:
nas:~/mdadm-2.6.3# ./mdadm -A /dev/md0 /dev/sd[a-e]
mdadm: /dev/md0 assembled from 3 drives and 2 spares - not enough to =20
start the array.

nas:~/mdadm-2.6.3# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : inactive sda[0] sde[6] sdd[5] sdc[2] sdb[1]
       2441543360 blocks

unused devices: <none>

which is similar to what the old mdadm is telling me.
I'll try to find out where it gets the idea these are spares..
Would it be a good idea to update to vanilla 2.6.23 instead of running =20
Debian Etch's 2.6.18-5?
If there is anything I can do to help with v2.6.4 let me know!
Thanks,
Alex.

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


--=_6de10qlsseck
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (FreeBSD)

iD8DBQBHDxePAKWN2UY+sLwRAsCJAJ41xl0UiVYJ60fn+upqJOVeGJwy6QCdGkX6
NRG+pcSDk7JD26X0oRIsH8M=
=gYnW
-----END PGP SIGNATURE-----

--=_6de10qlsseck--
