From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm --grow with --backup-file does not create backupfile?
Date: Mon, 13 Oct 2014 12:39:14 +1100
Message-ID: <20141013123914.04b960ed@notabene.brown>
References: <543B2A2D.9080407@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/xJAKzKeSFrhZjA7WHoOG/iC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <543B2A2D.9080407@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/xJAKzKeSFrhZjA7WHoOG/iC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 12 Oct 2014 20:26:05 -0500 Ram Ramesh <rramesh2400@gmail.com> wrote:

> I added a new disk and grew my raid6 md0 with the following command line
>=20
>     sudo mdadm --grow --raid-devices=3D5
>     --backup-file=3D/root/grow_md0.bkp_file --layout=3Dnormalise /dev/md0
>=20
> I got a response that stated that mdadm needed to backup 384K of data.=20
> However, when I checked after about 5min there was no backup file. Is=20
> this expected?

Yes.

When increasing the size of an array, the backup file is needed  for a tiny
fraction of a second at the start.
When decreasing the size it is needed  for a tiny fraction if a second at t=
he
end.
When the size isn't changed it is needed for the entire time.

... unless you have a new kernel and a new mdadm, and then the backup file
isn't needed.

NeilBrown



>=20
>     386 > sudo ls /root
>     <no files. so no output>
>     387 > sudo ls /root/grow_md0.bkp_file
>     ls: cannot access /root/grow_md0.bkp_file: No such file or directory
>=20
> Ramesh
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/xJAKzKeSFrhZjA7WHoOG/iC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVDstQjnsnt1WYoG5AQJ8PxAAkYt5jO1CYjRbmviMprnPhDePFQ7g2xmQ
EHfFz3spVPq3XURouDFSDiE0LXb0qeiBfW+FjHGjND8xNsd4uhPTDX7xz1rOgLro
VSfMRV/cW0JKljmfqRuSJcliKUIY8cOs+twc5xCo60sxTvVnxNXqhALLpkjujf40
YHlioQIGkmPIW9KWLw6fV6AivIHvDbD0Es7yx8+Y1Njazvi6p4OCMkYWKBo41L7w
hYG0N/PvuZ/PzKxXwfFDW8npfL6PEVBuJ/gKLMQcXo1872bsZofZ6VLxWvSWWlcg
DZPLbj4XrbF/gAfSOao4eahQEU3qHCjSfDAHyoMUjekRd4o87X/QHYVB+44UOEFV
v/ZAXKUondr+ElrwhEeqnraGeHcbO6KnzQPn6Gq0HAfBUg/TN7oPQlDmGl5vu3qd
dhYB2ETFv+qlRXfYdg/roOtGAwBAEnuke4t8H4u6+y/FO2l46JZX+FVg/E3Ct12u
kxvYxI+l9B8RNc2XMNriUqcXUOC6tbcDX4RzB1KlrTTNbKsiNqD1JiKf4mG/807W
oA6Y4HSnCe8XRwOcbFXEs0Udzi8JFqDPbLO49IhTE9UsGXf8zV/h1joe6dXeXZni
eTkOc01AT069NtNj09FpofnCEnefODm5hLKvd9tT03h7e0m5UaBDpWpunuu09npF
HaJFKUkO3g4=
=SfXV
-----END PGP SIGNATURE-----

--Sig_/xJAKzKeSFrhZjA7WHoOG/iC--
