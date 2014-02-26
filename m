From: NeilBrown <neilb@suse.de>
Subject: Re: Cannot assemble DDF raid
Date: Wed, 26 Feb 2014 17:10:36 +1100
Message-ID: <20140226171036.76faa1a1@notabene.brown>
References: <5306D567.2010304@meebox.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//+CGdz=t+.hU_ukRjoeSgK9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5306D567.2010304@meebox.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Iversen <ci@meebox.net>
Cc: linux-raid@vger.kernel.org, "[meebox] Anders Eiler" <ace@meebox.net>
List-Id: linux-raid.ids

--Sig_//+CGdz=t+.hU_ukRjoeSgK9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 21 Feb 2014 05:26:15 +0100 Christian Iversen <ci@meebox.net> wrote:

> (please CC, not on the list currently)
>=20
> I'm trying to recover from a 2-disk RAID5 failure on a Dell PERC=20
> controller running:
>=20
>    2 x 146GB RAID1 (system)
>    6 x 2TB RAID5 (data1)
>    6 x 3TB RAID5 (data2)
>=20
> Normally, data1 and data2 are then striped with mdadm on Linux, to=20
> increase performance over a JBOD-style usage. This has worked nicely for=
=20
> a while.. until we lost 2 disks in data2 within a few hours of each=20
> other. Murphy's law, and all that.
>=20
>=20
> I've made a raw disk copy (using ddrescue) from one of the dead disks,=20
> onto a new disk. I tried putting this disk in the server, but it would=20
> not accept it. (It said it was recognized as foreign, but import failed)
>=20
> If I try to assemble the raid, I get this error:
>=20
> [root@rescue]~ #mdadm -A /dev/md10 /dev/sd[abcde]
> mdadm: superblock on /dev/sde doesn't match others - assembly aborted
>=20
> Now, this does seem to be true. All the GUIDs on sda-sdd:
>=20
> Controller GUID : 44656C6C:20202020:32374730:32524100:00743D30:00000021
>   Container GUID : 44656C6C:20202020:1000005B:10281F34:40371E8C:E9A398EA
>        VD GUID[0] : 44656C6C:20202020:1000005B:10281F34:3DB931F1:D8857F5D
>        VD GUID[1] : 44656C6C:20202020:1000005B:10281F34:3DB9326E:61E7B2D7
>        VD GUID[2] : 44656C6C:20202020:1000005B:10281F34:3F6ADA39:99DCAA67
>=20
> While on the last 2 disks, we have this:
>=20
> Controller GUID : 44656C6C:20202020:32374730:32524100:00743D30:00000021
>   Container GUID : 44656C6C:20202020:1000005B:10281F34:3DB931F1:40FC2989
>        VD GUID[0] : 44656C6C:20202020:1000005B:10281F34:3DB931F1:D8857F5D
>        VD GUID[1] : 44656C6C:20202020:1000005B:10281F34:3DB9326E:61E7B2D7
>        VD GUID[2] : 44656C6C:20202020:1000005B:10281F34:3F6ADA39:99DCAA67
>=20
> Notice how the last 8 bytes of the Container is different.
>=20
> I'm not quite sure how this happened, but I have a strong suspicion the=20
> PERC controller did something less than clever, and now I can't start=20
> the raid with mdadm OR perc.
>=20
>=20
>=20
> I've tried to simply update the container GUID using a hex editor, but=20
> this of course causes the CRCs to fail. (I reverted this change)
>=20
> I have the following questions:
>=20
>    1) If I could manage to change the Container GUID, would that
>       be a viable way to force the array to start, for further rescue?

I suspect so.

>=20
>    2) Is there any other way to force the array to start? (--force does=20
> not help)

Unfortunately not.

>=20
>    3) Any other suggestions?
>=20

Copy the bad disk to the good disk with ddrescure again? =20
or just copy the last megabyte or so.

or maybe hack mdadm to assume all container guids are identical.

NeilBrown

--Sig_//+CGdz=t+.hU_ukRjoeSgK9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUw2FXDnsnt1WYoG5AQIPgA//Yxudof5nlVRZm0wlDeIprFVjTAWDczp2
XE0aY39wKQPOmcB/75pvyvYgteyCC1ZN/imuy3NyzQahlXsaVjz/kcRvuyz4pXeE
DL2tEPZObnoSPQm9Yd5BzN2drU4hFBVSU4t9nuqlHEPGtiVXozGI7Tf0NYC7IcnO
jiTW+kyh4q3Yb6tvawtd5SuGZWb/+miOXZbSR9mUySHYKGbGop7StmZSnwBEuUyr
8+CYgiAVB5cYTBZT8KLc4YKOCDN0K9QDJvbH1CTHQMiGXwsp0FoN3hxSzzt1kN/a
89/CeCIjnb0/Q+f4QbThU9SfEw0zKk/4tDfaPaeE+C1AnFjk8pWW0uE9OHZK14vb
TRYSmAJkf5RCDUvPg3k6HtweODngsPpbjkqzCIrOJa8X0sdTvQeAIRZeCZ7V3EFn
/EHAuSUkgA9olqZcXoEQPfPUPVHUngXy2g8YQ+kZzqWDoGe377GUCsQVCAmLoX81
Y4vA8S5ujAD9maSa4TrjxCDQ97bfzeCDzDm8ca+8DXpXGr+ddhUsXJAl0mBpIMh0
rsehIbvbs+rtQcVYPh9hyDilv4lky2lv+wJbXN6+M3uooDNeGrADPWZE+nRGCVaE
eBT+KeHgUeLLs4O7JVP8OPtijIiR/1tiWebMY/1pxMDPiydP7TASlWEZaEdRQB/D
FMDVXIY9xtk=
=n2Up
-----END PGP SIGNATURE-----

--Sig_//+CGdz=t+.hU_ukRjoeSgK9--
