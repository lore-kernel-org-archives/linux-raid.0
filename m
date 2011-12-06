From: NeilBrown <neilb@suse.de>
Subject: Re: Spin down
Date: Tue, 6 Dec 2011 15:39:23 +1100
Message-ID: <20111206153923.203df175@notabene.brown>
References: <CAF78GY0YdJ0c0WWpyDnnzitAec_7VZZnEsP_n_UHuec5JmVAng@mail.gmail.com>
	<20111205171115.044b1705@notabene.brown>
	<CAF78GY0u89KvZhEZQ64GxWeDpBCT6cdAJ+xaGm=z7O_2gKTYTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/I2Ad1EATPscEuHxfn90QJFY"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF78GY0u89KvZhEZQ64GxWeDpBCT6cdAJ+xaGm=z7O_2gKTYTA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Vincent Pelletier <plr.vincent@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/I2Ad1EATPscEuHxfn90QJFY
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 5 Dec 2011 08:49:03 +0100 Vincent Pelletier <plr.vincent@gmail.com>
wrote:

> On Mon, Dec 5, 2011 at 7:11 AM, NeilBrown <neilb@suse.de> wrote:
> > 5 seconds suggests a bitmap update. =A0Do you have an internal bitmap?
>=20
> I don't, but I enabled it on those arrays before with default delay.
> I then removed it when I suspected (with help of block_dump) it to
> cause spin-ups, and I noticed an improvement. Recently, the machine
> was restarted (once on 3.0 kernel, and again to update to 3.1), and
> after both restarts those 5s periodic writes occurred.
>=20
> > Then try adding it back with a longer delay
> > =A0mdadm --grow /dev/md0 --bitmap=3Dinternal --delay=3D60
>=20
> Adding bitmaps on both arrays (md0 and md1), 5s periodic writes disappear.
> Removing bitmaps seems to preserve the improvement.
>=20
> Could the delay setting have survived on-disk and be used when
> initializing the array, but cleared when mdadm later disables bitmap
> usage ?
>=20
> > What kernel version are you running?
>=20
> 3.1.4, according to dpkg:
> ii  linux-image-3.1.0-1-amd64                   3.1.4-1
>                      Linux 3.1 for 64-bit PCs
>=20
> Regards,


Hmm... I cannot reproduce this which makes it harder.

Can you enable dynamic debugging on md?
Make sure CONFIG_DYNAMIC_DEBUG is set, mount debugfs on /sys/kernel/debug a=
nd

 echo module md_mod +p > /sys/kernel/debug/dynamic_debug/control

then look for extra messages in the kernel logs, starting "md:" most likely.

You'll almost certainly see something like

[ 1851.559629] md: waking up MD thread md0_raid1.
[ 1851.625819] md: updating md0 RAID superblock on device (in sync 1)
[ 1851.656878] md: (write) sdb's sb offset: 8
[ 1851.656915] md: (write) sda's sb offset: 8


every 5 seconds.  If you could confirm that and report if there is anything
else reported that might help.

NeilBrown

--Sig_/I2Ad1EATPscEuHxfn90QJFY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt2chTnsnt1WYoG5AQJu1w//R9eX/VHvp2JzhMRV022qAUsnuW6R+Nh1
gICn6WDLuy7OG/Yf8L9405PQ7+yEYGzELBWPY3Dbz2nvQEz8tNFWO5vQxKwHlLik
ikU63vozdnlGtlXuzV2WV2JlQ+U9AYMUrw+Ie25gxCQx8ZHhJJusjKEZpiXCs+2v
gLC7huwVoc0Ld0lAqQPkeMgD2DRb1baiYN/AixAkASDO+ep9FYTG9mmUY1FZPS4K
v+2QQtY7OFXYiRPOpmeqODONTrYjC4E0wC5Z4VonEADCvPeR3988xR+JHMMu/911
tBpZBZWlAlkGeUX4asEpuDd9gMQG4iwBH3fJtgPLbSQr8VyKV0HzO3B089wApyxp
x9sOgXC22Y5Z9CbIUwgChX4DhtAF9jdbZIjm9a43jMiHnCmTU+ZB2rUnbkGKhH7S
JyfU8WHYWLYE/AGgZuHlfadXBeL5N8W1Aq1Yj02n/jZO9YZqUl9dS+hpWEeu0e8v
QM2Kq3sZYOeOSN6HIaGuIeVAR+Elt28Shr6yt9H33xVCNKzlhJwXGoAkDNVs2Pml
2eR+ZD5w90xiE+AH931V0yhSHtdXI1O4G97MKuT1o99iUekny0scd3l6h69AJiWc
shNLK4O8WHnNh1Ob0wagEOU1nfg8WqPpgUBelP0ERJXs82iLV0JgGMqHbFuCBLuJ
eFPg2G27Oao=
=5MW8
-----END PGP SIGNATURE-----

--Sig_/I2Ad1EATPscEuHxfn90QJFY--
