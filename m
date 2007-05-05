From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Linux SW RAID: HW Raid Controller/JBOD vs. Multiple PCI-e Cards?
Date: Sat, 05 May 2007 12:44:47 -0400
Message-ID: <463CB47F.4040206@tmr.com>
References: <Pine.LNX.4.64.0705051228300.12744@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705051228300.12744@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

Justin Piszcz wrote:
> Question,
>
> I currently have a 965 chipset-based motherboard, use 4 port onboard 
> and several PCI-e x1 controller cards for a raid 5 of 10 raptor 
> drives.  I get pretty decent speeds:
>
> user@host$ time dd if=/dev/zero of=100gb bs=1M count=102400
> 102400+0 records in
> 102400+0 records out
> 107374182400 bytes (107 GB) copied, 247.134 seconds, 434 MB/s
>
> real 4m7.164s
> user 0m0.223s
> sys 3m3.505s
> user@host$ time dd if=100gb of=/dev/null bs=1M count=102400
> 102400+0 records in
> 102400+0 records out
> 107374182400 bytes (107 GB) copied, 172.588 seconds, 622 MB/s
>
> real 2m52.631s
> user 0m0.212s
> sys 1m50.905s
> user@host$
>
> Also, when I run simultaenous dd's from all of the drives, I see 
> 850-860MB/s, I am curious if there is some kind of limitation with 
> software raid as to why I am not getting better than 500MB/s for 
> sequential write speed?  With 7 disks, I got about the same speed, 
> adding 3 more for a total of 10 did not seem to help in regards to 
> write. However, read improved to 622MBs/ from about 420-430MB/s.
>
> However, if I want to upgrade to more than 12 disks, I am out of PCI-e 
> slots, so I was wondering, does anyone on this list run a 16 port 
> Areca or 3ware card and use it for JBOD?  What kind of performance do 
> you see when using mdadm with such a card?  Or if anyone uses mdadm 
> with less than a 16 port card, I'd like to hear what kind of 
> experiences you have seen with that type of configuration.

RAID5 is not the fastest at write, there are patches being tested to 
improve that.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

