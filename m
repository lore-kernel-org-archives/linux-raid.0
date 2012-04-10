From: NeilBrown <neilb@suse.de>
Subject: Re: Failed Array Rebuild advice Please
Date: Wed, 11 Apr 2012 09:02:19 +1000
Message-ID: <20120411090219.78392784@notabene.brown>
References: <1334097164.41181.YahooMailNeo@web125506.mail.ne1.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/xzscPJrqEAe.P4J__/69uIz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1334097164.41181.YahooMailNeo@web125506.mail.ne1.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: jahammonds prost <gmitch64@yahoo.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/xzscPJrqEAe.P4J__/69uIz
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Apr 2012 15:32:44 -0700 (PDT) jahammonds prost
<gmitch64@yahoo.com> wrote:


> Since I know I did nothing with the temp one drive array when the server =
was booted (and I don't think that the md code did anything either??) would=
 it be safe to=20
> =A0
> mdadm --assemble /dev/md0 /dev/sd[a-c]1 /dev/sd[e-h]1 /dev/sd[j-l]1 /dev/=
sd[n-p]1 --force
> =A0
> to let the array come back up and get it running?

Yes.   Though you don't need to exclude the oldest devices.  mdadm will
figure out which ones to use and which ones to avoid.


> =A0
> What would then be the correct sequence to replace the 2 failed drives (s=
dd1 and sdm1) and get the array running fully again?

If you trust that sdd and sdm really are working now, you can

 mdadm /dev/md0 --add /dev/sdd1 /dev/sdm1

This will probably start rebuilding just one of the devices. You can check
with
   mdadm -D /dev/md0
which will report "spare building" against one or more devices.
If it is only rebuilding one of them, then

  echo idle > /sys/block/md0/md/sync_action

will cause it to stop and restart the recovery.  It will then recovery both
devices in parallel.

(Next version of mdadm will do this automatically).

NeilBrown


> =A0
> =A0
> Thanks for your help.
> =A0
> =A0
> YP.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/xzscPJrqEAe.P4J__/69uIz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4S7+znsnt1WYoG5AQJ+3Q/7BZF9FG9gHgn/+hovKnMrcLSAY97LJnRT
aI1AkoFEqQCnuxcViwGR/U5Inyx4cp7ihh2wJxOX7vTMJAS/MsJLd3GhT8hhh9f4
gxOaIgcsHRWrSYDX9BM1Y7YZalgnwW5CfAOzZYHPVx9NAP5BXo3abel2OD4JJdBh
f/qGiePMOZMd1c+B09ywIA5jjiBbhqQg2Tw1VLGiB806pmu3+tBEjN4PzDdyr7tH
qhG5XHe9AWDiFil5b5sm6f85MD+TJifEqF+1y/3ze5gpz92TpCrt2fI5kcFQi7tV
hSPLDL++Nd5zJ3FqCDBc/4N+Juvxe5gdaNo+h/hPN7cLvlMpsj1/tnEwmX4jwoqT
ae2/gqGK9iodca4movZtogCgXAVjYY59YcuwM8ZhTq9Dn1CJDwoPY1a4jSJwYGfS
4DsmD1skrnjmW51lzoonzJgt/pZpWgEGhLxrdlMAht6Afure7wUnirz0dmyWIuaA
uM0rGYra1g3+KJUQFsnq+Ec9qX7uL6+eEhxn+9f0RroI/+Zk0MyMaLoCgoqm5VIP
c+MIgkHj3Qj65BK52ELrkqfzEPB1MLNHzWG6hWQcR/p8jKHN6RW+KZknTR7W+T0R
V4v3zvGvoBjWtzgTl3Cz5LhB9PLZTn4aroUnedNCqtkoZr8nUjiafgVEcuRHAdE+
1M1obIPNnKk=
=8UGm
-----END PGP SIGNATURE-----

--Sig_/xzscPJrqEAe.P4J__/69uIz--
