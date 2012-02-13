From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 ext3 problems
Date: Mon, 13 Feb 2012 13:28:53 +1100
Message-ID: <20120213132853.2d90a18f@notabene.brown>
References: <CAKXovctDQdiMWEdzh6Jg8OkEjXX5OHZ+hubFV-GRsc8S2QHohQ@mail.gmail.com>
	<CAKXovctARfGAkug=ZA0EYm1uB=V0_5BXWyNisVZYip0VBpJxtA@mail.gmail.com>
	<CAK2H+eerAkwup2UcAu2v=_4+=Bg_FBCqZmjGjmcLQA+2ozmvbg@mail.gmail.com>
	<CAKXovcvvTioOP+JKd8b5-Hc1GZhAiqB85=A4d-cCP03uDPiGkg@mail.gmail.com>
	<CAK2H+eds+2wu6Nep639mZ1dkOMmxdzqp4_7-o=QJO_qqcTWr9g@mail.gmail.com>
	<CAKXovctDA28Gk61EJF_1-6kX2kMwRG8yyza4VFsKpzwsiHOEGQ@mail.gmail.com>
	<CAK2H+ee3ERstCsh4ju9kfU0gpFenHqUuMdtjnhFthK8C--NoXw@mail.gmail.com>
	<CAKXovcs-UORdS6d8XYuDa=CF2rMX8H+PX2Y_Gh5N2Oze8Ni+-A@mail.gmail.com>
	<CAK2H+efLnZTvAFcCN=2GTJo6FErFhm330xG6tPNFNxs=5gOPSA@mail.gmail.com>
	<CAKXovcuCz9UZrk8+hMsJ_zuST2ZqZBtzhBYewX7ZXA2chruHKg@mail.gmail.com>
	<CAK2H+edraUOVSE5QGG++hr4XmJUbG_d-pawtNzT5rDd-RAK6ig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/B1o_0cp+zNHCVOrdchjXIOE"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+edraUOVSE5QGG++hr4XmJUbG_d-pawtNzT5rDd-RAK6ig@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Jeff W <jeff.welling@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/B1o_0cp+zNHCVOrdchjXIOE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 12 Feb 2012 12:52:25 -0800 Mark Knecht <markknecht@gmail.com> wrote:

> On Sun, Feb 12, 2012 at 12:27 PM, Jeff W <jeff.welling@gmail.com> wrote:
> >>
> >> So what _actually_ happens when you issue the commands? Please post
> >> back the results of
> >>
> >> cat /proc/mdstat
> >
> > jeff@Shmee:~$ cat /proc/mdstat
> > Personalities : [raid6] [raid5] [raid4]
> > md1 : active raid6 sda[0] sdf1[1] sdg1[5] sde[4] sdd1[3] sdc1[2]
> > =C2=A0 =C2=A0 =C2=A02441437440 blocks level 6, 64k chunk, algorithm 2 [=
7/6] [UUUUUU_]
> >
> > unused devices: <none>
> >
> >
> >>
> >> and
> >>
> >> mount /dev/mdWHATEVER /mountpoint
> >
> > jeff@Shmee:~$ sudo mount /dev/md1 /mnt
> > [sudo] password for jeff:
> > mount: wrong fs type, bad option, bad superblock on /dev/md1,
> > =C2=A0 =C2=A0 =C2=A0 missing codepage or helper program, or other error
> > =C2=A0 =C2=A0 =C2=A0 In some cases useful info is found in syslog - try
> > =C2=A0 =C2=A0 =C2=A0 dmesg | tail =C2=A0or so
> >
> >
> > jeff@Shmee:~$ dmesg | tail
> > [48532.584428] [drm] nouveau 0000:01:00.0: Setting dpms mode 0 on vga
> > encoder (output 0)
> > [49369.880015] [drm] nouveau 0000:01:00.0: Setting dpms mode 1 on vga
> > encoder (output 0)
> > [50470.240278] [drm] nouveau 0000:01:00.0: Setting dpms mode 0 on vga
> > encoder (output 0)
> > [50522.284317] usb 2-6: USB disconnect, address 4
> > [52848.285524] [drm] nouveau 0000:01:00.0: Setting dpms mode 1 on vga
> > encoder (output 0)
> > [52940.534516] [drm] nouveau 0000:01:00.0: Setting dpms mode 0 on vga
> > encoder (output 0)
> > [53540.724023] [drm] nouveau 0000:01:00.0: Setting dpms mode 1 on vga
> > encoder (output 0)
> > [54039.813485] [drm] nouveau 0000:01:00.0: Setting dpms mode 0 on vga
> > encoder (output 0)
> > [58210.212241] EXT3-fs error (device md1): ext3_check_descriptors:
> > Block bitmap for group 6016 not in group (block 277891307)!
> > [58210.247230] EXT3-fs: group descriptors corrupted!
> >
> > Is that more helpful?
> > Thanks!
> > Jeff.
>=20
> I think it will be to others. It's a bit above my pay grade unfortunately.
>=20
> Doing a quick Google of
>=20
> RAID ext3_check_descriptors
>=20
> turns up others having similar issues to yours (I think) with a few
> posts that look like solutions, or possible solutions.
>=20
> IMPORTANT: My first inclination was to suggest an fsck but one post I
> found made it sound like that hurt his RAID so read carefully before
> doing anything that might cause more hard.

fsck is the only thing I can recommend.
Probably use "-n" first so that it only reads and never writes.  Then you c=
an
see how much damage there appears to be before deciding if you want to fix =
it
(rather than ask for more suggestions).

'sda' must be left over from some other array.. Maybe 'sda1' had the other
device from your current array??

I suspect that when you had the problem that caused you to want to move the
array to a new machine, something corrupted the filesystem a little -
probably not very much.  fsck for ext3 is pretty good at fixing things so
you'll probably get your data back.

NeilBrown

--Sig_/B1o_0cp+zNHCVOrdchjXIOE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTzh1ZTnsnt1WYoG5AQI5og//duIuyGCRjyihLPQWOwDaWv4KYooKVJEt
+lcbveELs1smYSacxYbUmQz8pThx1z9it8VK7pCp2BPfUTc4+YxjCl/Wzb6PnhBD
h8GKWoOBCwhY3U+RU5uaKG6W0Goy+AMZgYSaycMd02WfjEJJBh4Y2IZl4pK3FxWV
aazXfO4YNOmEqPO52OwGHLbpsY3ncmxJVmNYNqqOPLmbZhhTbYt7RA2mt8k4KbLu
lflJ89CLg8ecbgs7Zf8uUAcSKX1Ur146JEGDNZivGBAnb7IsEHmeTLUEqAT30gUs
RRvZNF3nKZQRsApVXwfanfkKIx0idUfYPOnYbvkK8BNtySFHdJvnz7z8LOpPCEZ4
B8gs4E0FsIibLs4YiyWGYqklgBquSOVnJKVbdAGldV/y6IgEkMf4DhPYNlhBy0vR
rtAVVQrLMiLFzBHHa0fSE3hQ0BEfn+L6BjGJDiJCTqXT8+OAtCluxZ1Yf9Qox6vN
Y8YhmvrUQyzYmt/V7vhz+OeUX28WXn+KTw3XvN3wDS06a3WEZiz8CvfNXQ85N65U
CJ6QoqkZV6Mt3mixVT6un/2yQbZ72pi6jRQuemRb3hqcXsNdCrb2po/0VoknYYTn
FMKMIqqWkCgm0H++bTkbZ1VP49kz6u9Xt1FJPq8jEj64UMMlHA3kNI/fVmfo9KYp
8DaQDujwUng=
=W4Dd
-----END PGP SIGNATURE-----

--Sig_/B1o_0cp+zNHCVOrdchjXIOE--
