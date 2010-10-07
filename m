From: Michael Sallaway <michael@sallaway.com>
Subject: Re: Raid 6 - TLER/CCTL/ERC
Date: Thu, 07 Oct 2010 10:45:39 +1000
Message-ID: <4CAD1833.10609@sallaway.com>
References: <556404795.674.1286344296358.JavaMail.root@mail.networkmayhem.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <556404795.674.1286344296358.JavaMail.root@mail.networkmayhem.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Zieba <pzieba@networkmayhem.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 6/10/2010 3:51 PM, Peter Zieba wrote:
> I have a question regarding Linux raid and degraded arrays.
>
> My configuration involves:
>   - 8x Samsung HD103UJ 1TB drives (terrible consumer-grade)
>   - AOC-USAS-L8i Controller
>   - CentOS 5.5 2.6.18-194.11.1.el5xen (64-bit)
>   - Each drive has one maximum-sized partition.
>   - 8-drives are configured in a raid 6.
>
> My understanding is that with a raid 6, if a disk cannot return a given sector, it should still be possible to get what should have been returned from the first disk, from two other disks. My understanding is also that if this is successful, this should be written back to the disk that originally failed to read the given sector. I'm assuming that's what a message such as this indicates:
> Sep 17 04:01:12 doorstop kernel: raid5:md0: read error corrected (8 sectors at 1647989048 on sde1)
>
> I was hoping to confirm my suspicion on the meaning of that message.
>
> On occasion, I'll also see this:
> Oct  1 01:50:53 doorstop kernel: raid5:md0: read error not correctable (sector 1647369400 on sdh1).
>
> This seems to involved the drive being kicked from the array, even though the drive is still readable for the most part (save for a few sectors).

Hi Peter,

I've just been in the *exact* same situation recently, so I can probably 
answer some of your questions (only as another end-user, though!). I'm 
using similar samsung drives (the consumer 1.5TB drives), the 
AOC-USASLP-L8i, and ubuntu kernels.

First off, I don't think the LSI1068E really works properly in any 
non-recent kernel; I was using 2.6.32 (stock Ubuntu 10.04 kernel), and 
having all sorts of problems with the card (read errors, bus errors, 
timeouts, etc.). I ended up going back to my old controller for a while. 
However, I've recently changed kernel (to 2.6.35) for other reasons 
(described below), and now the card is working fine. So I'm not sure how 
different it will be in CentOS, but you may want to consider trying a 
newer kernel in case the card is causing problems.

As for the read errors/kicking drives from the array, I'm not sure why 
it gets kicked reading some sectors and not others, however I know there 
were changes to the md stuff which handled that more gracefully earlier 
this year. I had the same problem -- on my 2.6.32 kernel, a rebuild of 
one drive would hit a bad sector on another and drop the drive, then hit 
another bad sector on a different drive and drop it as well, making the 
array unusable. However, with a 2.6.35 kernel it recovers gracefully and 
keeps going with the rebuild. (I can't find the exact patch, but Neil 
had it in an earlier email to me on the list; maybe a month or two ago?) 
So again, I'd suggest trying a newer kernel if you're having trouble.

Mind you, this is only as another end-user, not a developer, so I'm sure 
I've probably got something wrong in all that. :-)  But that's what 
worked for me.

Hope that helps,
Michael

