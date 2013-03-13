From: NeilBrown <neilb@suse.de>
Subject: Re: Persistent failures with simple md setup
Date: Wed, 13 Mar 2013 11:52:35 +1100
Message-ID: <20130313115235.01492c21@notabene.brown>
References: <1565063.1kpR7lz4Ph@xrated>
	<20130301082520.19be933a@notabene.brown>
	<1659994.UpSJlIr5Mb@xrated>
	<4291349.FrQcKOnicQ@xrated>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/h.Ts/D9Qdgq3bE2nAA88aiD"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4291349.FrQcKOnicQ@xrated>
Sender: linux-raid-owner@vger.kernel.org
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/h.Ts/D9Qdgq3bE2nAA88aiD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


hi,
 wonder if you could try one more test for me.
 With the other (echo BEFORE / echo AFTER etc) tracing still there, change =
the
   /sbin/udevadm settle --timeout=3D$MDADM_DEVICE_TIMEOUT
 to

   /sbin/udevadm --debug settle --timeout=3D$MDADM_DEVICE_TIMEOUT > /dev/km=
sg 2>&1

 I found there is a case where "udevadm settle" can exit before the queue is
 empty.  It seems like a very unlikely scenario, but it seems clear that
 something "unlikely" is happening.
 I'm hoping to see
    timeout waiting for udev queue

 appear in the logs when this runs.

 If you could add that and post the 'dmesg' output if you ever get that
 message - or maybe even if you don't - that would be very helpful.

Thanks,
NeilBrown

--Sig_/h.Ts/D9Qdgq3bE2nAA88aiD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUT/N0znsnt1WYoG5AQKhfQ//SbCCK0cTf3LlgUzABeCLEq4l7h2TKUlq
g7EaXAI8K3vJAAljy85W3B8IySqqNyCC6yLcbuFZplkFWzsw/81MhteFHg9qyhPm
5ebesLz1qzUV9h9zDyxaZUadLDZCCh+1W7103aqNs2nR3K803rBYvj4H+tW6/zty
6VwtL/NoR+O2Qep5iubTe6YrfX2WJXr3bX7kJl6alp4LaPCL2LUypzEoq39OcSbF
hpGnKrKzVIJCGBb4B89+baET8ay5uU12H6ok/mpLB0LfhyHhzxp1hGQ5t63k3xT9
j29J77u06ZLRQsF4LLc0hnyuc1DdKD816z0bMI91lNNJ9WiiViSbl3KTuopDIg3b
eo5gsIUsf11j2L+dUW9pD9Y7thJpoWzDUHaDG7sV7wVpwsqTK6WNUTwCGlyNaDih
s5CgRZ0MorigrerXRtGWah9VmqEnukBiUTrxuvgV0+R/+090Gj3xIBi4IWTdF8g3
nAJXHrpwpmnm8ivM+Sd0MkQyj5nuoPVog2wq6UL07/GMYcXuOE+kxrOED3koC+xs
IQwW7Q7c5x3ZMA9/rRoab0Ohu2C38IEz5nMr4zB1zMfScBBWdVkfqBb66g1qHUsQ
90KGaxN6eIr33oDt65/2FX0seNUtasTEMfpwWgHSOLgZyyGBNzBV0ENFSVVlRaMo
8LumEQVHnI8=
=z5Hm
-----END PGP SIGNATURE-----

--Sig_/h.Ts/D9Qdgq3bE2nAA88aiD--
