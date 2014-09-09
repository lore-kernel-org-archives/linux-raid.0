From: NeilBrown <neilb@suse.de>
Subject: Re: Question about RAID1 plug/unplug code
Date: Tue, 9 Sep 2014 11:45:38 +1000
Message-ID: <20140909114538.552a4a7d@notabene.brown>
References: <CAGRgLy4WTXdF4Tp1pf0BJ-VPR3Yhx_xyzbCAXBzNDpeYTPvkmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/DV.uyjuqpfy/UHops5M0W2p"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy4WTXdF4Tp1pf0BJ-VPR3Yhx_xyzbCAXBzNDpeYTPvkmw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/DV.uyjuqpfy/UHops5M0W2p
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 8 Sep 2014 16:55:52 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> We have been seeing high latency on the md/raid1 block device, due to
> the fact that all WRITEs are handed off to raid1d thread. This thread
> also calls bitmap_unplug(), which writes the bitmap synchronously.
> While it waits for the bitmap, it cannot trigger other WRITEs waiting
> in its pending_bio_list. This is especially seen with SSDs: MD's
> latency is much higher that SSD latency (I have been stoned by Peter
> Grandi when I brought up this issue previously for raid5).
>=20
> Then I have noticed the commit:
>=20
> commit f54a9d0e59c4bea3db733921ca9147612a6f292c
> Author: NeilBrown <neilb@suse.de>
> Date:   Thu Aug 2 08:33:20 2012 +1000
>=20
>     md/raid1: submit IO from originating thread instead of md thread.
>=20
> Looking at the code, I learned that to avoid switching into raid1d,
> the caller has to use blk_start_plug/blk_finish_plug. So I added these
> calls in our kernel module, which submits bios to MD. Results were
> awesome, MD latency got down significantly.

That's good to hear.

>=20
> So I have several questions about this plug/unplug thing.
>=20
> 1/ Originally this infrastructure was supposed to help IO schedulers
> in merging requests. It is useful when one has a bunch of requests to
> submit in one shot.

That is exactly the whole point of plugging:  allow the device to handle a
batch of requests together instead of one at a time.

> But in MD case, thus infrastructure is used for a different purpose:
> not to merge requests (which may help bandwidth, but probably not
> latency), but to avoid making raid1d a bottleneck, to be able to
> submit requests from multiple threads in parallel, which brings down
> latency significantly in our case. Indeed "struct blk_plug" has a
> special "cb_list", which is used only by MD.

I don't think the way md uses plugging is conceptually different from any
other use: it is always about gathering a batch together.
"cb_list" is handled by blk_check_plugged() which is also used by
block/umem.c and btrfs.

The base plugging code assumes that it is only gathering a batch of requests
for a single device - if the target device changes then the batch is flushe=
d.
It also assumed that it was "struct request" that was batched.
Devices like md that want to queue 'struct bio', something else was needed.
Also with layered devices it can be useful to gather multiple batches for
multiple layers.
So I created "cb_list" etc and a more generic interface.

> In my case I have only individual bios (not a bunch of bios), and I
> after wrap them with plug/unplug, MD latency gets better. So we are
> using the plug infrastructure for a different purpose.
> Is my understanding correct? Was this your intention?

I don't really understand what you are doing.  There is no point in using
plugging for individual bios.  The  main point for raid1 writes is to gather
a lot of writes together so that all multiple bitmap bits can be set all at
once.
It should be possible to submit individual bios directly from make_request
without passing them to raid1d and without using plugging.  You might end up
making more bitmap updates, but you might not.


>=20
> 2/ Now that md/raid1 submits WRITEs from several threads in parallel,
> is there any issue you can think of? Like for example, multiple
> threads now call bitmap_unplug() in parallel. Is this alright?

Hmmm... there could be an issue there.  It is possible that some callers of
bitmap_unplug won't block when they should.  bitmap_unplug should probably
wait unconditionally.

NeilBrown


>=20
> Thanks!
> Alex.


--Sig_/DV.uyjuqpfy/UHops5M0W2p
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVA5bwjnsnt1WYoG5AQKXhA/+K2vLOXP7M4znfN4C2H/Ql4J+/VRqChLk
klUAeVISklwCvvJYNLFjXPsK89ElOHbeDaW6Ncb24LKqOFeHDh38HcJRI27njJxj
o3/QasgRx0yGjbQUj2KIZr3vauoeir4jzi9gP3xLvIQUmT6ozghkRw0Vg7kKdn2g
Cc3MVq8GiD3ljkUOlDjTXyk0Paxogc104OXGIpu1Cj3xALQbESQ5LZysk3lPlH57
jCpLwnA6vdpVBjakdBGPuSZjoCNYuqo+aX8NCf3V4V0XHhgNEyC4WmENybchnZ7s
ifDkNU/nRUOoIkhVCafx7KettFR6wWBpnz2lPP3Adhrm2ABqd2lCg6O+gONbOaL3
COGT1/cvjb459mSAkTJxYj8ARw2yhVwFLVVbzYql/ulb4g2PPrmWcyQQGhTeCsgN
YFKZfBLNEsW1efkOyhr68TeY9EFtHe+ztWiEiZ4755Rut+ngTbypeGMhIJccxeuL
PSscMrlaxT+X/5/Q+mE0GVpNxobCEoitXGP22wBlnrRC6cXrNVlus3QcEjy4iiaR
0uqN6izhYCIEon7TtiQO6UJQlOVyDHwjfk57Gufdz/O0B/B2vorJv0FNtoWAzCs3
HueUYaGKDCX3/Cbjs3lqtpU9vsLhYXMMVhlqsRqwA7TU4jPvPcOdREY6+GxEuhGo
K4OPJq7CJt4=
=9kO2
-----END PGP SIGNATURE-----

--Sig_/DV.uyjuqpfy/UHops5M0W2p--
