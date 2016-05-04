From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 0/2] Check node nums for cluster raid
Date: Wed, 4 May 2016 11:28:41 -0400
Message-ID: <5bd3cf09-8951-3b66-38b3-eb1a9fa29078@redhat.com>
References: <1462350824-9872-1-git-send-email-gqjiang@suse.com>
 <wrfjinytx3fv.fsf@redhat.com>
 <305eaf9b-1275-f9b9-dae4-1be8f21ed98c@redhat.com>
 <wrfjy47pvoab.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wVncxFstwdBHvHxlLfsdVP3G7Tl1xGDbo"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjy47pvoab.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@redhat.com>
Cc: Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wVncxFstwdBHvHxlLfsdVP3G7Tl1xGDbo
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/04/2016 11:25 AM, Jes Sorensen wrote:
> Doug Ledford <dledford@redhat.com> writes:
>> On 05/04/2016 11:12 AM, Jes Sorensen wrote:
>>> Guoqing Jiang <gqjiang@suse.com> writes:
>>>> For cluster raid, we do need at least two nodes for it,
>>>> the two patches add the checks before create and change
>>>> bitmap.
>>>>
>>>> Thanks,
>>>> Guoqing   =20
>>>>
>>>> Guoqing Jiang (2):
>>>>   Create: check the node nums when create clustered raid
>>>>   super1: don't update node nums if it is not more than 1
>>>>
>>>>  Create.c | 7 ++++++-
>>>>  super1.c | 5 +++++
>>>>  2 files changed, 11 insertions(+), 1 deletion(-)
>>>
>>> Hi Guoqing,
>>>
>>> I am a little confused on this one - albeit I haven't looked at it in=

>>> detail. Why should it not be possible to start a cluster with one nod=
e?
>>> In theory you should be able to do that, and then add nodes later?
>>
>> Not typically.  A single node of a cluster is likely the odd man out, =
so
>> starting it and allowing changes to the underlying device has a high
>> potential of creating split brain issues.  For that reason, most clust=
er
>> setups require some minimum (usually 2) for a quorum before they will
>> start.  Otherwise, given a three node cluster, you could end up with
>> three separate live filesystems and the need to merge changes between
>> them to bring the cluster back into sync.
>=20
> Valid point, but it still looks like a duplicate of the classic raid1
> situation. We still allow the creation of a raid1 with just one drive,
> would it not make more sense to spit out a warning here, rather than
> deny it?

Local raid1 is a little different in that if both members of a raid1 are
supposed to be present on the same machine, and that machine only sees
one of the disks, we take it on faith that the other one isn't running
around live in another machine.  If it is, we can end up corrupting our
array (we rely on the events counter on one disk superseding the other
disk to know which disk is the master copy and which one needs to be
refreshed, if both disks are brought up the same number of times without
each other, then their event counters will be the same and we won't know
which one should be master).  With a clustered MD filesystem, that
assumption isn't true, and so starting a device without a quorum carries
a much higher risk.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--wVncxFstwdBHvHxlLfsdVP3G7Tl1xGDbo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXKhUpAAoJELgmozMOVy/df0gP/0UZVPJdbCnuBqrmNvK8Y7xj
1nDva8tmlcUfEFoIKf3FbBkqabB0ky4qIPCwNQhWro4Ec/oQiGiXzFvWrN57wd+Y
wiFUEo5UksdvdT2KXF7ykb2R7AoNdjOy4ICvv7zJufiVLpL2gvjb7kBimWhSQRFO
9AtQRIlHT6wmQxK+VFU2Q0OCOFzJhY00Fqpc3THzXJG7xEHH+9LwUYYSOZf9HW9m
IZ85TP6e0fuhSiGCo2Y8uG41hU62snII5FgIBdymApdXrXZ981VYS+BxeRHHbmPN
mv2yMNUyvSTNw9taFkRBfHOLiJU1b4Lkw1GiUwa0QtgkbQnC6GQ3l0KNzOvFarkS
rTZ5uZvGWVmjTHrj/IXB7uyb0CuVT5S1fkIUpq1Vlgvu9mWNiGkFu4NW7zAdfoZd
EzPrinhCFkXLv5rmizWZ8uKgPMD1EXOnPYHn8NbKp258qux3yuHZ+8giXeHQqv0U
YzvtYDO+i1Y1ORtysZn1qdBMDhYEsxLnqDZZvi2LMAITs9JR2zioEciGFs8H3Xg+
i9J8HaO3czmERbk4qCdU6/54XAS6LwzhJFEkIA2fl2WAuOdi2bHeHnXkguIPZ6wN
J5i5p1C3DVOKYNo86dmB85NXcitaL0NKYULc39u0SqVmHJYT1cNEVJfJxUsODOTX
6fQgB/PtIYwHwMDYHc+P
=RsHt
-----END PGP SIGNATURE-----

--wVncxFstwdBHvHxlLfsdVP3G7Tl1xGDbo--
