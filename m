From: NeilBrown <neilb@suse.de>
Subject: Re: Does the chunk size of RAID5 really mean the "smallest atomic"
  mass of data?
Date: Mon, 19 Aug 2013 11:33:49 +1000
Message-ID: <20130819113349.7497892e@notabene.brown>
References: <0d357591ae9c24e2e07dadd5ce7ee873.squirrel@davinci.snu.ac.kr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/K+0uBBiHttlStWSMy57T3Mi"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0d357591ae9c24e2e07dadd5ce7ee873.squirrel@davinci.snu.ac.kr>
Sender: linux-raid-owner@vger.kernel.org
To: taejin1999@davinci.snu.ac.kr
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/K+0uBBiHttlStWSMy57T3Mi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Aug 2013 10:10:18 +0900 taejin1999@davinci.snu.ac.kr wrote:

> I have counted the number of write requests from the raid disks which are
> implemented as virtual block devices.
> The result is
>   ** the larger chunk size is, the more write requests are received per
> device.

That is peculiar.  How do the sizes of the write requests compare?

>=20
> I was wondering what the "chunk size" means on RAID5 of mdadm.
> According to below site, chunk is the smallest atomic mass of data that
> can be written to the device.

That isn't correct.

> (https://raid.wiki.kernel.org/index.php/RAID_setup)

The text for chunksize for RAID5 is a little unclear, but I'm not sure how
you reached the above conclusion from it.

>=20
> The source code, however, seems to work differently.
> As I know, mdadm issues bio to each device in ops_run_io function.

It is "md" that issues bios etc.  "md" is the kernel driver.  "mdadm" is the
tool for ADMinistering MD arrays.

> In the code, the size of bio is set to be only STRIPE_SIZE.
> I think the device would get STRIPE_SIZE-sized data which is smaller than
> the chunk size.

Correct.  Though the elevator might merge bios together.

>=20
> Is the chunk size not smallest data that can be written to the device?

It is not

> Or is there any procedure that merge the STRIPE_SIZE-sized data into
> chunk-sized data?

That depends on the lower level device that received the bios from md.  It
might merge multiple bios into single requests.

>=20
> I am looking forward to your reply.
> Thank you.
>=20
> PS) Could you guess why more writes are issued for larger chunk size?

Maybe there are more read-modify-write cycles so the parity gets updates
multiple times.

NeilBrown


>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/K+0uBBiHttlStWSMy57T3Mi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUhF1/Tnsnt1WYoG5AQKU4A//aGl08gmyCvw9Zq82cRCrX7wY0+8tTvjq
NTBLG2PSm1vbfTyXLiWVFBvHV6G218D67q/AfPhyAmQpIKp/tCj1FmzU+l3lqqiO
VbUNHVfVvebzrc8c1rcYvPYZxgBqwYyHfNwRiXZ9ho6kGg0H7cHbB25ZpOp34T99
3kwlNjrBN4g3zah+KqmPmvOhnqbV5se/wMA+/+BGPBRHGBO32PqRE32xvHMjW17n
u/deIs/BKHfXCpnSy4aKiocK+EmjqBowJPvnBWJI0gqOedMXb+8oC5pSca2KG7MZ
oeouOSwpzDrGwB3GUALH102PyVGKKSl3F0XhL8vJe8Q6th1JlmcF6xlyXSfD2vq5
FW7BFNfRQLv/iWRkS+BPloUdQssKQOKQRsb8cnQW5a0HOAR5nBZXyaq483k7EolO
LyYSKjRi7rq4ESKDU7SOgGRV6oFmImR2+thqWO2LThDgDSO7i5BvU1NR7VYGQc30
ElSCBFzX6b0hI2KUKB+b2Swh92Hv7oV7t/fyIrUxwJpZ+OehAD7Wp1knZjIaLjFn
4ixJ1GkJPo3HFCnVrsdnJCQ31HnZ94gGi3uIgdM7X9KqpzmV43EaQjgmh+1L6GYk
ZZFY2Cd2eXu62lXwgcTngpRuBx9ktrB3WbhGAJwrrecOtpmUfdA31GUGrBAFVCCU
5KrX4So17jE=
=Xk+/
-----END PGP SIGNATURE-----

--Sig_/K+0uBBiHttlStWSMy57T3Mi--
