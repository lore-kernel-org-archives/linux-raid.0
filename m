From: Zlatko Calusic <zlatko.calusic@iskon.hr>
Subject: Re: How to rename MD device (e.g. md3 -> md2)?
Date: Tue, 08 Apr 2008 00:24:21 +0200
Message-ID: <87k5j9mhgq.fsf@magla.zg.iskon.hr>
References: <87zls53bv1.fsf@magla.zg.iskon.hr>
	<e9c3a7c20804071451m7cbd10bam5d66a24191cf2958@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Dan Williams" <dan.j.williams@intel.com> writes:

> On Mon, Apr 7, 2008 at 8:48 AM, Zlatko Calusic <zlatko.calusic@iskon.hr> wrote:
>> Hello list!
>>
>>  Does anybody know what would be the fastest way to rename MD device
>>  (without recreating/resyncing)? I have md0, md1 and md3 in system (don't
>>  ask :)), and obviously it would look slightly nicer if that md3 was
>>  called md2 instead, like I have on other machines (with all the same
>>  setup, except this small difference). Is it possible?
>>
>
> Sure, you should just be able to do:
>
> mdadm --stop /dev/md3
> mdadm --assemble /dev/md2 <insert component devices here>

So simple... who would've thought of that. :) Thank you!

Although, the recipe will have to wait for another occasion to prove
itself, my new md2 is in the middle of resyncing process as I write
this. But, I don't mind. While I was copying the filesystem to the new
device, I noticed that it was heavily fragmented in places (transfer
speed was dropping from typical 40+ MB/s to below 10 MB/s - all very big
files!), so I'm sure copying was good for it. :)

Regards,
-- 
Zlatko
