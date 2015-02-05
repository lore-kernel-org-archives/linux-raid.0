From: NeilBrown <neilb@suse.de>
Subject: Re: BUG drivers/md/md.c: data-offset reshape renders array
 unloadable
Date: Thu, 5 Feb 2015 17:14:02 +1100
Message-ID: <20150205171402.7dc2f394@notabene.brown>
References: <CAA-O0Xjustt5=nNoDzXukY=f-7OwRk=yqug8MCpxcXCt4MdiTw@mail.gmail.com>
	<CAA-O0XgXc0H4H__8ygLzt_BBW3NpEseG9NZBTZ_syMdir8D=mA@mail.gmail.com>
	<CAA-O0Xjw8H1nPsi+MsQnrLxv=gC2tj3=W=t3aMnCE6ESUHMF8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/9PtkrQSEuS1TC257YngTnKQ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA-O0Xjw8H1nPsi+MsQnrLxv=gC2tj3=W=t3aMnCE6ESUHMF8w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Wesley W. Terpstra" <wesley@terpstra.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/9PtkrQSEuS1TC257YngTnKQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 25 Jan 2015 17:46:20 +0100 "Wesley W. Terpstra" <wesley@terpstra.ca>
wrote:

> On Sat, Jan 24, 2015 at 11:23 PM, Wesley W. Terpstra <wesley@terpstra.ca>=
 wrote:
> >> First, it is obviously the last test in super_1_load that is rejecting
> >> the array. The superblock reports more sectors than are calculated, so
> >> the check
> >>         if (sectors < le64_to_cpu(sb->data_size)) {
> >> fails.
> >
> > Thus, an alternative explanation could be that the the sb->data_size
> > was not updated after the reshape completed.
>=20
> I can confirm that this was the problem.
>=20
> I manually modified my super block using the attached quick hack.
> Thereafter I was able to reassemble the array and fsck everything
> successfully.
>=20
> I will try and see if I can reproduce the problem tomorrow. It's a
> pretty nasty bug to have a reshape complete and render your array
> unassemblable.

Thanks for all the details and analysis!!!

A v1.2 array normally has data from the data_offset all the way to the end =
of
the device (maybe rounded  down to chunk size).

So you normally wouldn't be able to increase the data_offset from 5120 to
8192 unless you first reduced the --size of the array (having reduced the
size of any filesystem first).
Did you do that?  That should have reduced sb->data_size appropriately.

If you did --grow the --size first, that should have reduced sb->data_size.
If you didn't the --grow --data-offset should have failed.

Obviously one of those 'should's didn't...

NeilBrown

--Sig_/9PtkrQSEuS1TC257YngTnKQ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVNMKKjnsnt1WYoG5AQJ2dhAAmwobqsKqov+7KdPzQm3H7/KZPLqic2x2
YpGJZgKefXrj1OSZO/13uIb7iY4UMmbpf8bWO/DOtJSi+rSjBj60Y9oN9A+csXb3
awOaBE+r62gawIthEV3Fkn8v0h/mMKiTEG7cDDswUZeWMJGPRTrgF9R+Vlr7Ansy
/gOO59iyl16uGh++J1Gt6mnvH9lLjsxAuV9eE0RkgKb4hRv2l12hVOAz08y9WW4p
MOMKQUvUVVvlSv9v9D9Snh9lyaHM3v9jfXlBXss2SrhJ0bZCUC3jTDGFli64WVdj
/1lmk8fbnZzUC4AtePvSm2wsd8Llf8F0fpWUqmmf7Yak5JOoP0ux4UKswdSEcoFJ
OHNR95+2rY1oRirVPe6B9f0HS5uRhcj+pSSb+uE5+ynyAvAS7VCoBuzdOaMDrGSM
ozxD716+hf2JHC1txTj01lRXre/pwhmmHaRmKDj/1OCN475Thvktwtx/hecx6J8k
En/erfuHRDOmF2HhHIfwjPwKPZMOGb+MXYtOQFaz3uOX+bpK2FFjBKheshZamM/e
/HPlqsRpCbKTAfITFNh9ngjzk2dT2ZWug3bCkrz7327/CaKtxT8Ssf9NaknN0de3
KWSnPYOCm9rdsY0fJ6hKcBuXGJhqFqi+jzEyMuHi/VXFShKBDC5JONtEkTgJ8LQ/
1jCPYbK5rXU=
=OwgG
-----END PGP SIGNATURE-----

--Sig_/9PtkrQSEuS1TC257YngTnKQ--
