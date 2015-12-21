From: NeilBrown <neilb@suse.de>
Subject: Re: clustered MD - beyond RAID1
Date: Tue, 22 Dec 2015 10:09:16 +1100
Message-ID: <87zix32ycj.fsf@notabene.neil.brown.name>
References: <56742652.5040304@nasa.gov> <87si2w66tm.fsf@notabene.neil.brown.name> <567850C4.30108@bnl.gov> <87bn9j4jhr.fsf@notabene.neil.brown.name> <56786EA4.2020209@bnl.gov> <8737uv4fz6.fsf@notabene.neil.brown.name> <56787D34.7020108@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56787D34.7020108@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, Tejas Rao <raot@bnl.gov>, Scott Sinno <scott.sinno@nasa.gov>, linux-raid@vger.kernel.org
Cc: "Knister, Aaron S. (GSFC-606.2)[COMPUTER SCIENCE CORP]" <aaron.s.knister@nasa.gov>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 22 2015, Adam Goryachev wrote:

> On 22/12/15 09:03, NeilBrown wrote:
>> On Tue, Dec 22 2015, Tejas Rao wrote:
>>
>>> On 12/21/2015 15:47, NeilBrown wrote:
>>>> On Tue, Dec 22 2015, Tejas Rao wrote:
>>>>
>>>>> What if the application is doing the locking and making sure that onl=
y 1
>>>>> node writes to a md device at a time? Will this work? How are rebuilds
>>>>> handled? This would be helpful with distributed filesystems like
>>>>> GPFS/lustre etc.
>>>>>
>>>> You would also need to make sure that the filesystem only wrote from a
>>>> single node at a time (or access the block device directly).  I doubt
>>>> GPFS/lustre make any promise like that, but I'm happy to be educated.
>>>>
>>>> rebuilds are handled by using a cluster-wide lock to block all writes =
to
>>>> a range of addresses while those stripes are repaired.
>>>>
>>>> NeilBrown
>
> My understanding of MD level cross host RAID was that it would not=20
> magically create cluster aware filesystems out of non-cluster aware=20
> filesystems. ie, you wouldn't be able to use the same multi-host RAID=20
> device on multiple hosts concurrently with ext3.

This is correct.  The expectation is that clustered md/raid1 would be
used with a cluster-aware filesystem such as ocfs2 or gpfs.  Certainly
not with ext3 or similar.

>
> IMHO, if it was able to behave similar to DRBD, then that would be=20
> perfect (ie, enforce only a single node can write at a time (unless you=20
> specifically set it for multi-node write)). The benefit should be that=20
> you can lose a node without losing your data. After you lose that node,=20
> you can then "do something" to use the remaining node to access the data=
=20
> (eg, mount it, export with iscsi/nfs, etc).

There is a lot of similarity between DRBD and clustered md/raid1.
I don't know the current state of DRBD but it initially assumed each
storage device was local to a single node and so sent data over the
network (i.e. over IP) to "remote" devices.

clustered md/raid1 assumes that all storage is equally accessible to all
nodes (over a 'storage area network', which may still be IP).

So yes: if you lose a node you should not lose functionality.

>
> Currently, this is what I use DRBD for, previously, I've used NBD + MD=20
> RAID1 to do the same thing. One question though is what advantage=20
> multi-host MD RAID might have over the existing in-kernel DRBD ? Are=20
> there plans which show why this is going to be better, have better=20
> performance, features, etc?

I'm not the driving force behind clustered md/raid1 so I am not
completely familiar with the motivation, but I believe DRBD doesn't, or
didn't, make best possible use of the storage network when every storage
device is connected to every compute node.  It is expected that clustered
md/raid1 will.

I *think* DRBD is primarily for pair of nodes (though there is some
multi-node support).  clustered md/raid1 is designed to work with
multiple nodes - however big your cluster is.
(DRBD 9.0 appears to support multi-node configurations.  I haven't
researched the details)

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWeIacAAoJEDnsnt1WYoG5kXAP+QFOVSfbcbBUsHxlxqgR+dAX
V6YqCsRDwTKtPE2Yqu+zw0BaSLjvCu4Rqd3x5Njuhr0OgTEkzGa4AD/CEmeVuAvk
v8dRLRjXaaxOg8UmLsTMBjsyMYiuZKrI0gXzZPTCGF/OT4ir+g43TRHlP8ZT6gBF
QICGIKqDMS5vSj5JCjmAPf52y2VSvBV+mxLn+ZMbfMEMWnl1atkdjjpqzayby+LG
N8xzs9LoV82+ni4rU1vyF/+QKFSzq3pEuryOB1UoY2Eo1h2Z21Yzl9LYRC9qb2Hf
vm/IM7SWkINoaJ4rTucEFIEtWn9xIDTQG6OWQdApDNFAInCQVPkP13hiV3LZcnR5
KEdqy5PiuTp3UuixqhceVQ+4JjvsZ4DiTTV6lpyQjwZ9SR7yMllq4L+6/h+sYz+z
VD+J+79WHkTAfPGjNvJliqhDw58BjH+NLvndiPut6A38zl5Ls39r2FkdOLKgggTj
C477tmGHsM70RFWVBn1ahgNkLgKghJw3LzHcllgAOIDZY+dZh5r2VuVNdHNA+NnD
KuW6MTxIek9CWQkmav439+LJISTvQPAtLNRt72oFSZKZFUUOPBtLA6ewnhnKuPnx
Odr0mvbforoMLIj3aiTAL/4PHexs+gS3zqYhhwvk1mU7jIz87l+1T6F8GO84f38V
lz3ALx6rB91hD1jdTvmA
=L9GF
-----END PGP SIGNATURE-----
--=-=-=--
