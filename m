From: David Brown <david@westcontrol.com>
Subject: Re: Striping does not increase performance.
Date: Mon, 12 Mar 2012 15:20:31 +0100
Message-ID: <jjl15t$iqb$1@dough.gmane.org>
References: <CAKFseUN8-Rb1x5j-JM+q3CLEXnFO0ieAmBG_5tVcxu4NAz0ojA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKFseUN8-Rb1x5j-JM+q3CLEXnFO0ieAmBG_5tVcxu4NAz0ojA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/03/2012 13:34, Caspar Smit wrote:
> Hi all,
>
> I don't know exactly which mailinglists to use for this one so I hope
> i used the right ones.
>
> I did some performance testing on a new system and found out some
> things I couldn't explain or didn't expect.
> At the end are some questions I hope to get answered to explain the
> tings i'm seeing in the test.
>
>
> For the next test I wanted to see if i could double the performance by
> striping an LV over 2 md's (so instead of using 10 disks/spindles, use
> 20 disks/spindles)
>
> So i added md1 to the VG as PV.
>
> Created a fresh LV striped across the two PV's using a 64KB stripe
> size and ran the test again.
>
>
> Now the total IO's in 10 seconds are 16x larger than before. 190464 /
> 10 = 19046,4 / 16 = 1190,4 /16 = the reported 75 IOPS above.
> So the 64KB blocks seem to be split into 4KB blocks (64 / 16 = 4)
> which results in a way larger total IO's.
> The IO's per disk seem to be in 64KB blocks still only now with a
> large MERGE figure besides it. (Now 4KB blocks are merged into 64KB
> blocks?)
>

LVM will stripe the data between the two md's with a default stripe size 
of 4K - thus the first 4K will go to md0, the second to md1, etc.  This 
is obviously terribly inefficient.  For 8+2 raid6 with 64KB chunks, you 
want a stripe size of 8x64K = 512KB when you create the logical volume.

> The performance does not double but stays the same as with 1 MD set
> only the total IO's are spread among the MD's. Each disk now does
> around 60 IOPS!
>
> I still wanted to see if I could double the performance and thought it
> might have something to do with LVM striping so i ditched LVM and
> created a RAID0 (md6) over md0 and md1 with a chunk size of 64KB
> again.
>

Similarly here, you want your chunk sizes to fit a stripe on the raid 
devices, not to fit the underlying devices.  So try with a chunk size of 
512KB (or higher).

mvh.,

David


