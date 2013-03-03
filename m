From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance - new kernel results - 5x SSD RAID5
Date: Mon, 04 Mar 2013 02:19:45 +1100
Message-ID: <ac5cdf66-ba01-4d7b-bd7b-60fb67517ad4@email.android.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <51222A81.9080600@hardwarefreak.com> <51250377.509@websitemanagers.com.au> <5125B8E5.5000502@hardwarefreak.com> <5125C154.3090603@websitemanagers.com.au> <51272808.7070302@hardwarefreak.com> <512A79D3.9020502@hardwarefreak.com> <5130D206.4090302@websitemanagers.com.au> <5131C338.8010402@hardwarefreak.com> <513231BB.4070903@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <513231BB.4070903@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, stan@hardwarefreak.com
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Phil Turmel <philip@turmel.org> wrote:

>On 03/02/2013 04:15 AM, Stan Hoeppner wrote:
>> On 3/1/2013 10:06 AM, Adam Goryachev wrote:
>
>>> 15) "Make sure all LVs are aligned to the underlying md device
>>> geometry. This will eliminate any possible alignment issues."
>>> What does this mean? The drive partitions are now aligned properly,
>>> but how does LVM allocate the blocks for each LV, and how do I
>>> ensure it does so optimally? How do I even check this?
>> 
>> I'm not an LVM user so I can't give you command lines.  But what I
>> can tell you follows, and it is somewhat critical to RMW performance,
>> more for rust but also for SSD to a lesser degree.
>Run "dmsetup table" and look at the start sectors for your volumes:
>Fast-Root: 0 314572800 linear 9:3 3072
>This volume starts at sector 3072 (1.5MB) on /dev/sda3.  So the volume
>alignment within LVM is 512K.

I see this (for the first LV)
vg0-hostname: 0 204808192 linear 147:2 512
So, I'm guessing mine is starting at 512, and is also aligned at 512k ?

Also, pvdisplay tells me the PE Size is 4M, so I'm assuming that regardless of how the LV's are arranged, they will always be 512k aligned?

So, is that enough to be sure that this is not an issue?

Thanks,
Adam



--
Adam Goryachev
Website Managers
www.websitemanagers.com.au
