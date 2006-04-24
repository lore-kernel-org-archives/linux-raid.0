From: Tim Bostrom <tbostrom@writemem.com>
Subject: Re: Problem with 5disk RAID5 array - two drives lost
Date: Sun, 23 Apr 2006 17:17:50 -0700
Message-ID: <A6B7149E-FC1E-4779-8370-66AF285F58A0@writemem.com>
References: <A2F915E2-EC52-4EFE-86C2-547A71F8D788@writemem.com> <62b0912f0604212054m40283fdbybdb6cd89e61dd153@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v749.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0604212054m40283fdbybdb6cd89e61dd153@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

First let me say - thank you for responding.  I'm still trying to  
figure out this problem.


On Apr 21, 2006, at 8:54 PM  Apr 21, 2006, Molle Bestefich wrote:

> Tim Bostrom wrote:
>> It appears that /dev/hdf1 failed this past week and /dev/hdh1  
>> failed  back in February.
>
> An obvious question would be, how much have you been altering the
> contents of the array since February?
>

This is a video backup drive for my MythTV system.  I just backup old  
TV shows and movies from my system.  There's maybe 3-4 GB of data  
that's been stored there since February and no other data's been  
moved or deleted.  Pretty much when something is backed up here, it  
stays.  I'm willing to lose the February - April data.

>
>> hdf: dma_intr: error=0x40 { UncorrectableError }, LBAsect=6720
>
>
>
> Actually, there's a lot of sequential sector numbers in the output  
> you posted.
> I think it's unusual for a drive to develop that many bad blocks in  
> a row.
> I could be wrong, and it could be a head crash or something (have you
> been moving the system around much?).
>
> But if I had to guess, I'd say that there's a real likelihood that
> it's a loose cable or a controller problem or a driver issue.
>
> Could you try and run:
> # dd if=/dev/hdf of=/dev/null bs=1M count=100 skip=1234567
> You can play around with different random numbers instead of 1234567.
> If it craps out *immediately*, then I'd say it's a cable problem or
> so, and not a problem with what's on the platters.
>


Tried running this.  It doesn't crap out immediately.  Goes along,  
but I see a bunch of the {Uncorrectable Error} {Drive Ready Seek  
Complete} errors in dmesg that I posted before.  I see these messages  
in dmesg when I run the above command.

I bought two extra 250GB drives - I'll try using dd_rescue as  
recommended and see if I can get a "good" copy of hdf online.



>
> No, get the array running first, then fix the filesystem.
>
> You can initiate array checks and repairs like this:
> # cd /sys/block/md0/md/
> # echo check > sync_action
> or
> # echo repair > sync_action
>
>
