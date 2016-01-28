From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH/RFC/RFT] md: allow resync to go faster when there is competing IO.
Date: Thu, 28 Jan 2016 14:10:38 +1100
Message-ID: <87wpqu1jrl.fsf@notabene.neil.brown.name>
References: <CAByoP04f6YgzhXn+55iEpg0SrVnK3mUxOuEfp-Hki_mppOBieg@mail.gmail.com> <87si1k2do8.fsf@notabene.neil.brown.name> <CAByoP04se9yQv_u1Kc1pXk5shtzT_udTB4v4HYaJRfc0Eh1RqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAByoP04se9yQv_u1Kc1pXk5shtzT_udTB4v4HYaJRfc0Eh1RqA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chien Lee <chienlee@qnap.com>, linux-raid@vger.kernel.org, shli@kernel.org, owner-linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Jan 27 2016, Chien Lee wrote:

> 2016-01-27 6:12 GMT+08:00 NeilBrown <neilb@suse.com>:
>> On Tue, Jan 26 2016, Chien Lee wrote:
>>
>>> Hello,
>>>
>>> Recently we find a bug about this patch (commit No. is
>>> ac8fa4196d205ac8fff3f8932bddbad4f16e4110 ).
>>>
>>> We know that this patch committed after Linux kernel 4.1.x is intended
>>> to allowing resync to go faster when there is competing IO. However,
>>> we find the performance of random read on syncing Raid6 will come up
>>> with a huge drop in this case. The following is our testing detail.
>>>
>>> The OS what we choose in our test is CentOS Linux release 7.1.1503
>>> (Core) and the kernel image will be replaced for testing. In our
>>> testing result, the 4K random read performance on syncing raid6 in
>>> Kernel 4.2.8 is much lower than in Kernel 3.19.8. In order to find out
>>> the root cause, we try to rollback this patch in Kernel 4.2.8, and we
>>> find the 4K random read performance on syncing Raid6 will be improved
>>> and go back to as what it should be in Kernel 3.19.8.
>>>
>>> Nevertheless, it seems that it will not affect some other read/write
>>> patterns. In our testing result, the 1M sequential read/write, 4K
>>> random write performance in Kernel 4.2.8 is performed almost the same
>>> as in Kernel 3.19.8.
>>>
>>> It seems that although this patch increases the resync speed, the
>>> logic of !is_mddev_idle() cause the sync request wait too short and
>>> reduce the chance for raid5d to handle the random read I/O.
>>
>> This has been raised before.
>> Can you please try the patch at the end of
>>
>>   http://permalink.gmane.org/gmane.linux.raid/51002
>>
>> and let me know if it makes any difference.  If it isn't sufficient I
>> will explore further.
>>
>> Thanks,
>> NeilBrown
>
>
> Hello Neil,
>
> I try the patch (http://permalink.gmane.org/gmane.linux.raid/51002) in
> Kernel 4.2.8. Here are the test results:
>
>
> Part I. SSD (4 x 240GB Intel SSD create Raid6(syncing))
>
> a.  4K Random Read, numjobs=64
>
>                                    Average Throughput    Average IOPS
>
> Kernel 4.2.8 Patch             601249KB/s              150312
>
>
> b.  4K Random Read, numjobs=1
>
>                                    Average Throughput    Average IOPS
>
> Kernel 4.2.8 Patch             1166.4KB/s                  291
>
>
>
> Part II. HDD (4 x 1TB TOSHIBA HDD create Raid6(syncing))
>
> a.  4K Random Read, numjobs=64
>
>                                    Average Throughput    Average IOPS
>
> Kernel 4.2.8 Patch              2946.4KB/s                 736
>
>
> b.  4K Random Read, numjobs=1
>
>                                    Average Throughput    Average IOPS
>
> Kernel 4.2.8 Patch              119199 B/s                   28
>
>
> Although the performance that compare to the original Kernel 4.2.8
> test results is increased, the patch
> (http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=ac8fa4196d205ac8fff3f8932bddbad4f16e4110)
> rollback still has the best performance. I also observe the sync speed
> at numjobs=64 almost drop to the sync_speed_min, but sync speed at
> numjobs=1 almost keep in the original speed.
>
>>From my test results, I think this patch isn't sufficient that maybe
> Neil can explore further and give me some advice.
>
>
> Thanks,
> Chien Lee
>
>
>>>
>>>
>>> Following is our test environment and some testing results:
>>>
>>>
>>> OS: CentOS Linux release 7.1.1503 (Core)
>>>
>>> CPU: Intel(R) Xeon(R) CPU E3-1245 v3 @ 3.40GHz
>>>
>>> Processor number: 8
>>>
>>> Memory: 12GB
>>>
>>> fio command:
>>>
>>> 1.      (for numjobs=64):
>>>
>>> fio --filename=/dev/md2 --sync=0 --direct=0 --rw=randread --bs=4K
>>> --runtime=180 --size=50G --name=test-read --ioengine=libaio
>>> --numjobs=64 --iodepth=1 --group_reporting
>>>
>>> 2.      (for numjobs=1):
>>>
>>> fio --filename=/dev/md2 --sync=0 --direct=0 --rw=randread --bs=4K
>>> --runtime=180 --size=50G --name=test-read --ioengine=libaio
>>> --numjobs=1 --iodepth=1 --group_reporting
>>>
>>>
>>>
>>> Here are test results:
>>>
>>>
>>> Part I. SSD (4 x 240GB Intel SSD create Raid6(syncing))
>>>
>>>
>>> a.      4K Random Read, numjobs=64
>>>
>>>                                              Average Throughput    Average IOPS
>>>
>>> Kernel 3.19.8                                 715937KB/s              178984
>>>
>>> Kernel 4.2.8                                   489874KB/s              122462
>>>
>>> Kernel 4.2.8 Patch Rollback            717377KB/s              179344
>>>
>>>
>>>
>>> b.      4K Random Read, numjobs=1
>>>
>>>                                              Average Throughput    Average IOPS
>>>
>>> Kernel 3.19.8                                 32203KB/s                8051
>>>
>>> Kernel 4.2.8                                  2535.7KB/s                633
>>>
>>> Kernel 4.2.8 Patch Rollback            31861KB/s                7965
>>>
>>>
>>>
>>>
>>> Part II. HDD (4 x 1TB TOSHIBA HDD create Raid6(syncing))
>>>
>>>
>>> a.      4K Random Read, numjobs=64
>>>
>>>                                              Average Throughput    Average IOPS
>>>
>>> Kernel 3.19.8                                2976.6KB/s               744
>>>
>>> Kernel 4.2.8                                  2915.8KB/s               728
>>>
>>> Kernel 4.2.8 Patch Rollback           2973.3KB/s               743
>>>
>>>
>>>
>>> b.      4K Random Read, numjobs=1
>>>
>>>                                              Average Throughput    Average IOPS
>>>
>>> Kernel 3.19.8                                481844 B/s                 117
>>>
>>> Kernel 4.2.8                                   24718 B/s                   5
>>>
>>> Kernel 4.2.8 Patch Rollback           460090 B/s                 112
>>>
>>>
>>>
>>> Thanks,
>>>
>>> --
>>>
>>> Chien Lee

Thanks for testing.

I'd like to suggest that these results are fairly reasonable for the
numjobs=64 case.  Certainly read-speed is reduced by presumably resync
speed is increased.
The numbers for numjob=1 are appalling though.  That would generally
affect any synchronous load.  As the synchronous load doesn't interfere
much with the resync load, the delays that are inserted won't be very
long.

I feel there must be an answer here -  I just cannot find it.
I'd like to be able to dynamically estimate the bandwidth of the array
and use (say) 10% of that, but I cannot think of a way to do that at all
reliably.

I'll ponder it a bit longer.  We may need to ultimately revert that
patch, but not yet.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWqYauAAoJEDnsnt1WYoG5aJ0QAJ6Eu3ifw2KCaF0mbZxNDOwv
WvDHAh+d+hbtFyFPU2EdaR55yJYt43UL3hOSB/3ih1NdrJqg/GnExQTMnrS43TOq
bKkjPPcmuCdH7RSnCOiD3GZM5Pu0WKRk2Y1/5eFWagOwxXqiaqHbkOGefhY0qv3y
dU6oWZpk19PlS+d/Y9bVI2/n+S/XMy5PXETPGpqJDz/e8agtWRZOwPbSSCbAav+8
288xgRjvCodE9wJ4Gb9ozIWfqTQJQ8MUrl4KvlS0Txa9z16/cZ7piV5iA8VSc3ZV
Qs+oiCs9TRVv+BCry8e+cV4pQoMdybatWUS1S4UKslrUd6MpBRIkG2Y4M+RVV9gn
kgaw41QzSZruXoK4OYue3NGX9RgAP3FaQ+wz4JH5ragbL42VjwWcakjlQkTScUJo
NYKFPIVW4vwFNM03BavKiPBTEQJ9aT7Pbc+APpUwN4ttVGRHYy6U8CIwP6CK4Iz4
YAHEBoZuZjhj1ogLOFCwOnFUusbb1pWrbL77eivAC28t3mOzR08c3wqRI2hRCTUA
ckuEqptKovXh8S32VsWX0L0zUbUeL0LsJvOFmFTZf8ZYvvJPo5w9N0w2ZagU18bk
0xXM2zjY+dMJzO4qXBET+DJwbRO50T+RKt+7AjrrzbAOzVa4r1X0P9Loyo5PMAPG
y02+t7lyQCTvDudCybEl
=oqGz
-----END PGP SIGNATURE-----
--=-=-=--
