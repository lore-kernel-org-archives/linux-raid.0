From: NeilBrown <neilb@suse.com>
Subject: Re: RFC - de-clustered raid 60 or 61 algorithm
Date: Thu, 08 Feb 2018 14:14:29 +1100
Message-ID: <876078maui.fsf@notabene.neil.brown.name>
References: <9f9e737c-d6d1-5cce-8190-14d970320265@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9f9e737c-d6d1-5cce-8190-14d970320265@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wol's lists <antlists@youngman.org.uk>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 08 2018, Wol's lists wrote:

> After the de-clustered thread, Neil said it would probably only take a=20
> small amount of coding to do something like that. It was also discussed=20
> about spreading the load over disks on a reconstruction if there were a=20
> lot of disks in an array. I've been trying to get my head round a simple=
=20
> algorithm to smear data over the disks along the lines of raid-10.
>
> Basically, the idea is to define a logical stripe which is a multiple of=
=20
> both the number of physical disks, and of the number of logical disks.=20
> Within this logical stripe the blocks are shuffled using prime numbers=20
> to make sure we don't get a pathological shuffle.
>
> At present, I've defined the logical stripe to be simply the product of=20
> the number of logical disks times the number of mirrors times the number=
=20
> of physical disks. We could shrink this by removing common factors, but=20
> we don't need to.
>
> Given a logical block within this stripe, its physical position is=20
> calculated by the simple equation "logical block * prime mod logical=20
> stripe size". So long as the "prime" does not share any factors with the=
=20
> logical stripe size, then (with one exception) you're not going to get=20
> hash collisions, and you're not going to get more than one block per=20
> stripe stored on each drive. The exception, of course, is if physical=20
> disks is not greater than logical disks. Having the two identical is=20
> especially dangerous as users will not expect the pathological behaviour=
=20
> they will get - multiple blocks per stripe stored on the same disk.=20
> mdadm will need to detect and reject this layout. I think the best=20
> behaviour will be found where logical disks, mirrors, and physical disks=
=20
> don't share any prime factors.
>
> I've been playing with a mirror setup, and if we have two mirrors, we=20
> can rebuild any failed disk by coping from two other drives. I think=20
> also (I haven't looked at it) that you could do a fast rebuild without=20
> impacting other users of the system too much provided you don't swamp=20
> i/o bandwidth, as half of the requests for data on the three drives=20
> being used for rebuilding could actually be satisfied from other drives.

I think that ends up being much the same result as a current raid10
where the number of copies doesn't divide the number of devices.
Reconstruction reads come from 2 different devices, and half the reads
that would go to them now go elsewhere.

I think that if you take your solution and a selection of different
"prime" number and rotate through the primes from stripe to stripe, you
can expect a more even distribution of load.

You hint at this below when you suggest that adding the "*prime" doesn't
add much.  I think it adds a lot more when you start rotating the primes
across the stripes.

>
> Rebuilding a striped raid such as a raid-60 also looks like it would=20
> spread the load.
>
> The one thing that bothers me is that I don't know whether the "* prime=20
> mod" logic actually adds very much - whether we can just stripe stuff=20
> across like we do with raid-10. Where it will score is in a storage=20
> assembly that is a cluster of a cluster of disks. Say you have a=20
> controller with ten disks, and ten controllers in a rack, a suitable=20
> choice of prime and logical stripe could ensure the rack would survive=20
> losing a controller. And given that dealing with massive arrays is what=20
> this algorithm is about, that seems worthwhile.

The case of multiple failures is my major concern with the whole idea.
If failures were truly independent, then losing 3 in 100 at the same
time is probably quite unlikely.  But we all know there are various
factors that can cause failures to correlate - controller failure being
just one of them.
Maybe if you have dual-attached fibre channel to each drive, and you get
the gold-plated drives that have actually been exhaustively tested....

What do large installations do?  I assumed they had lots of modest
raid5 arrays and then mirrored between pairs of those (for data they
actually care about).  Maybe I'm wrong.

NeilBrown


>
> Anyways, here's my simple code that demonstrates the algorithm and=20
> prints out how the blocks will be laid out. Is it a good idea? I'd like=20
> to think so ...
>
> Cheers,
> Wol
>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
>
> void main()
> {
>      int disks, logdisks, mirrors, prime;
>
>      printf( "%s", "Enter the number of disks ");
>      scanf( "%d", &disks);
>      printf( "%s", "Enter the number of logical disks ");
>      scanf( "%d", &logdisks);
>      printf( "%s", "Enter the number of mirrors ");
>      scanf( "%d", &mirrors);
>      printf( "%s", "Enter the prime ");
>      scanf( "%d", &prime);
>
>      int blocks, *array;
>
>      blocks =3D logdisks * mirrors * disks;
>      array =3D (int *) malloc( sizeof(int) * blocks );
>      memset( array, '\0', sizeof(int) * blocks );
>
>      int i;
>
>      for (i=3D0; i < blocks; i++) {
>          array[i] =3D (i * prime) % blocks;
>      }
>
>      int logstripe, logdisk;
>
>      for (i=3D0; i < blocks; i++) {
>          if ( (i % disks) =3D=3D 0) {
>              printf( "\n");
>          }
>
>          // printf( "%4d", array[i]);
>
>          logstripe =3D array[i] / (mirrors * logdisks);
>          logdisk =3D array[i] % logdisks;
>          printf( "  %02d%c", logstripe, (char) logdisk+65);
>
>      }
>      printf( "\n");
> }

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlp7wJUACgkQOeye3VZi
gbmjzQ//cZRriUnNRQza7fGfsHrEWsGmx4ncxPKtW+Rl6n8YzMUkHVhXSU1q1maM
BaOiI7awn6qt66z0e0Qkg3Va32ot/pvgIkL1CnBNktO6hPLA3ZmtGsRl9VczhgcA
GH9Gue+XTD8CxzCcVsZg4Kvo0QCrHLF+Qy9vbMIWpxrSPqrbckBKlyOQsoWx89au
qdY5hs6JuOZPciQU1hnvhrIxgnCqYan1pYn0sqiU4EWVvCHyQgitpUliHUIljiTS
TmDctjSlTbqbsGZbYRSpKQXSU5dUNIbVPZ4CFKiM1g6de3Lojxg8I/i3zEydStQs
Fg5uIiiagf5I21u2lVHFC/GGe0PUYcNFICJQKZpPaK6440s+pxIipKgLAaAgeFv7
HsUBE0/YZxUxDsJVZYKiqh5R18JAOm8HVWrOa1jFuXXLrquSZ1iX0ae9yjxZJjO+
ch9cDYAaqe7x9SUoLgC6Gdd2IVT/7JMN/mf2GfN1LiaDnAauv3NzWNPMPxaX+pfu
tAgkIrxj9achbMPA8TjhOnMwhrN7Lud1kecJQtMDJa2jSSX4/S3D3H5I39i06qMg
k93rcGQAbyTBHdKsRvqtQGBJ6e1xc0u7exumtQcn8/4vQ+K5HaCrV2pSaO2sinPR
3OO5Lz3gcH9qU24w03mLzILud8BDd+YbzGhGBY4rEnzg6p0nCQA=
=3pD0
-----END PGP SIGNATURE-----
--=-=-=--
