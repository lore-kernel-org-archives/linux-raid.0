From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 syncing at 24 MB/s?
Date: Wed, 18 Apr 2012 15:05:02 +1000
Message-ID: <20120418150502.41d6305d@notabene.brown>
References: <20120418043540.19923.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Al/IpvUSf75=nZcf/KXZric"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120418043540.19923.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Al/IpvUSf75=nZcf/KXZric
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On 18 Apr 2012 00:35:40 -0400 "George Spelvin" <linux@horizon.com> wrote:

> I'm putting together a 7x2TB RAID6 for a home media server, and after
> encountering a fun kernel bug building the array (old kernel, a new one
> fixed it), I fot things working, but now notice that each disk is syncing
> at 23.8 MB/s.  hdparm -t reports they can do well over 100 MB/s each,
> and the processor, while only an i3, is spending about 20% of one core
> in the raid6 task.

Can you try an experiment for me (if you don't have anything useful on the
array yet)?

Stop the array.  Recreate it exactly the same way as before, and see if it
goes faster.  I think it might - at least until it got up to where it was up
to.

NeilBrown


>=20
> Basicall, it was created with:
> mdadm -C -l 6 -n 7 -c 128 -b internal /dev/md0 /dev/sd[b-h]
> (The kernel bug was in 2.6.35, and was triggered by forgetting the
> "/dev/md0"; one of the RAID ioctls it tries confused up the /dev/sd
> driver quite thoroughly)
>=20
> It's an Intel chipset motherboard with a jmicros 2xSATA+PATA chip,
> and one port on a SiI3132 plug-in card.  And mostly cheap Caviar green
> EARS drives (yes, I know about the lack of TLER).  Note that I didn't
> partition the drives, so there's no risk of a 4K-unaligned partition.
>=20
> A friend with his own Linux media server said he saw the exact same speed
> building his RAID6 array.
>=20
> The speed_limit_max is set to the default, the system is idle, and the
> resultant md drive is not mounted.
>=20
> Is there a web page somewhere with speed tuning suggestions?
>=20
>=20
> Thank you!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/Al/IpvUSf75=nZcf/KXZric
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT45Lfjnsnt1WYoG5AQKHyQ/8Dwjeoldga3WMVs/GT806BjWP7YrAFgSJ
QIbusQ7NUWiRld3166YeOm3KVkK0jXjfPnj86drq2Grkb8fK18CirOFiXWSHu9Qh
15LMO5vKomQy6hTDxkNXwwBvyhuUIPsK0EeR4JXgMJBapvW4+SZmrk/VDrjdChE7
10j3ZJHEPkeNhJ+GFi2YXnNFtimW9B4JY/CTafkbQRhIqyguorcTu9r1LF5PG9X8
1VYwv1OJ0VLx0rBQXZGVdNpUZ7jR7YJHg7l8SzOyPJ82Pr1niPUtWHGJGaYYf3+/
0JsKsQFhOMzaXAFlbf7ttdv/yRpeaE4Uhku3l19yBzPBcILHcRq3eWVE0zvNNTWw
wnw8Am2W6yq/auL8Ny0MyNtcfEePz9FAoy1xF7MocyfOHa6isFn6KxKkgQ7Koa8j
XjSuTDHQJ/5F/oq36UpZ93lXnvOhuD1NsKGdNHOUtmKPPgX2Yqf+hK0gqiN2DIEQ
CWFS1uFP6ArSIus2Vc/+0SGoXe2NpWX+OTlwcipZVgcZX+5a1O6Uz+juSh97pJMY
td/CCLWsS67cvRqpPSCS/6Lxw7lNLMhMc2c8xMI6iWlf4UdJq5u4tLpNkzRkN2JH
Pu2JTtczXDvW1kGiSalpITFkGnVSEA+95bxgwVZtOCuqdJPD6cbYchz3oNXiYBsI
Wp9YGWuwYjk=
=7Iy4
-----END PGP SIGNATURE-----

--Sig_/Al/IpvUSf75=nZcf/KXZric--
