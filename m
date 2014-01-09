From: NeilBrown <neilb@suse.de>
Subject: Re: Can raid1-resync cause a corruption?
Date: Thu, 9 Jan 2014 14:10:43 +1100
Message-ID: <20140109141043.28266c06@notabene.brown>
References: <CAGRgLy6qoYFW0BabE4qUT2kc61MEjpCS7x_PnxW+iCRUPzB6AA@mail.gmail.com>
	<20131230084132.6f8b033e@notabene.brown>
	<CAGRgLy4Uu_6k0bL1xWxyArKAvKNJL1J=Jn6MjHNAXX5bgryvHg@mail.gmail.com>
	<20140107105651.0cfbab31@notabene.brown>
	<CAGRgLy61Xx9US=nMuTdAKSnFXKGi=bH49gMZsNOD3Myv7NLQ3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2oLPDNXcar22QZR_Xem/MwD"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy61Xx9US=nMuTdAKSnFXKGi=bH49gMZsNOD3Myv7NLQ3g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, yair@zadarastorage.com
List-Id: linux-raid.ids

--Sig_/2oLPDNXcar22QZR_Xem/MwD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Jan 2014 17:01:23 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> Thank you for your comments. Yes, apparently in this case md/raid1 was
> not the cause. I studied the code more by adding prints and following
> the resync flow, but cannot see any obvious problem.
>=20
> I did find another case, in which raid1-resync can read phantom data,
> although this is not what happened to us:
> # raid1 has 3 disks A,B,C and is resyncing after an unclean shutdown.
> sync_request always selects disk=3DA as read_disk.
> # application reads from far sector (beyond next_resync), so
> read_balance() selects disk=3DA to read from (it is the first one)
> # disk A fails
> # resync aborts and restarts, now sync_request reads from B and syncs int=
o C
> # application reads again from the same far sector, now read_balance()
> selects disk B to read from
>=20
> So potentially we could get a different data from these two reads. In
> our case, though, there were no disk failures.
>=20
> FWIW, the raid1 code I was once responsible for, treated this
> situation as follows:
> # READ comes from application
> # raid1 sees that it is resyncing, so it locks the relevant area of
> the raid1 and syncs it. Then it unlocks and proceeds to serve the READ
> normally
> # resync thread comes to appropriate area, locks it and sees that it
> has already been synced (bits are off in the bitmap), so it proceeds
> further
>=20
> However in md/raid1, there is no mechanism currently that can lock a
> part of the raid. We only have raise_barrier/wait_barrier that
> effectively locks the whole capacity.
>=20
> Is it, for example, reasonable to READ the data as you normally do,
> then to trigger a WRITE with the same data and only then to complete
> the original READ? There are a lot of inefficiencies here, I know,
> like re-writing the same data again on read_disk, and syncing this
> data again later. (I know, patches are welcome...)


Hmmm.. yes that could conceivably cause a problem.  It would apply to RAID6
too.
To "fix" it we would have to either read-and-check the replicas or parity
whenever we read from a block that is not "in-sync", and/or write them out.
This could be rather expensive for  fairly little gain.

If we were doing a bitmap-based resync, then we could maybe expedite the
resync of any region before reading from it.
i.e. before reading from an block which is not known to be in-sync, we wait
for it to be in-sync, but also signal the resync process to do this 'bit'
worth next.  That could be rather messy... but might not be too bad.
Rather than using the resync thread to handle the extra bits, maybe we could
have a work-queue which just handled specifically requested regions...

Patches certainly welcome :-)

NeilBrown

--Sig_/2oLPDNXcar22QZR_Xem/MwD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUs4TMznsnt1WYoG5AQLDjQ//QTimPtqlYYYaeJyVWKgVOEzZbF2FMElz
65pgs+4ifhYl/H92XNfssbHlMibde+CKv4N7rHcCOzkv7Z6Yj411cmvvAlJ4lyJy
Tw/yoG770qEIHEg60Neg0YJsGUNl8PVvEpybYeqhOEnpB4Y5UYNyamaMrozlPSyH
zpf3TLxGKygc8ddeBKANrbbhGgPfHntbxTzlcxvWhdhcasLGi6PK5HhhEMrkhs7p
sYUv+mJegtuvmXbnYNd5H2K2cNEjJr6U2U9EeGxULcdWc5Pm3/0LTmHpm+IIVgqP
BHRTthDuzIWQUrTshKhJsYp2jdnpeDariprMMOoYCUM3jL5Ihm40x6ibJU35zk7M
L996HRsu+A+3bVZlkCM15KzR4c7xL1Hk2iPophUb7KcV4HziE7HIvI6qDjczR2FZ
Q9oJy8f1KCtdgdCr8Ta0oG/NjwmKEgeD79IjqD1b8wJG04UtJR4CFNaYDXch5ELl
Dj1EnPTX7chf8oXey/MJmANgvTH7zmVO1RVui898Vkg7+fEp+8S89tIkzQa05Pu5
ipDTc4EqKSCfgLearcKoBYz6yHBJPNLdHMErO+n9cwpCNlyx00eGFkr06tUq2lqF
w9ZgRcBIskvekKRvL+5kn7vePw8TJTp5OoWHpMbE4Y2ct66bSIJZvqJWCOV/LEPk
dzTsOQBXc8I=
=AJtw
-----END PGP SIGNATURE-----

--Sig_/2oLPDNXcar22QZR_Xem/MwD--
