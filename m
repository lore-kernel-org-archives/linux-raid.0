From: NeilBrown <neilb@suse.de>
Subject: Re: error injection
Date: Thu, 29 Sep 2011 09:11:28 +1000
Message-ID: <20110929091128.1488f267@notabene.brown>
References: <CAJD3hpWbkSGeiWDgYHP3ewnw7akoEY-ydoRJKLxwcp8+up5zKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FP1uXW4iFq8SknZRmb7f7k8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJD3hpWbkSGeiWDgYHP3ewnw7akoEY-ydoRJKLxwcp8+up5zKw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jojy Varghese <jojy.varghese@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/FP1uXW4iFq8SknZRmb7f7k8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Sep 2011 12:48:37 -0700 Jojy Varghese <jojy.varghese@gmail.com>
wrote:

> Hi
>  I am trying to dynamically add error injection to my virtual
> disk(LVM) for testing+ debugging purpose. I saw "faulty" personality
> module in the kernel and was wondering if there was any documentation
> on its usage. I am not looking to set up a RAID but a simple mapped
> device. So the basic use case is that I need to be able to dynamically
> add/remove error sectors and also be able to have granular error
> configuration like read error, read+write error etc.
>=20
> thanks in advance
> Jojy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

The 'faulty' md personality is described briefly in the 'md.4' man page whi=
ch
is included in the mdadm distribution.
I've included the relevant part below.

Configuring the type of faults is described in mdadm.8 under the '-p
--layout=3D' section.  So can adjust the settings using mdadm --grow.
so:
  mdadm -B /dev/md0 -l faulty -n1 /dev/sda

will build a 'faulty' device which provides access to /dev/sda, but
introduces faults.  Initially no faults will be introduces.

  mdadm -G /dev/md0 --layout=3Drt400

will tell md0 to generate a read error every 400 requests, but not to
remember the error - rt =3D=3D readtransient
   --layout=3Drp400
will create a persistent error every 400 reads subsequent reads of the same
block will produce the same error.  at most 50 persistent errors can be
recorded.
  mdadm -G /dev/md0 --layout=3Dclear
will stop producing new errors
  mdadm -G /dev/md0 --layout=3Dflush
will forget all persistent errors.


from md.4:

   FAULTY
       The FAULTY md module is provided for testing purposes.  A faulty  ar=
ray
       has  exactly  one  component device and is normally assembled withou=
t a
       superblock, so the md array created provides direct access  to  all =
 of
       the data in the component device.

       The  FAULTY module may be requested to simulate faults to allow test=
ing
       of other md levels or of filesystems.  Faults can be chosen to  trig=
ger
       on  read requests or write requests, and can be transient (a subsequ=
ent
       read/write at the address will probably succeed) or persistent  (sub=
se-
       quent  read/write of the same address will fail).  Further, read fau=
lts
       can be "fixable" meaning that they persist until a write request at =
the
       same address.

       Fault  types  can  be requested with a period.  In this case, the fa=
ult
       will recur repeatedly after the given number of requests of  the  re=
le-
       vant type.  For example if persistent read faults have a period of 1=
00,
       then every 100th read request would generate a fault,  and  the  fau=
lty
       sector  would be recorded so that subsequent reads on that sector wo=
uld
       also fail.

       There is a limit to the number of faulty sectors that  are  remember=
ed.
       Faults  generated  after  this  limit is exhausted are treated as tr=
an-
       sient.

       The list of faulty sectors can be flushed, and the active list of fa=
il-
       ure modes can be cleared.


from mdadm.8:

              When setting the failure mode for level faulty, the options a=
re:
              write-transient, wt, read-transient, rt,  write-persistent,  =
wp,
              read-persistent,  rp, write-all, read-fixable, rf, clear, flu=
sh,
              none.

              Each failure mode can be followed by a number, which is used =
 as
              a  period between fault generation.  Without a number, the fa=
ult
              is generated once on the first relevant request.  With a numb=
er,
              the  fault  will be generated after that many requests, and w=
ill
              continue to be generated every time the period elapses.

              Multiple failure modes can be current  simultaneously  by  us=
ing
              the --grow option to set subsequent failure modes.

              "clear"  or  "none"  will remove any pending or periodic fail=
ure
              modes, and "flush" will clear any persistent faults.



NeilBrown


--Sig_/FP1uXW4iFq8SknZRmb7f7k8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOg6mgG5fc6gV+Wb0RAm2xAJ9jF985UPsLXJi04JwgVyTUEFQeSgCghRV0
DVWkE6l7RR/4pUiAR49dheM=
=/vRq
-----END PGP SIGNATURE-----

--Sig_/FP1uXW4iFq8SknZRmb7f7k8--
