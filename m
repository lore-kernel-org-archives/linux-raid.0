From: Patrik Jonsson <patrik@ucolick.org>
Subject: Re: problem killing raid 5
Date: Mon, 01 Oct 2007 11:58:48 -0700
Message-ID: <47014368.4040204@ucolick.org>
References: <4700D454.7020607@gmail.com> <47013A6B.30302@gmail.com> <470140B5.3020203@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA73F3CEC194B3AC933247503"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <470140B5.3020203@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Daniel Santos <daniel.dlds@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA73F3CEC194B3AC933247503
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael Tokarev wrote:
> Daniel Santos wrote:
>> I retried rebuilding the array once again from scratch, and this time
>> checked the syslog messages. The reconstructions process is getting
>> stuck at a disk block that it can't read. I double checked the block
>> number by repeating the array creation, and did a bad block scan. No b=
ad
>> blocks were found. How could the md driver be stuck if the block is fi=
ne ?
>>
>> Supposing that the disk has bad blocks, can I have a raid device on
>> disks that have badblocks ? Each one of the disks is 400 GB.
>>
>> Probably not a good idea because if a drive has bad blocks it probably=

>> will have more in the future. But anyway, can I ?
>> The bad blocks would have to be known to the md driver.
>=20
> Well, almost all modern drives can remap bad blocks (at least I know no=

> drive that can't).  Most of the time it happens on write - becaue if su=
ch
> a bad block is found during read operation and the drive really can't
> read the content of that block, it can't remap it either without losing=

> data.  From my expirience (about 20 years, many 100s of drives, mostly
> (old) SCSI but (old) IDE too), it's pretty normal for a drive to develo=
p
> several bad blocks, especially during first year of usage.  Sometimes
> however, number of bad blocks grows quite rapidly and such a drive
> definietely should be replaced - at least Seagate drives are covered
> by warranty in this case.
>=20
> SCSI drives has 2 so-called "defect lists", stored somewhere inside the=

> drive - factory-preset list (bad blocks found during internal testing
> when producing a drive), and grown list (bad blocks found by drive
> during normal usage).  Factory-preset list can contain from 0 to about
> 1000 entries or even more (depending on the size too), grown list can
> be as large as 500 blocks or more, whenever it's fatal or not depends
> on whenever new bad blocks continues to be found or not.  We have
> several drives which developed that many bad blocks in first few
> months of usage, the list stopped growing, and they're still working
> just fine for >5 years.  Both defect lists can be shown by scsitools
> programs.
>=20
> I don't know how one can see defect lists on a IDE or SATA drive.
>=20
> Note that md layer (raid1, 4, 5, 6, 10 - but obviously not raid0 and
> linear) are now able to repair bad blocks automatically, by forcing
> write to the same place of the drive where a read error occured -
> this usually forces drive to automatically reallocate that block
> and continue.
>=20
> But in any case, md should not stall - be it during reconstruction
> or not.  For this, I can't comment - to me it smells like a bug
> somewhere (md layer? error handling in driver? something else?)
> which should be found and fixed.  And for this, some more details
> are needed I guess -- kernel version is a start.

Really? It's my understanding that if md finds an unreadable block
during raid5 reconstruction, it has no option but to fail since the
information can't be reconstructed. When this happened to me, I had to
wipe the bad block, which should allow reconstruction to proceed at the
cost of losing the chunk that's on the unreadable block. The bad block
howto and messages in this list ~2 years ago explain how to figure out
which file(s) is affected.

This is why it's important to run a weekly check so md can repair blocks
*before* a drive fails.

cheers,

/Patrik


--------------enigA73F3CEC194B3AC933247503
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHAUNpT+KvsdUW5p8RAjwlAJwL3fpTNwNAvZD5Zk+vtY2g7SJPBgCcCE4I
9LJ0K4LueJaIftTcPYfoohw=
=nLln
-----END PGP SIGNATURE-----

--------------enigA73F3CEC194B3AC933247503--
