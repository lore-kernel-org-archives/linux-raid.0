From: Dave Fisher <davef@davefisher.co.uk>
Subject: Re: RAID 10 array won't assemble, all devices marked spare, confusing mdadm metadata
Date: Sat, 18 Apr 2009 15:43:03 +0100
Message-ID: <20090418144303.GA18440@davefisher.co.uk>
References: <20090417141402.GB27042@davefisher.co.uk> <18921.1283.548260.293728@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18921.1283.548260.293728@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Apr 18, 2009 at 08:38:59AM +1000, Neil Brown wrote:
> To restart your array, simple use the "--force" flag.
> It might be valuable to also add "--verbose" so you can see what is
> happening.
> So:
> 
>   mdadm -S /dev/md1
>   mdadm -A /dev/md1 -fv /dev/sd[abcde]4
> 
> and report the result.

Hi Neil,

Thanks for the kind and exceptionally helpful response. It was much
appreciated.  It greatly improved my understanding of both the problem
and md generally.

As it happens, I'd issued the following command some time before your
message arrived:

  $ mdadm --assemble --run /dev/md1 /dev/sd[bcde]4

Fortunately, my impatience (after nearly a week of grief) was not
rewarded by the punishment it probably deserved ;-) [Note 1]

After many more hours /dev/md1 had resynched and recovered, using sdbe4
as the spare.

The system then rebooted perfectly.

Unfortunately, I then stupidly installed a new kernel, forgetting that
Debian/Ubuntu would then update grub.  

So now I can boot kernels which reside on /dev/md0 from grub, but they
don't find the root file system, which is also on /dev/md0.  

Needless to say, I'd find this a little easier to understand if the
booting kernel didn't actually sit on the root filesystem itself.

Obviously I need to fix grub, but I'm not sure how.  I'm guessing that I
have to do one or both of the following:

  1. Tweak the root parameters for grub or the kernel in menu.lst

  2. Update/reinstall parts of the bootloader on my MBRs or partitions.  

Sadly, my understanding of grub is a bit flaky, and my understanding of
how it handles raid arrays is even flakier.

I'd appreciate some advice, but fully understand that the new problem
is slightly off-topic for this list, so I'm not expecting anything.

By the way, once I've sorted grub (and backed up my business-critical
data), I'll run your suggested command on the original disks and report
back.

In the real world I have decades of experience as a technical writer and
teacher.  So, once I've educated myself a bit more, I'd like to
contribute by helping to improve the fragmented and outdated
documentation that I've found over the course of the last week. 

Best wishes,

Dave

[Note 1] I should add that my impatient act was not 100% reckless,
since I had previously dd'd all 5 1TB disks and was operating only on
the copies.



