From: NeilBrown <neilb@suse.de>
Subject: Re: MDADM after QNAP Support disaster QNAP 859 Pro
Date: Tue, 30 Oct 2012 13:58:45 +1100
Message-ID: <20121030135845.49256a70@notabene.brown>
References: <508BFD32.7010901@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/P+6p7xaQVSrnl.JIL.Pz/24"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <508BFD32.7010901@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Sam.vanRatt@gmx.net
Cc: linux-raid@vger.kernel.org, Michael Samer EPOS GmbH <michael.samer@epos-cat.de>
List-Id: linux-raid.ids

--Sig_/P+6p7xaQVSrnl.JIL.Pz/24
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 27 Oct 2012 17:26:42 +0200 Sam van Ratt <sam.vanratt@gmx.net> wrote:

> Hello
> a few days I received a NAS with 8 Slots. The original config consistet=20
> of 8* 2TB HDs as a RAID6 mdadm softraid system. After a normal reboot=20
> the array was no longer found, so QNAP was contacted.
> The support told the keyuser todo this:
>=20
>=20
> mdadm -D /dev/md0 (zeigt das gesamte RAID auf)
> to assemble the HDs you have to:
> mdadm -A /dev/md0 /dev/sda3.... (take care here, depending on the HDs=20
> they get a value like /dev/sdb3 dev/sdc3 ...) - with 8 HDs:
> mdadm -A /dev/md0 /dev/sda3 /sdb3 /dev/sdc3 /dev/sdd3 /dev/sde3=20
> /dev/sdf3 /dev/sdg3 /dev/sdh3 (be careful with the order!)
> If you get an error message about the assemble, you have to stop md0
> mdadm -S /dev/md0 (stopping md0)
> umount /dev/md0 (unmount of md0)
>=20
> After serveral failed tries it endet in have a RAID 1 Konfig on sda and=20
> sdb but not seeing anything else of the config before (funnily only a=20
> 500MB partition (as /dev/md9 sounds as a lot of tries).
> As I'm not using mdadm in my workplace anywhere:
>=20
> How can I delete the RAID1 (pretty simple I know) and reconstruct the R6=
=20
> Array without damaging the config further (and therefore the datas). The=
=20
> R6 should be about 11TiB usable size.
> Is there a init build with searching for the old conifg? As R6 it should=
=20
> even be readable without sda or sdb if this should be needed. I manly=20
> use HW RAID Controller where a few (ICP, Infortrend, Areca)  which=20
> allows a reassembly by just declaring the disks as member to mdx and=20
> assemble then again; I hope mdadm could offer something similar
>=20

The advice you were given doesn't seem very helpful.

Please run

 mdadm --examine /dev/sd*

collect the output, and post it.

NeilBrown

--Sig_/P+6p7xaQVSrnl.JIL.Pz/24
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUI9CZTnsnt1WYoG5AQJKAg//bWeaSd6zmSrDA50Mo+VegLguGShbt+IY
EfBtfw9MxxXGHGmaYXEX7ltqQSL/pbHHWRfrVTceU2Ioh+UT6OOf2YbdMlZGMLwl
duhanwfnhuo0+tVI/SByZ8nCTQPynI6s55ngPdT3kctOJncAwcssXEwde0AyN2y9
74m+v2XPoOvWVrMoBjsnd0GEbXbxXtMSQPpcqYPUx835JyjYzyeM9Bi1cXEf0iiO
wf8iV4zwoAmBy+4g4kH9QVkGPwPhbLlNyJ8naoHzgeJoCd9887cYqoCPLQMsZ3bj
RhClnclrrJm0T0QfWF1GlZcSGNtEYTLlrJsG0uJ80Wmxc6ZqfZ3xYhMbZ/ZC/s64
R5udunAiBrN/b8wXr2NjhKi0mUnXCmaeZMNH53vJDKPRs4BZnxPs4CIbR/+z+qt3
yRxS6xzrq51WIB4yibSg+CvkKLDvEdLe1xaXnjbTpTZIBsiEvjBu24T37YJ5R72U
r3kE6p6JJsmVrPR6HuvnDfseZvwcBaGVTPBM9DPLMSvTjRaWwZeSBNTnn6fZtgpA
uKvA3oJX/aBNhnRe3gAg7XVTlMfsPrkW0LTtDTU5UxGeExVG630HchFt47YatZXU
U0eDiCH6z1suz03SC3A79O2W0YY1zpdQffYDBcJzoa3QM0fJFjum3nHvGl02Z5pU
zvGQB95M8zU=
=bar1
-----END PGP SIGNATURE-----

--Sig_/P+6p7xaQVSrnl.JIL.Pz/24--
