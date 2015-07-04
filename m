From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Issue removing failed drive and re adding on raid 6
Date: Sat, 04 Jul 2015 10:23:06 +0100
Message-ID: <5597A5FA.8000204@youngman.org.uk>
References: <emfb4b5aee-68ba-4089-a763-4e835afefc45@littlez> <5597922A.90402@youngman.org.uk> <alpine.DEB.2.02.1507041009040.11810@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1507041009040.11810@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/07/15 09:10, Mikael Abrahamsson wrote:
> 
>> Make sure you've got your raid timeout increased - there's plenty of
>> threads about how to do it - otherwise one disk hiccup for any reason
>> is likely to cause a cascade of failures !!!!
> 
> I recommend this as minimum (in rc.local for instance):
> 
> for x in /sys/block/sd[a-z] ; do
>         echo 180  > $x/device/timeout
> done
> 
> echo 4096 > /sys/block/md0/md/stripe_cache_size

If you didn't do this, this could EASILY explain your problems. 7 disks
is 21TB of data. That pretty much *guarantees* TWO soft errors. Each
error will kick a disk from the array. Plus the drive you're replacing
that makes your raid 6 short by 3 drives. OOOOPPPSS.

Cheers,
Wol
