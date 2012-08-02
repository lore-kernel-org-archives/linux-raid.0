From: NeilBrown <neilb@suse.de>
Subject: Re: Version 3.2.5 and ddf issues (bugreport)
Date: Thu, 2 Aug 2012 10:05:25 +1000
Message-ID: <20120802100525.3562c590@notabene.brown>
References: <4D8A4780.2030401@gmail.com>
	<20110324090837.689c5a0e@notabene.brown>
	<5013D0FE.3020906@gmail.com>
	<20120731161115.46b96f90@notabene.brown>
	<50179B62.9020603@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/om.ySFLeDz/HubEC8mmQ7z+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50179B62.9020603@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Albert Pauw <albert.pauw@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/om.ySFLeDz/HubEC8mmQ7z+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 31 Jul 2012 10:46:26 +0200 Albert Pauw <albert.pauw@gmail.com> wrot=
e:

> On 07/31/2012 08:11 AM, NeilBrown wrote:
> > On Sat, 28 Jul 2012 13:46:06 +0200 Albert Pauw <albert.pauw@gmail.com> =
wrote:
> >
> >> Hi Neil,
> >>
> >> After a hiatus of 1.5 year (busy with all sorts) I am back and tried t=
he
> >> ddf code to see how things improved.
> > Thanks!
> >
> >> I build a VM Centos 6.3 system with 6 extra 1GB disks for testing.
> >> I found several issues in the standard installed 3.2.3 version of mdadm
> >> relating to ddf, but installed the
> >> 3.2.5 version in order to work with recent code.
> >>
> >> However, while version 3.2.3 is able to create a ddf container with
> >> raidsets in it, I found a problem with the 3.2.5 version.
> >>
> >> After initially creating the container:
> >>
> >> mdadm -C /dev/md127 -e ddf -l container /dev/sd[b-g]
> >>
> >> which worked, I created a raid (1 or 5 it doesn't matter in this case)
> >> in it:
> >>
> >> mdadm -C /dev/md0 -l raid5 -n 3 /dev/md127
> >>
> >> However, it stays on resync=3DPENDING and readonly, and doesn't get bu=
ild.
> >>
> >> So I tried to set it to readwrite:
> >>
> >> mdadm --readwrite  /dev/md0
> >>
> >> Unfortunately, it stays on readonly and doesn't get build.
> >>
> >> As said before, this did work in 3.2.3.
> >>
> >> Are you already on this problem?
> > It sounds like a problem with 'mdmon'.  mdmon needs to be running befor=
e the
> > array can become read-write.  mdadm should start mdmon automatically but
> > maybe it isn't.  Maybe it cannot find mdmon?
> >
> > could you check if mdadm is running?  If it isn't run
> >     mdmon /dev/md127 &
> > and see if it starts working.
> Hi Neil,
>=20
> thanks for your reply. Yes, mdmon wasn't running. Couldn't get it=20
> running with a recompiled 3.2.5, the standard one which came with Centos=
=20
> (3.2.3) works fine, I assume the made some changes to the code? Anyway,=20
> I moved to my own laptop, running Fedora 16 and pulled mdadm frm git and=
=20
> recompiled. That works. I also used loop devices as disks.
>=20
> Here is the first of my findings:
>=20
> I created a container with six disks, disk 1-2 is a raid 1 device, disk=20
> 3-6 are a raid 6 device.
>=20
> Here is the table shown at the end of the mdadm -E command for the=20
> container:
>=20
>   Physical Disks : 6
>        Number    RefNo      Size       Device      Type/State
>           0    06a5f547    479232K /dev/loop2      active/Online
>           1    47564acc    479232K /dev/loop3      active/Online
>           2    bf30692c    479232K /dev/loop5      active/Online
>           3    275d02f5    479232K /dev/loop4      active/Online
>           4    b0916b3f    479232K /dev/loop6      active/Online
>           5    65956a72    479232K /dev/loop1      active/Online
>=20
> I now fail a disk (disk 0) and I get:
>=20
>   Physical Disks : 6
>        Number    RefNo      Size       Device      Type/State
>           0    06a5f547    479232K /dev/loop2      active/Online
>           1    47564acc    479232K /dev/loop3      active/Online
>           2    bf30692c    479232K /dev/loop5      active/Online
>           3    275d02f5    479232K /dev/loop4      active/Online
>           4    b0916b3f    479232K /dev/loop6      active/Online
>           5    65956a72    479232K /dev/loop1      active/Offline, Failed
>=20
> Then I removed the disk from the container:
>=20
>   Physical Disks : 6
>        Number    RefNo      Size       Device      Type/State
>           0    06a5f547    479232K /dev/loop2      active/Online
>           1    47564acc    479232K /dev/loop3      active/Online
>           2    bf30692c    479232K /dev/loop5      active/Online
>           3    275d02f5    479232K /dev/loop4      active/Online
>           4    b0916b3f    479232K /dev/loop6      active/Online
>           5    65956a72    479232K                 active/Offline,=20
> Failed, Missing
>=20
> Notice the active/Offline status, is this correct?
>=20
> I added the disk back into the container, NO zero-superblock:
>=20
>   Physical Disks : 6
>        Number    RefNo      Size       Device      Type/State
>           0    06a5f547    479232K /dev/loop2      active/Online
>           1    47564acc    479232K /dev/loop3      active/Online
>           2    bf30692c    479232K /dev/loop5      active/Online
>           3    275d02f5    479232K /dev/loop4      active/Online
>           4    b0916b3f    479232K /dev/loop6      active/Online
>           5    65956a72    479232K /dev/loop1      active/Offline,=20
> Failed, Missing
>=20
> It stays active/Offline (this is now correct I assume), Failed (again=20
> correct if had failed before), but also still missing.
>=20
> I remove the disk again, do a zero-superblock and add it again:
>=20
> Physical Disks : 6
>        Number    RefNo      Size       Device      Type/State
>           0    06a5f547    479232K /dev/loop2      active/Online
>           1    47564acc    479232K /dev/loop3      active/Online
>           2    bf30692c    479232K /dev/loop5      active/Online
>           3    275d02f5    479232K /dev/loop4      active/Online
>           4    b0916b3f    479232K /dev/loop6      active/Online
>           5    ede51ba3    479232K /dev/loop1      active/Online, Rebuild=
ing
>=20
> This is correct, the disk is seen as a new disk and rebuilding starts.
>=20
>=20
> Regards,
>=20
> Albert

Hi Albert,

thanks for this and your other reports.
I won't be able to look at them for a while, but hopefully will get back to
you some time next week.

NeilBrown

--Sig_/om.ySFLeDz/HubEC8mmQ7z+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUBnERTnsnt1WYoG5AQKcAhAAnE6ToeMjYce2FOwk+DVPHMKU0KPjb/M3
2HAVPECE2QmHPT0vQVXEh/KedPnzDpEngKRKpjPVLMjE7g7v/B/VwSqHejXW78XI
mD92SxybSRYM9aP49ow+QRhLxclP4FroBxxpaUauL0jlOpyouJJz6VGYkO0NvNkE
nHSIbYGQIU+PLymft/A4BcAq8CJszlgzS3+BHuV92ispPBt58ej/F3d7W5nQ2AtP
93bP3Nbx6SX7FICIU8yHCU3gGEiQ5lt4lIezTmt84bAC5QsVbcX+nQL3SC7l5cWo
/cee4yUGUhVXX8LfNwwhx2Oi5MXHxamtvpJv+ZgQApmKtbFmDds+QInrqJohwmOV
7kz23s9VGQ+gRJLwbBkBXd1pAgdsO8TK8F8Vf0ScaTunj4b0Zd01zSzFWenTuRMi
gscuonul3jFd5kETdrpJQfGO0fVWW5gl6rOUV3anGOQNHx7Cl2KpcGBTMHBFcnwu
nJaHNVissjrZcA8jv8vbn0gYDucdstlBwR4V/iOD8gmhxg+Xoh5w3zYE1fh/sKs8
NsMWDn7oMoBk1DrmODJffMKqfOQAjF0lnXcbevh0jBqLkAllbvBPryNaZWKZSHgz
HJb+KQxQIHcMpDbLjh8emjDkZcElF3nBJ/y8z8d0xn2tlJG0RThQsrh5cy5cL+H+
EoOlE30wCok=
=sfKm
-----END PGP SIGNATURE-----

--Sig_/om.ySFLeDz/HubEC8mmQ7z+--
