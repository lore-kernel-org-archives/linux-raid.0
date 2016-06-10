From: NeilBrown <neilb@suse.com>
Subject: Re: Low RAID10 performance during resync
Date: Fri, 10 Jun 2016 17:08:12 +1000
Message-ID: <87k2hxmsgz.fsf@notabene.neil.brown.name>
References: <20160609134555.GA9104@proton.igk.intel.com> <20160609173118.GA17207@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160609173118.GA17207@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 10 2016, Shaohua Li wrote:

> On Thu, Jun 09, 2016 at 03:45:55PM +0200, Tomasz Majchrzak wrote:
>> A low performance of mkfs has been observed on RAID10 array during resyn=
c. It
>> is not so significant for NVMe drives but for my setup of RAID10 consist=
ing
>> of 4 SATA drives format time has increased by 200%.
>>=20
>> I have looked into the problem and I have found out it is caused by this
>> changeset:
>>=20
>> commit 09314799e4f0589e52bafcd0ca3556c60468bc0e md: remove 'go_faster' o=
ption
>> from ->sync_request()
>>=20
>> It seemed the code had been redundant and could be safely removed due to
>> barriers mechanism but it proved otherwise. The barriers don't provide e=
nough
>> throttle to resync IOs. They only assure non-resync IOs and resync IOs a=
re
>> not being executed at the same time. In result resync IOs take around 25=
% of
>> CPU time, mostly because there are many of them but only one at a time s=
o a
>> lot of CPU time is simply wasted waiting for a single IO to complete.
>>=20
>> The removed sleep call in resync IO had allowed a lot of non-resync acti=
vity
>> to be scheduled (nobody waiting for a barrier). Once sleep call had ende=
d,
>> resync IO had to wait longer to raise a barrier as all non-resync activi=
ty
>> had to be completed first. It had nicely throttled a number of resync IO=
s in
>> favour of non-resync activity. Since we lack it now, the performance has
>> dropped badly.
>>=20
>> I would like to revert the changeset. We don't have to put a resync IO to
>> sleep for a second though. I have done some testing and it seems even a =
delay
>> of 100ms is sufficient. It slows down resync IOs to the same extent as s=
leep
>> for a second - the sleep call ends sooner but the barrier cannot be rais=
ed
>> until non-resync IOs complete.
>
> Add Neil.
>
> I'd like to make sure I understand the situation. With the change reverte=
d, we
> dispatch a lot of normal IO and then do a resync IO. Without it reverted,=
 we
> dispatch few normal IO and then do a resync IO. In other words, we don't =
batch
> normal IO currently. Is this what you say?
>
> Agree the barrier doesn't throttle resync IOs, it only assures normal IO =
and
> resync IO run in different time.

I think the barrier mechanism will mostly let large batches of IO
through as a match.  If there is a pending request, a new request will
always be let straight through.  Resync needs to wait for all pending
regular IO to complete before it gets a turn.

So I would only expect that patch to cause problems when IO is very
synchronous: write, wait, write, wait, etc.

I really didn't like the "go_faster" mechanism, but it might be OK to
have something like
  if (conf->nr_waiting)
      schedule_timeout_uninterruptible(1);

so it will wait one jiffie if there is normal IO.  This would batch this
a lot more.

It is very hard to know the exact consequences of this sort of change on
all different configurations, and the other commit you mentioned shows.

I keep thinking there must be a better way, but I haven't found it yet
:-(

NeilBrown


>
> On the other hand, the change makes resync faster. Did you try to revert =
this one:
> ac8fa4196d205ac8fff3f8932bddbad4f16e4110
> If resync is fast, reverting this one will throttle resync.
>
> Thanks,
> Shaohua

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXWmdcAAoJEDnsnt1WYoG5EqsQAJhHBAclLMEUZBZ1oH/Aj0Cl
GzREVkg5s7R3HIsKHf1WpqS7MvsrV2FF4zNEKES9wWqhNS3iuHe5JsUBZdHG5aMj
eowhR+5h1b/7Up72TBqNRUpjVbUIg4hl67MNisPSv7BrQtb+YXVEdRH4cEA05+hf
eB+IvUL/81YIdaeO7b8ZUGpGUHtOeqBPKVeoAHvMEl1aA8b0+3qsGzrCsNNjOX+F
X2JBKLdEkGhNp5CKdrlDpEvscDf7QejrWcV97ybLahPapZI00pdPAeeS5gZsG48V
eP317FiTVY7Y2bpVioJbWGtaSxKJPb2qIs25ayOD30JweFvqqULpfY/0xNMR2R0W
UWpb3+QG8hyRqgjCBiQ95PDbJ65Jq2x0NtRl7tY9FtLAMrxk/W/+OmbWr+wtpuW7
vW1R62PPxLaSk/JEDPV4v0ntiLrME6m+2FvbGaavrV/Zuza2mzyQASnt+Gbz3jZ4
A+u1pMPIG4o9bW10zm/dJZGRf+l2m2gKnya781RzWkyP6fpBsi0OFMydRO+cT5I4
oMS/e852cIwu1KsClw3xW9X8GnLxd/J+Em4e1vR2jRVK5LJtXEBC8hTDJYwgqBgf
QLi9i/0182XmukIp+PQPKDrpwA6B+yI/yis0HyxsF2DNa7+Wugl/qzNw9lz4u9H+
neO9oY0E4dUi3BHX4RRX
=7YtV
-----END PGP SIGNATURE-----
--=-=-=--
