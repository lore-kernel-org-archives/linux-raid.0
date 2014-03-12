From: David Brown <david.brown@hesbynett.no>
Subject: Re: Replace RAID devices without resorting to degraded mode?
Date: Wed, 12 Mar 2014 13:45:31 +0100
Message-ID: <532056EB.2080206@hesbynett.no>
References: <CAK_KU4ZfsCOyZxgkxLC7AFOJ2XEvcHi-Gr7itv4q_pPOQbaAYA@mail.gmail.com>	<53202503.10901@hesbynett.no> <CAE6VuKFxqRET=tQoSvbHFd7iiKeXBPJZTBUgTTwMpzOnrPEmbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE6VuKFxqRET=tQoSvbHFd7iiKeXBPJZTBUgTTwMpzOnrPEmbg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Raul Dias <raul@dias.com.br>
Cc: Scott D'Vileskis <sdvileskis@gmail.com>, "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/03/14 13:23, Raul Dias wrote:
> 2014-03-12 6:12 GMT-03:00 David Brown <david.brown@hesbynett.no>:
> ...
>>
>> If you want to safely replace the disks in a raid5 array, the easiest
>> way is to add a new disk (this can be an external USB disk if necessary)
>> and re-shape to an asymmetric raid6 with parity Q on the new disk.  Now
>> you have an extra redundancy for safety.  (Use asymmetric raid6 to avoid
>> re-striping the existing disks.)
> 
> Is there a solution for other RAID setups? 1,0,6,10?
> 
> thanks
> 

The whole idea of bumping up from raid5 to raid6 before maintenance is
to improve the redundancy before you remove existing drives.  It is not
strictly necessary, but I think it is nice to have the extra safety.
Hot replace makes it less important (since you don't remove the "old"
drive until the new one is fully sync'ed).

So for raid1, you would add a new mirror device, making a 3-way mirror
instead of a 2-way one (I don't know off-hand if md raid allows this
re-shape).

Raid0 has no redundancy at all - so re-shape it to raid4 or asymmetric
raid5 (which is equivalent) with parity on a new disk before doing the
replacements.

Raid6 already has two parities.  You'll have to wait for Andrea
Mazzoleni's great work on multi-parity raid to make it into mdadm and
the kernel before you can add extra redundancy, but two disk redundancy
is probably enough anyway (especially with hot replace).

I think there are sever limits on the type of Raid10 reshapes you can
do, so I don't think it is possible to add redundancy here.


