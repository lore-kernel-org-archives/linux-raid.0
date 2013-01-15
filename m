From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Tue, 15 Jan 2013 05:19:58 -0600
Message-ID: <50F53B5E.7000106@hardwarefreak.com>
References: <201212212357.19292.thomas@fjellstrom.ca> <201301141453.13819.thomas@fjellstrom.ca> <50F4B5E5.30809@hardwarefreak.com> <201301142052.06390.thomas@fjellstrom.ca> <50F5157A.2080308@hardwarefreak.com> <CAGA4a+GFfQeR-D-vuKJizG4xPVP1iYxBU8k5cVuP2yOYTgCt=Q@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGA4a+GFfQeR-D-vuKJizG4xPVP1iYxBU8k5cVuP2yOYTgCt=Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tommy Apel <tommyapeldk@gmail.com>
Cc: linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/15/2013 3:02 AM, Tommy Apel wrote:
> Stan: it is true what you are saying about the cache and real life usage
> but if you suspect a problem with the array I would suggest testing array
> rather than the buffer system in linux hence the use if O_DIRECT as that
> will determine the array performance and not the vmem.

If you really want to get to testing only the array you must bypass the
filesystem as well using something like fio for your testing.  Simply
bypassing the buffer cache only removes one obstacle of many in the IO path.

But in Thomas case raw IO numbers still don't clear the fog for him
because he has no idea what the numbers _should_ be in the first place.
 He is assuming, due to lack of knowledge/experience, that write
throughput that is ~1/3rd his read throughput is wrong.  It's not.  It
is expected.

To see this for himself all he need do is blow it away and create a 6
disk RAID10 or layered RAID0 over 3 RAID1 pairs.  When he sees the much
higher iozone write throughput with only 6 of his disks, only 3 spindles
vs 5, then he'll finally understand their is a huge write performance
penalty with RAID6.

-- 
Stan

