From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance - new kernel results - 5x SSD RAID5
Date: Sat, 02 Mar 2013 17:48:47 -0600
Message-ID: <51328FDF.1050505@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <51222A81.9080600@hardwarefreak.com> <51250377.509@websitemanagers.com.au> <5125B8E5.5000502@hardwarefreak.com> <5125C154.3090603@websitemanagers.com.au> <51272808.7070302@hardwarefreak.com> <512A79D3.9020502@hardwarefreak.com> <5130D206.4090302@websitemanagers.com.au> <5131C338.8010402@hardwarefreak.com> <513231BB.4070903@turmel.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <513231BB.4070903@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 3/2/2013 11:07 AM, Phil Turmel wrote:
> On 03/02/2013 04:15 AM, Stan Hoeppner wrote:
>> On 3/1/2013 10:06 AM, Adam Goryachev wrote:
...
>>> Is it worth reducing the chunk size from 64k down to 16k or even smaller?
>>
>> 64KB chunks should be fine here.  Any gains with a smaller chunk would
>> be small, and would pale in comparison to the amount of PITA required to
>> redo the array and everything currently sitting atop it.  Remember you'd
>> have to destroy it and start over.  You can't change chunk size of an
>> existing array.
> 
> Actually, you can.  For levels 0 and 4,5,6.

First, I'll reiterate that a smaller chunk size likely is not going to
yield real workload gains for Adam.  And it obviously would decrease his
FIO numbers, making him think performance decreased, even if it actually
increased slightly with his real workload.

Speaking strictly now from a knowledge transfer standpoint, does this
chunk size change feature go back a ways or does it require a fairly
recent kernel and/or mdadm?  Are there any prerequisites or special
considerations different from any other reshape operation?

-- 
Stan

