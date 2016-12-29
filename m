From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Intel SSD or other brands
Date: Fri, 30 Dec 2016 01:35:39 +1100
Message-ID: <8c0e48b3-e224-1e0e-13fe-987a58411e06@websitemanagers.com.au>
References: <0329d841-984b-fa25-0bf2-0aba4d55b6de@websitemanagers.com.au>
 <22628.62979.46926.463323@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22628.62979.46926.463323@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.UK>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 29/12/16 22:39, Peter Grandi wrote:
>> [ ... ] I now found out that performance of a 520s SSD is
>> around 180 times faster than a 530s SSD. [ ... ]
> Well "performance" can be roughly the same, even if "speed" can
> be very different.
>
> http://www.sabi.co.uk/blog/15-two.html#151023
I'm not entirely sure what you mean to say here, I have a reasonably 
well defined real life workload, (ie, single threaded, small random 
writes)... I am measuring the same statistics across multiple devices 
and comparing those numbers.
In addition, replacing the devices with others that showed an 
improvement (measured during testing) in the real life system showed an 
equivalent improvement (reduction) in end user complaints. So I feel 
reasonably sure that I am "on the right track"....

Am I overlooking something else (very possible)?
>> 520s: 70MB/s
>> 530s: 0.4MB/s
> ....
>> fio --filename=/dev/sdb --direct=1 --sync=1 --rw=write --bs=4k
>>   --iodepth=1 --runtime=60 --time_based --group_reporting
>>   --name=IntelDC3510_4kj1 --numjobs=1
> Arguably the 520s actually have no performance.
>
> https://www.sebastien-han.fr/blog/2014/10/10/ceph-how-to-test-if-your-ssd-is-suitable-as-a-journal-device/

I have seen this page, and all I can suggest is that the 480GB 520s 
performs very different to the 60GB model. I see 70MB/s which is 
significantly different to the listed 9MB/s on that page.
This page matches my results (comparatively) that the 520 performs much 
better than the 535, though I don't have easy access to a 535 in order 
to run my destructive tests.... but I did run similar tests on a 535, 
and I ran the more thorough tests on the 530 and 540.

Regards,
Adam

