From: Nagilum <nagilum@nagilum.org>
Subject: Re: Help RAID5 reshape Oops / backup-file
Date: Mon, 15 Oct 2007 13:55:22 +0200
Message-ID: <20071015135522.xjds82zo08cgc08c@cakebox.homeunix.net>
References: <20071011142518.igm1jud7ms408ggg@cakebox.homeunix.net>
	<18190.46828.156191.300754@notabene.brown>
	<20071012084328.2f6vk4cdw80kscw0@cakebox.homeunix.net>
	<20071014185550.d6hbv2bk00kkwkgc@cakebox.homeunix.net>
	<18194.42699.193194.986448@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_361o8kwry7eo";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18194.42699.193194.986448@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_361o8kwry7eo
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

----- Message from neilb@suse.de ---------
     Date: Mon, 15 Oct 2007 09:31:23 +1000
     From: Neil Brown <neilb@suse.de>
Reply-To: Neil Brown <neilb@suse.de>
  Subject: Re: Help RAID5 reshape Oops / backup-file
       To: Nagilum <nagilum@nagilum.org>
       Cc: linux-raid@vger.kernel.org


> On Sunday October 14, nagilum@nagilum.org wrote:
>> Can someone tell me if I'm on the right track?
>> I've now noticed the following:
>> # ~/mdadm-2.6.3/mdadm -v -A /dev/md0 /dev/sd[d-e]
>> mdadm: looking for devices for /dev/md0
>> mdadm: /dev/sdd is identified as a member of /dev/md0, slot -1.
>> mdadm: /dev/sde is identified as a member of /dev/md0, slot -1.
>> mdadm: No suitable drives found for /dev/md0
>
> Hmm... that might be useful..
>
> I just found your earlier email where you said:
>
>> After the machine came back up (on a rescue disk) I thought I'd
>> simply have to go through the process again. So I use add add the
>> new disk again.
>> Although that worked, I am now unable to resume the growing
>> process.
>
> Using "add add" again was not correct, and should not have been
> possible.
> You should have simply assembled the array with the full new set of
> devices.  Then reshape would have automatically restarted properly.
>
> Can you remember *exactly* what you did?  If I can reproduce the
> situation, I can find the best way to fix it and send you something to
> try.
>
> NeilBrown
>

----- End message from neilb@suse.de -----

Sure, here it goes:
The system is running Debian Etch ia64, kernel 2.6.18,
(since the exact versions might be important in this case I made =20
copies of what I deemed to be relevant available online)
a copy of the "linux/drivers/md" folder of that particular kernel can =20
be found at:
   http://www.nagilum.de/md/md

Etch comes with mdadm-2.5.6 + Debian patches.
See http://www.nagilum.de/md/mdadm-2.5.6/debian/changelog
I made the whole Debian Package available here:
  http://www.nagilum.de/md/
  - "mdadm-2.5.6" the extracted source with Debian patches applied
  -  mdadm_2.5.6-9.diff.gz the diff to mdadm_2.5.6.orig.tar.gz
  -  mdadm_2.5.6-9_i386.deb the i385 version of the package, however I =20
was/am using  mdadm_2.5.6-9_ia64.deb
  - "mdadm_2.5.6-9.dsc" description file for building the .deb

The Raid was being reshaped from three to five drives when the =20
shutdown was issued. I assume the shutdown went normally since the =20
machine was off and there was no power interruption.
Upon booting the system it became apparent that the RAID was non functional.
The system boots off of a USB stick and then mounts its root =20
filesystem from the RAID. Assembling the RAID happens within the =20
initrd. The relevant scripts can be found here: =20
http://www.nagilum.de/md/local-top/
I booted a rescue disk which is based on the identical Linux version.
I looked at the "mdadm -Q --detail /dev/md0" output and saw only 3 of =20
the 5 disks in the RAID. Then I did (what I should not have done) the =20
add of the two new disks, assuming that mdadm will touch these in a =20
harmful way (without using --force) and refuse to do so if that's not =20
the way to add active disk.
The disks were added but the reshape did not continue.
Up until now I can't think of anything else I did that could have =20
changed something. (and "mdadm -Q --detail /dev/md0" looks the same =20
ever since)
I think, what I should have done instead of adding those disks would =20
have been to either use --re-add and/or update /etc/mdadm/mdadm.conf. =20
But then again I never expected this to become so problematic. :(
By now I can also boot with 2.6.23 (I'll update to 2.6.23.1 shortly) =20
and I have the latest mdadm tools (in parallel to the old ones).
I also build the test_stripe utility and tried a very briefly the =20
"test" argument, but it wanted me to specify an existing file so I =20
chickened out. ;)
Thanks a lot for looking into this!
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


--=_361o8kwry7eo
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (FreeBSD)

iD8DBQBHE1UqAKWN2UY+sLwRAgloAJ4q3KZsLTpx7wEzUS0/B2WPMbUokwCfTfah
pjRnC+11bCrapJAVY5/vuME=
=hcpM
-----END PGP SIGNATURE-----

--=_361o8kwry7eo--
