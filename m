From: NeilBrown <neilb@suse.de>
Subject: Re: Converting a .90 raid superblock to version 1.0 and
 whether--size parameter is needed
Date: Wed, 18 Mar 2015 12:10:54 +1100
Message-ID: <20150318121054.066b963b@notabene.brown>
References: <21CFD7CC-7A05-4298-BD77-E1287B9F78D5@backblaze.com>
	<149825A6-89BC-4804-915B-5241EEB15300@backblaze.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/=COWGxbxocvhl_GxoLSNIyl"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <149825A6-89BC-4804-915B-5241EEB15300@backblaze.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sean Harris <sean@backblaze.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/=COWGxbxocvhl_GxoLSNIyl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Mar 2015 15:49:36 -0700 Sean Harris <sean@backblaze.com> wrote:

> Hi Neil and company,
>=20
> I have roughly a hundred machines that are still on Debian 5 that are sla=
ted for OS upgrades, and a great many of those are running software raid wi=
th the 00.90 version superblock. I even have a few machines on debian 7 wit=
h the .90 superblock because the boot drive for the machine had been replac=
ed at some point.
>=20
> I would like to explore the idea of upgrading/converting the raid superbl=
ock on many of those machines to version 1.0, mostly to keep the environmen=
t as uniform as possible, and standardize training for my SysAdmins on re-a=
ssembling failed raid arrays.
> But I am not sure if it is a safe and necessary, or even a worthwhile end=
eavor.

Safe:  there is no intrinsic reason for it not to be safe.  Obviously any
   change brings risks, but they can be managed with care.
Necessary: It is only necessary from the technical perspective of md if you
   want to use some features that are only available with 1.x metadata.
   This included bad-block-logs and improved flexibility for reshaping
   RAID5/6/10 arrays.
Worthwhile: That is up to you.  As you say, consistency can be good and
   better familiarity for sysadmins is not a bad thing.

>=20
> I wanted to test this on a few non-production machines, but I am not quit=
e sure if I need to specify the --size parameter in the create statement in=
 the attempt.
>=20
> I have a bit of a mixed environment, but very early on, the machines init=
ialized with the .90 superblock were all created in the same way ie:
>=20
> /sbin/mdadm --create /dev/md10 --bitmap=3Dinternal --auto=3Dyes -l 6 -n 1=
5 /dev/sd{b,e,h,k,n,q,t,w,z,ac,af,ai,al,ao,ar}1
>=20

I recommend not doing it this way.  If you use mdadm-3.3 or later you can
  mdadm --assemble /dev/md10 --update=3Dmetadata ...list.of.devices..

and it will update the metadata from 0.90 to 1.0 and start the array for yo=
u.


>=20
> Most of the machines I am interested in upgrading are running Debian 5, w=
ith LVM and ext4 volumes.
> Some machines use drive partitions, but we stopped using them some time a=
go and went with the simple notion that if a drive brand was marketed as 1T=
B, we assumed a size of 1,000,000,000,000 bytes and created the array with =
that size. That way, any drive manufacturer could be used as a replacement =
spare without worrying about the variation of their respective drive sizes.
>=20
> I think it is safe to upgrade the superblock from .90 to 1.0 because from=
 what I have read, it is the same size, and in the same place as the .90 su=
perblock.

Not correct.  The 0.90 superblock is 4K in size and between 64K and 128K fr=
om
the end of the devices.  The 1.0 superblock is 512 bytes and between 4K and
8K from the end of the device.
So the 1.0 superblock uses less space than the 0.90.  But it does reside
entirely with space that is reserved when the 0.90 metadata is in use.


> But I don't know if having drives with or without partitions would make a=
 difference, or if the conversion would need a specific version of mdadm ut=
ilized.
> (My hunch is that any layers on top of the raid array are irrelevant to t=
he superblock conversion).

That's correct.


>=20
> All arrays are raid 6 with the same number of devices.
> I think what I need to run is something akin to
>=20
> /sbin/mdadm --create /dev/md10 -l6  -c64 --metadata=3D1.0 --assume-clean =
-n 15 /dev/sd{b,e,h,k,n,q,t,w,z,ac,af,ai,al,ao,ar}1

That would probably work, but again, "--assemble --update=3Dmetadata" is yo=
ur
friend.


>=20
> Where md10 is the array, the raid level is 6, 64k chunk size, assume-clea=
n (for a known good pre-existing array), 15 devices (all specified in order=
), and a metadata of 1.0.
>=20
> But I am not sure if I need to insure that --size is calculated and inclu=
ded in the conversion, or if the re-creation of the superblock simply takes=
 care of it.

It probably doesn't matter, certainly not with a chunk size of 64K or large=
r.


>=20
> The reason I am unsure on this point is that with version 1.0 superblock =
arrays, I always include the --size parameter when re-creating the array wi=
th a specified list of devices, which is normally the Used_Dev_Size of the =
array, divided by 2, (since the value reported by mdadm is 512 byte sectors=
).
>=20
> I am including some information from my test pod. In the case below, ther=
e are only 9 devices per array. (But all of my production conversions will =
be with 15 devices).
>=20
> So here are my questions:
> Am I correct in presuming the conversion will work and simply put-in-plac=
e an upgraded superblock?
> Also, that it is unnecessary to specify --size for the create command (in=
 this case).
> And also, that I need not worry about the version of mdadm used for the c=
onversion? (in my case it will almost exclusively be version v2.6.7.2 on De=
bian 5 , or mdadm - v3.2.5 - 18th May 2012 on Debian 7.)
> Other than reading the superblock version after the conversion, is there =
any other way of verifying the conversion was successful without causing ha=
rm?
> (my thoughts were to run FULL raid checks and filesystem checks, and some=
 crc checks to some files).
>=20
> Also, assuming I am on the right track and nothing can go wrong, are ther=
e any specific recommendations you have for going ahead with the conversion=
s? Or even a recommendation to avoid this endeavor?
>=20
> Thanks for your feedback,
>=20
> Sean Harris=20
>=20
>=20
> Example from my test machine:
>=20
> debian_version
> 5.0.10
> proc/version=20
> Linux version 2.6.32-bpo.5-amd64 (Debian 2.6.32-35~bpo50+1) (norbert@tret=
kowski.de) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #1 SMP Wed Jul 20 09:10:=
04 UTC 2011
> mdadm -V
> mdadm - v2.6.7.2 - 14th November 2008

Grab and compile the latest mdadm, and use that  to update the metadata.

NeilBrown


--Sig_/=COWGxbxocvhl_GxoLSNIyl
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVQjQnjnsnt1WYoG5AQJ/vA//QlH0tfpo2wi49Lu95yAU6r1pXDOOtF6o
VQ5VOsBANlTv/b+pS4JWSJB4yqg42TiicaBsqN4mQgIR5IsPABpE4rwzXRHMdUlg
SZkUj9f75ChIkCbAucrzdqNiOeQZ+w8tZrDrS65PpQMNAqFLMYjIlEbYGO/pxWKs
nW0euRLQ5vThinAB1yzM4FoXfSdBRFx6p0s5Zcg2B/3LGuPPRrombnOFApOtLksL
AtHY2Sku6TuQp97ad4axDoBB1nrxpp+0smofGSlUrdCf/PgjEzxEnNR+EUevNoRY
8TZLafAGGhTVLDPBNJOsdLyyrNaYjvshiiCxzVe9+h2je6G/hZEmYDZzgooid+BZ
ynClLz/hcC3zKZ9/3PWErE1KMsXpgGUXukIYoM2Q7+JsQovluCuYRs5aKXfClrvH
lVSzMAUVWYEs7UqcbbGFLtr5JQ+GY2lC96UfgQjndhJO1iyGmKsOhj4Gk6x6IdUq
UxuQ31FDIUZgGa88z//MAwqb5n4TtG2Q+9N8BPz9qz+b2oRYtz35VCKJhs/ybgwC
N/5Slc6hO6RP0OwAtFh1iGru3IisF+o0/ZOJDQpKgna9HrkqD+Gt2DUw3ihWjfZ1
ruzBN+/Tc677dVK8KlL3tchd5y/n9iXNH0lBvfibJekt+KuzbaZGbkow/HtkqtCD
UmCTPcgNXf8=
=pa2Z
-----END PGP SIGNATURE-----

--Sig_/=COWGxbxocvhl_GxoLSNIyl--
