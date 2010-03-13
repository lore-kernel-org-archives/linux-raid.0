From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: large filesystem corruptions
Date: Sat, 13 Mar 2010 18:45:48 -0500
Message-ID: <4B9C23AC.5010404@tmr.com>
References: <4B9A9D81.3000009@edu.physics.uoc.gr> <4B9AA5AC.9090005@redhat.com> <4B9ADC61.7080007@edu.physics.uoc.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B9ADC61.7080007@edu.physics.uoc.gr>
Sender: linux-raid-owner@vger.kernel.org
To: Kapetanakis Giannis <bilias@edu.physics.uoc.gr>
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kapetanakis Giannis wrote:
> On 12/03/10 22:35, Ric Wheeler wrote:
>
>> This is probably an issue with the early version of ext4 you are using -
>> note that the support for ext4 > 16TB is still gated by some work done
>> up in the tools chain.
>>
>> Have you tried xfs?
>>
>> regards,
>>
>> Ric
>
> Thanks for answering,
>
> My filesystem would be 15 TB < 16 TB.
> GFS also crashed and burned so are you sure that this
> this is a problem with ext4?
> Would Fedora and newer kernel be better?
>
> On my tests the crashing filesystem was 7TB.
> When I added a second fs of 2 TB on lvm, so total > 8TB
> I had the crash.
>
> I did a new test now and didn't use GFT partitions
> but the whole physical/logical drives
>
> sdb -
>     | ---> md0 ---> LVM ---> ext4 filesystems
> sdc -
>
> all sdb, sdc, md0 are gpt labeled without gpt partitions
> inside. No crash so far but without any data written.
>
> Maybe the gpt partitions did the bad thing?
> Can md0 use large gpt drives with no partitions?
> can lvm2 use large raid device with no partition pv?

I did not notice the LVM on your first post, it's far enough down that I 
missed it. I would be suspicious that the problem is in LVM rather than 
md, but if you're going for a new install soon it's probably not worth 
checking.

If you have video issues with FC12 you may need to run the vesa driver 
as a quick solution. There have been learning experiences in the video 
drivers in recent kernels, not just Fedora.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

