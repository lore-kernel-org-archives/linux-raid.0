From: NeilBrown <neilb@suse.de>
Subject: Re: Raid10 and page cache
Date: Wed, 7 Dec 2011 12:01:33 +1100
Message-ID: <20111207120133.70ca294c@notabene.brown>
References: <CAJygYd16PWfKe8fK-b150N46CEwzBUqJn1N6dfsGR4yyTgGbTQ@mail.gmail.com>
	<CAJygYd3ofkHp9huD_Q1xoKVb_Q2LTDAnFHf-n+8xyG7ug3wC_Q@mail.gmail.com>
	<20111207092625.7140c5dc@notabene.brown>
	<CAJygYd3fM+wtnU0HkN7s7o=FPizbPNPET2A21jxWk-BJZgdFbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0y2Ptb_1ZVP7D195VFWaRhE"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJygYd3fM+wtnU0HkN7s7o=FPizbPNPET2A21jxWk-BJZgdFbA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Yucong Sun (=?UTF-8?B?5Y+26Zuo6aOe?=)" <sunyucong@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/0y2Ptb_1ZVP7D195VFWaRhE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 6 Dec 2011 15:13:34 -0800 Yucong Sun (=E5=8F=B6=E9=9B=A8=E9=A3=9E) =
<sunyucong@gmail.com>
wrote:

> On Tue, Dec 6, 2011 at 2:26 PM, NeilBrown <neilb@suse.de> wrote:
> > On Tue, 6 Dec 2011 14:01:14 -0800 Yucong Sun (=E5=8F=B6=E9=9B=A8=E9=A3=
=9E) <sunyucong@gmail.com>
> > wrote:
> >
> >> Hi,
> >>
> >> I recently setup raid10 on 4 physical disk and have a iscsi serve it
> >> as a block device, and have been trying to tweak for performance.
> >>
> >> First thing I notice that MD seems to rely on page cache to flush
> >> changes to disk, =C2=A0is there any way to turn that off so changes are
> >> flushed to the disk? like O_FSYNC|O_DIRECT does? The reason I want to
> >> turn it off is to understand the performance difference, =C2=A0I want =
to be
> >> sure that page cache is truly acting as a write-back cache, I know one
> >> can tune the dirty_* to control the cache flush, but I want to make
> >> sure that it is actually doing what I think it does.
> >
> > Why do you think this?
> >
> > md/raid10 sends all request straight through to the relevant underlying
> > device(s).
> > reads are just passed straight down.
> > Writes are duplicated (the request structure, not the data) and queued =
to a
> > separate thread which does the actual write, but it is fairly direct.
>=20
> So I know there's page caching /flush involved because I watch
> /proc/meminfo and see  Dirty value growing up and After reach the
> threshold, Write-back kicks in and wrote data.
> So if as you said md does no page flushing, then it must because of
> the iscsi software opens the device without O_DIRECT, so it uses page
> cache which in turn flush data to MD, now it makes more sense.
>=20
> But for the md write, it's not SYNC write? meaning that after write
> call with O_DIRECT to the md device returns, the data is still
> possibility on the fly to the disk? how does having a bitmap plays in
> between? does it work like ext3 jounal? after a power-loss, can we
> expect a crash consistent data on the disk?

When you want sync writes, you need to use fsync.

When md writes the superblock or a bitmap page it uses SYNC and FLUSH writes
to ensure they get to the media before the subsequent data write.


>=20
> Another thing to note is I found IO size on MD device is always 4K,
> which is the page size, is that normal? just want to making sure this
> isn't a bad behavior result from the iscsi software.

It is normal in some cases.  It depends a bit on the details of the
underlying device.


NeilBrown

--Sig_/0y2Ptb_1ZVP7D195VFWaRhE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt667Tnsnt1WYoG5AQL8GRAAsqtufOB6ZC2KCKttkgBTlIq0IIjQ2jRm
U4CV/AmdkXQKlEUWsw1dmo1dT55efAmk4wipe8OQka2MdkG1ShtF3m4iE84/BiCk
4npYjRQAJKtH55wGuBF0Yjv98A059VrUFIIHowVKi0evePR3XuvxBsJod9SRKIHp
MqvTNA2D1uT/ofs9M7hXeZILGsBYTVmTWFUx550YRI18EPae9GkWBMvs8/gViY9D
fLzzH6+ALhfUQP8wgNfv2m2TevLD2LhoYAi3aPQriJYFrw1T+KOd1ifDIW/X/Py+
9QsGKyNma766ukEC1NDDrSlYJOZeEZgG/WuT3mNTGEFh6KIhHn5pp0kCVzKnbKX+
NdJCIbzpR69yJn82UFsa6TNCvOztToGi9WhbIuW1s6zKWaKGZTG/kvChQsSXbfqi
IBW75k5jTcK6FHF/4esVqztKhALFU3/skS9HBXJiID4drVgqI7M2s6vd/6nc3tfY
HnUhiXO1TgJuzSGatMDnDyacayekIDnVVJ21y9hT0r763yEU2jerk+g2YcFr9w4b
ZV9fqge/yQpU+tKyskxaJaTJCfd8B2Q93xkXdWfyo3IVQwcw3YKwQtRyRt5IFryn
VuCTkiEwCOQfH9z7qnH/ru+9JBJgfw70IEVq9VY192NXw1MaZON/NZ7nnLpl1FbR
3F4hv88TgRM=
=bmFM
-----END PGP SIGNATURE-----

--Sig_/0y2Ptb_1ZVP7D195VFWaRhE--
