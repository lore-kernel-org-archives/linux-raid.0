From: NeilBrown <neil@brown.name>
Subject: Re: Restoring a raid0 for data rescue
Date: Mon, 03 Aug 2020 14:37:29 +1000
Message-ID: <873654tkdy.fsf@notabene.neil.brown.name>
References: <S1726630AbgHBR6v/20200802175851Z+2001@vger.kernel.org> <68c39e83-1155-0c8d-96a9-0418bdaf850d@gmx.de> <7437ab4d-9cd1-fe53-a17a-fc9e966ccd92@youngman.org.uk> <d8f9d16d-b6a2-77ba-bff2-a56c62dac5df@gmx.de> <057b0c58-3876-0f03-af33-86f3b266a18a@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <057b0c58-3876-0f03-af33-86f3b266a18a@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: tyranastrasz@gmx.de, antlists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Sun, Aug 02 2020, tyranastrasz@gmx.de wrote:
>
> I tried something what was told here
> https://askubuntu.com/questions/69086/mdadm-superblock-recovery
>
> root@Nibler:~# mdadm --create /dev/md0 -v -f -l 0 -c 128 -n 2 /dev/sdd
> /dev/sdb

That was a mistake.  I probably could have saved you before you did
that.  Maybe I still can...

You have an Intel IMSM RAID0 array over sdb and sdd.
This was 3711741952 sectors in size using the first 1855871240 sectors
of each device - data arranged in 7249496 256KiB stripes (128KiB on each
device).

This 1900GB array was partitioned into 3 partitions: 3MB, 1800MB,
and 18MB.

Presumably the data you want is on the 2nd partition: the 1800MB one?

When you ran the "mdadm --create" command it wrote some meta data at the
start of the device - probably only a 4K block at 8K from the start.
This is before the first partition, so it might not have affected any
data at all.  It may have corrupted the partition table.

You need to put the array together again without writing anything to
it.  Fortunately that is fairly easy with RAID0.

1/ If /dev/md0 still exists, stop it "mdadm --stop /dev/md0"
2/ put the two devices into a RAID0 with no metadata.
    mdadm --build /dev/md0 -n 2 -z 927935620 -c 128 -l 0 /dev/sdb /dev/sdd

3/ create a read-only loop device over the second partition
    losetup -r -o 4096K --sizelimit 7176980M /dev/loop0 /dev/md0

4/ Examine the filesystem at /dev/loop0 READ-ONLY.
  You didn't say what sort of filesystem you used.  If ext4, then
     fsck -n /dev/loop0

5/ If it looks good, try mounting /dev/loop0 READ-ONLY.

I recommend that you FIRST read the relevant parts of the mdadm and
losetup man pages, and check my arithmetic to make sure the numbers that
I have given are correct.  If unsure, ask.

If it doesn't work, I recommend reporting results, asking, and waiting
before doing anything that might change anything on the drives.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAl8nlIoACgkQOeye3VZi
gbkUbQ//UvGsaLeHtU5xMKsnTlbxE/nQjaZONJzjmbK4ONLwe5ZXfKOjcCmo6fxn
Qutm3b4UZtvcNMPf4utHa21g5v6Xos90epsK8AZcry2TUKLccQ0ad6fRbRFixaSJ
kNpa6U0FPrb95JjWYTn0mikanqjH6iOg8rHzuzFFYcgYboDbhsoorJcsLTnUPwrz
xph83oKs/QM1WHltPyWq6V0Xrm/bKMlGuMVdC9GRdo55TnLmbojwKIsBOL9JDL2Y
KrfBbq8K0LpIDt0Qbm5P2W3crq83nTm5+aoV8+dZ0zUqpZdanfsfmS51aUxcnXc8
karLrNylemXBB//iFrSliexnjfet1nXPjfBPN73T0zsXlvVUZj5Tv9uqF+YZX3iT
riU4GKvN5cL4s+60xG/tVry32VZP8ZlOBhHNxtN4jh95S6BTD4oAMYy2CbY6o/t5
4atcHL1enWfzOlTtx6CqP/nIZHXM1tQ1fOW0KIxlCVrZNGbUdPL3F1Ulr4PnXfvy
Gr3c8U0eGyAg9nipr5ognFheyxANHITyTwIP13enTrCD9SxIr1j9wP/EYsxcTsJ4
sRKOUJ6Z2BU6fXTxegcBibHJRwDNfYliXuhXmpjV5Xg6POyp51rcYHvXBIoUByyC
eLJhTu86cqZOpAncYKm0ziOYdHGH/COy+JT2uAKeNKXRKlM9CGY=
=tvSG
-----END PGP SIGNATURE-----
--=-=-=--
