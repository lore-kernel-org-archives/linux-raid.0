From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Creating a 3-disk RAID6 array
Date: Thu, 17 May 2012 00:22:52 -0400
Message-ID: <4FB47D1C.8060202@tmr.com>
References: <4FB4534A.5070608@volatilevoid.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FB4534A.5070608@volatilevoid.net>
Sender: linux-raid-owner@vger.kernel.org
To: Oliver Martin <oliver@volatilevoid.net>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Oliver Martin wrote:
> Hi,
>
> is there any specific reason why md refuses to create a RAID6 array with 3
> disks? My (probably naive) understanding suggests it should be the same as a
> 3-disk RAID1, similar to a 2-disk RAID5.
>
> The reason I'm asking is that I currently have space on three disks for a new
> array, and would like to expand it when I add a fourth. I tried this scenario
> with a few loopback devices, but the only way to go from a 3-disk RAID1 to a
> 4-disk RAID6 seems to be via an intermediate 3-disk RAID5, requiring two
> reshapes. I'd like to avoid one of them, if at all possible.
>
If you are definitely planning to add another drive fairly soon, you can create 
a four drive array with one missing. Given that the performance of a three way 
raid-6 is not going to be stellar anyway, since you write to every drive with 
every write, you actually might find it runs better only writing to two on some 
chunks.

It avoids the whole double reshape issue.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
