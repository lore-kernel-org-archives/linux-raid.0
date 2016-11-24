From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH/RFC] add "failfast" support for raid1/raid10.
Date: Thu, 24 Nov 2016 15:47:19 +1100
Message-ID: <877f7tbi20.fsf@notabene.neil.brown.name>
References: <147944614789.3302.1959091446949640579.stgit@noble> <CA+res+TZD2Lx4CaGPx6SjTc6VKGLUc=qyYBgi15oSYU1bBuHew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CA+res+TZD2Lx4CaGPx6SjTc6VKGLUc=qyYBgi15oSYU1bBuHew@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Jack Wang <jack.wang.usish@gmail.com>
Cc: Shaohua Li <shli@kernel.org>, linux-raid <linux-raid@vger.kernel.org>, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, hare@suse.de
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Sat, Nov 19 2016, Jack Wang wrote:

> 2016-11-18 6:16 GMT+01:00 NeilBrown <neilb@suse.com>:
>> Hi,
>>
>>  I've been sitting on these patches for a while because although they
>>  solve a real problem, it is a fairly limited use-case, and I don't
>>  really like some of the details.
>>
>>  So I'm posting them as RFC in the hope that a different perspective
>>  might help me like them better, or find a better approach.
>>
>>  The core idea is that when you have multiple copies of data
>>  (i.e. mirrored drives) it doesn't make sense to wait for a read from
>>  a drive that seems to be having problems.  It will probably be faster
>>  to just cancel that read, and read from the other device.
>>  Similarly, in some circumstances, it might be better to fail a drive
>>  that is being slow to respond to writes, rather than cause all writes
>>  to be very slow.
>>
>>  The particular context where this comes up is when mirroring across
>>  storage arrays, where the storage arrays can temporarily take an
>>  unusually long time to respond to requests (firmware updates have
>>  been mentioned).  As the array will have redundancy internally, there
>>  is little risk to the data.  The mirrored pair is really only for
>>  disaster recovery, and it is deemed better to lose the last few
>>  minutes of updates in the case of a serious disaster, rather than
>>  occasionally having latency issues because one array needs to do some
>>  maintenance for a few minutes.  The particular storage arrays in
>>  question are DASD devices which are part of the s390 ecosystem.
>
> Hi Neil,
>
> Thanks for pushing this feature also to mainline.
> We at Profitbricks use raid1 across IB network, one pserver with
> raid1, both legs on 2 remote storages.
> We've noticed if one remote storage crash , and raid1 still keep
> sending IO to the faulty leg, even after 5 minutes,
> md still redirect I/Os, and md refuse to remove active disks, eg:

That make sense.  It cannot remove the active disk until all pending IO
completes, either with an error or with success.

If the target has a long timeout, that can delay progress a lot.

>
> I tried to port you patch from SLES[1], with the patchset, it reduce
> the time to ~30 seconds.
>
> I'm happy to see this feature upstream :)
> I will test again this new patchset.

Thanks for your confirmation that this is more generally useful than I
thought, and I'm always happy to hear for more testing :-)

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYNnDXAAoJEDnsnt1WYoG5E/4QAIRxnBr6au9ODATaMp5M6F+9
czYA/Stz/qVG3FYRUBS1CZG/HbEdP0RjxznUPOQpFvq8RvwcX3wXmDPtm4T0Joeo
KSIVi55N4Ctn8ONqLuGXuHyuCYI7OijMmBIUV6fIPYjRq4J5Hk9qwdwPUs2UVtbk
jKC7HMM6GqHmU3mWdIF+ApT8o+RusDemI3eWw8IfcZjDblHdPNutzPh9dKUbD8M6
P+CWipt6CbANnoiH/5guQvWddz29ALGRgTMk5+SmbnbunigURLzuLySkAgFsoIfm
s77TM0OR9PMEp5Fz09S3JJaiOatgXT4qJDVoBhZQ3CzCJwY3XJjm4XcKOnscbqdj
tRWTidiMhor+212XuWfTpTGx9zIsdEcgrFRguSaK24tq69T+VE5QZCi9OO9tYd7X
jW+qfY+BgEpzNvlqsMSrwIFGtw4/Skb+ZPTXyLEqu7s97uCSMCArsBtmGW00HHur
dILrEzWe/KpZMP1wM7t54sdKm+7k+LiO0qde8JLLbB/cAPX/v+DToYFaxvNrT3mE
CntHN+Jr5oEO8xNd2uLcel2CAeHEjpeXdTpM2vusHNFgogL/q68NTjjxD1YUM6C/
uDQjfItK/vuNkt1atEfLouOIhsOer9i+tyy66TEkc4+OhALPsnurtMF6fXjzDmfJ
6BL+gjhNAKEYiPXCPF7X
=8h/M
-----END PGP SIGNATURE-----
--=-=-=--
