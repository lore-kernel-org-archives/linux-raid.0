From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID performance - new kernel results - 5x SSD RAID5
Date: Sat, 02 Mar 2013 12:07:07 -0500
Message-ID: <513231BB.4070903@turmel.org>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <51222A81.9080600@hardwarefreak.com> <51250377.509@websitemanagers.com.au> <5125B8E5.5000502@hardwarefreak.com> <5125C154.3090603@websitemanagers.com.au> <51272808.7070302@hardwarefreak.com> <512A79D3.9020502@hardwarefreak.com> <5130D206.4090302@websitemanagers.com.au> <5131C338.8010402@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5131C338.8010402@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/02/2013 04:15 AM, Stan Hoeppner wrote:
> On 3/1/2013 10:06 AM, Adam Goryachev wrote:

>> 15) "Make sure all LVs are aligned to the underlying md device geometry.
>>  This will eliminate any possible alignment issues."
>> What does this mean? The drive partitions are now aligned properly, but
>> how does LVM allocate the blocks for each LV, and how do I ensure it
>> does so optimally? How do I even check this?
> 
> I'm not an LVM user so I can't give you command lines.  But what I can
> tell you follows, and it is somewhat critical to RMW performance, more
> for rust but also for SSD to a lesser degree.

Run "dmsetup table" and look at the start sectors for your volumes:

> Fast-Root: 0 314572800 linear 9:3 3072

This volume starts at sector 3072 (1.5MB) on /dev/sda3.  So the volume
alignment within LVM is 512K.

>> Is it worth reducing the chunk size from 64k down to 16k or even smaller?
> 
> 64KB chunks should be fine here.  Any gains with a smaller chunk would
> be small, and would pale in comparison to the amount of PITA required to
> redo the array and everything currently sitting atop it.  Remember you'd
> have to destroy it and start over.  You can't change chunk size of an
> existing array.

Actually, you can.  For levels 0 and 4,5,6.

HTH,

Phil
