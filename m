From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 2/2] mdadm: raid10.c Remove near atomic break
Date: Mon, 07 Nov 2016 10:03:42 +1100
Message-ID: <87oa1snrch.fsf@notabene.neil.brown.name>
References: <20161103234508.12641-1-robert@leblancnet.us> <20161103234508.12641-3-robert@leblancnet.us> <87k2cjq4eh.fsf@notabene.neil.brown.name> <CAANLjFrXjS3HX-qv_FAXBapD6PE-n+y=d=6kzCwO3pSjajafWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAANLjFrXjS3HX-qv_FAXBapD6PE-n+y=d=6kzCwO3pSjajafWQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert LeBlanc <robert@leblancnet.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Fri, Nov 04 2016, Robert LeBlanc wrote:

> On Thu, Nov 3, 2016 at 10:01 PM, NeilBrown <neilb@suse.com> wrote:
>> On Fri, Nov 04 2016, Robert LeBlanc wrote:
>>
>>> This is always triggered for small reads preventing spreading the reads
>>> across all available drives. The comments are also confusing as it is
>>> supposed to apply only to 'far' layouts, but really only applies to 'near'
>>> layouts. Since there isn't problems with 'far' layouts, there shouldn't
>>> be a problem for 'near' layouts either. This change fairly distributes
>>> reads across all drives where before only came from the first drive.
>>
>> Why is "fairness" an issue?
>> The current code will use a device if it finds that it is completely
>> idle. i.e. if nr_pending is 0.
>> Why is that ever the wrong thing to do?
>
> The code also looks for a drive that is closest to the requested
> sector which doesn't get a chance to happen without this patch. The
> way this part of code is written, as soon as it finds a good disk, it
> cuts out of the loop searching for a better disk. So it doesn't even
> look for another disk. In a healthy array with array-disks X and -p
> nX, this means that the first disk gets all the reads for small I/O.
> Where nY is less than X, it may be covered up because the data is
> naturally striped, but it still may be picking a disk that is farther
> away from the selected sector causing extra head seeks.
>
>> Does your testing show that overall performance is improved?  If so,
>> that would certainly be useful.
>> But it isn't clear (to me) that simply spreading the load more "fairly"
>> is a worthy goal.
>
> I'll see if I have some mechanical drives somewhere to test (I've been
> testing four loopback devices on a single NVME drive so you don't see
> an improvement). You can see from the fio I posted [1] that before the
> patch, one drive had all the I/O and after the patch the I/O was
> distributed between all the drives (it doesn't have to be exactly
> even, just not as skewed as it was before is good enough). I would
> expect similar results to the 'far' tests done here [0]. Based on the
> previous tests I did, when I saw this code, it just made complete
> sense to me why we had great performance with 'far' and subpar
> performance with 'near'. I'll come back with some results tomorrow.

The whole point of the "far" layout is to provide better read
performance than "near" because reads get spread out over all devices
like they do with RAID0.  So I wouldn't expect the make "near" close to
"far", but it certainly doesn't hurt to improve it.

As Shaohua notes, we you two different algorithms in RAID1, depending on
whether there are rotational devices or not.  Introducing similar logic
to RAID10 would seem to make sense.

Patches for performance improvements are always more convincing when
they come with numbers.  I'll look forward to your test results.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYH7bOAAoJEDnsnt1WYoG5Z/0QALImY3SW7j80rxmroH42eS6d
1rq0BPp7zt64wcK/czQZ31hjdMp4xl4QNyN76Qe3csK0N4BAlmElKuWpOSBE9HvT
qD4Ca7nkDqR9TqO2VHrSF+oqzcSLMn32/XbmadmnqTOoFIcRIfKQLlLOK9bTyaUz
59EJ8IzBFr9PJ5RsbSNdTMkPCTvKI/e+4sUJPhoC5S8k6NxWfuBNpYTOo+mSw+sP
z/e1h2ydd/vfux0rpP3hXQpRF75PTff7fKj6/nbWiESpIyfitkiyqmSGpzZmqTUC
Qjf0srRbTKDp9XiJqFmsHelA+K331khij4wjmEIEg9KiONnxkcVGPhKgmy8n/uHp
y067sHtuDnnlFyhpSy/pgsPb3yAVIxf1m3MJsMH6dR7JkY6vrYhaPbZfe5D9cHqC
xxT+rmsiwr3CicBNX3vfV2dOy8XGnhJ1r+e5Y7a7h1eM6fyrqamUXgwYPRxHnNTl
ZsHzjaTR0FTHBIZlG9pAMaY0M8q0ngkNh2eJaMNzT7mspTpEjqm4JGvSGbf2/qto
k8nKxkiDwcAfEHYzQ123BUmP2Gq35WH+F70omCBQsGSnmxi9nGW5fgvmaio6cuLy
LQWrqMIulv31S1nPCiykcZVC20l8xyj2l/XNut5oTd37i5jleI5ezwXr6PnwY3xl
UoMxEFwC7G0oC8LzLc9l
=PKcp
-----END PGP SIGNATURE-----
--=-=-=--
