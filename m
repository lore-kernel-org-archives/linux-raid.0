From: NeilBrown <nfbrown@novell.com>
Subject: Re: mdadm bad blocks list
Date: Thu, 28 Jan 2016 15:45:37 +1100
Message-ID: <87r3h21fda.fsf@notabene.neil.brown.name>
References: <56A9102D.4030304@prgmr.com> <87twly1jc7.fsf@notabene.neil.brown.name> <56A99118.2080508@prgmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56A99118.2080508@prgmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sarah Newman <srn@prgmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 28 2016, Sarah Newman wrote:

> On 01/27/2016 07:19 PM, NeilBrown wrote:
>> On Thu, Jan 28 2016, Sarah Newman wrote:
>>=20
>>> I experienced the following problems with the mdadm bad blocks list:
>>>
>>> 1. Additions to the bad block list do not cause an email to be sent by =
the mdadm monitor. Expected behavior is for an email to be sent as soon as =
the
>>> bad blocks list becomes non-empty.
>>=20
>> Yes, that would be a good idea.  If you do develop patches, please post
>> them.
>
> Will do, but I don't have a definite time frame for it.
>
>>=20
>>> 2. /proc/mdstat does not show any indication that there are bad blocks =
present on an md member. Specifically, the status for the raid personality
>>> should show something other than "U" if the badblocks list is not empty=
 for that member (maybe "B"?)
>>=20
>> I'd like to deprecate /proc/mdstat.  It is not really easy to extend.
>> People might have programs that parse it which could break if you change
>> 'U' to 'B'.
>> I'd recommend using "mdadm" to get status of an array, or examine file
>> in /sys.
>
> If /proc/mdstat isn't going to be updated, is it going to be removed? If =
not and changing 'U' to 'B' isn't acceptable, then what about adding a flag
> to the device? Example

Removing is not better than changing.  Legacy is a problem...

>
> md0 : active raid1 sda1[1] sdb1[2](B)

That might be acceptable.  There is precedent for that sort of change.

>
> Where is the bad blocks list in /sys?

 /sys/block/mdXXX/md/dev-YYY/bad_blocks


>
>>=20
>>> 3. Adding a device when there is an md member with bad blocks does not =
appear to trigger a rebuild, meaning there could be at least one good copy =
of
>>> all the data but no way to get all good data on a single device without=
 expanding the entire array.
>>=20
>> Good point.  That would be quite easy to change.  Just set
>> WantReplacement if the bad block list is ever empty.
>> Not sure it is always a good idea though.  You can have a bad block on a
>> perfectly good device if the device it was recovered from has a bad
>> block.
>> You only really want to set WantReplacement automatically if a write
>> fails.  We do do that, but if you stop and restart an array the fact
>> that a write failed can be forgotten.
>
> Yes, I am quite aware there can be a bad block on a perfectly good device=
. But in a mirror if there are multiple perfectly good devices that each ha=
ve
> bad blocks marked for whatever reason, the only way to get back to a sing=
le good device is to rebuild off of all of them. Speaking as a user, this is
> what I would want to happen.

Performing a "check" - e.g.
   echo check > /sys/block/mdXXX/md/sync_action

should do that.  I'm not certain that it does but it is an avenue worth
exploring and possibly fixing.
Running "check" on a regular basis is something everyone should do
(there is a script in mdadm to help with this).

>
>> I'm not convinced that it is harmful, though I accept that it is not per=
fect.
>
> Yes. You both know the current behavior of mdadm perfectly and probably d=
idn't just experience data loss.

Fair comment.

>
> The old behavior was to fail immediately and alert if there was a problem=
 rather than silently accepting errors. I expect there are some people who
> think they have a good RAID, but don't, based on /proc/mdstat and lack of=
 errors from mdadm monitor.
>
> Thanks, Sarah

Getting feed back like this is an important part of making MD better!
I'm unlikely to be coding any changes myself in the immediate future
but I'm very happy to discuss them.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWqZzxAAoJEDnsnt1WYoG5H5QQAMMNHdMspIfcnC3GHXWanw2n
DDpqWLLH26P3qw0lrTcnyLvzNrsvmQkQc4jqr2aecQzK5taIYgqR3xh/+GmFrMLD
K1l0k7xsdW2C2TszDfdpT06mNvANLN3kKry2lEVh0fhPfl054fAnhDKN6hJ1bs85
Pgpa01eW6QSAm/oo2aPKZgkOQE773I8xxK5ETyjUIMrKYdL5tdGkRBuQfZj2yucq
FMG4VHOv8oOoDg4DjNyQ3YDNSL7UtGOlsNg++31Pnw+aMuG2kYL5VZClVMk2hjSQ
VU5XeeLZ3CqI4XVoyEMNqD9mPpy/HJ0So7Dr3K9QRRYVcnRK008ryJXoCbBSFdDz
dzTR5MEmjtZDO6Ku0BpDqLz63p8ejoce6PnrF9Xdo5C0IIsYtFM/NjuVU8aRzBFf
JmurS7tyxAsmUFk/MiNoc5W9M/ik2nmw/tqrHdtPnJeGiKG6QvJ2xveyc2AuPdAN
n0UssP6NKq93rIzuCkc09kW0itQ1fSX0/MlO6LlJlBl37GG4jqiYJeEf+eg1siCs
CpSC10awS3wHTnrtdMSQsUHmbvMSDJH7k0uAmH5nIlxh94mfBihtTLshxy04+kIo
sqdtF7dQdiwjyQ4h5BPWOjJXLThIcwrw6nvV3ErQayK9kcZQC2C5wJMb2lZiNQr4
sOE9SrT3xUcZZ0i7kq7C
=5Dpi
-----END PGP SIGNATURE-----
--=-=-=--
