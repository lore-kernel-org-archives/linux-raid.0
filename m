From: Luca Berra <bluca@comedia.it>
Subject: Re: Raid-10 mount at startup always has problem
Date: Mon, 29 Oct 2007 09:18:03 +0100
Message-ID: <20071029081802.GB15475@percy.comedia.it>
References: <46D3147D.2040201@amfes.com> <46D49F1A.7030409@tmr.com> <46E4A39C.8040509@amfes.com> <46E4A5F0.9090407@sauce.co.nz> <46E4A7C3.1040902@amfes.com> <471F5542.3020504@amfes.com> <471FA485.6010705@tmr.com> <47202D17.3040000@amfes.com> <1193294406.10336.76.camel@firewall.xsintricity.com> <472576A5.3030603@amfes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <472576A5.3030603@amfes.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Oct 28, 2007 at 10:59:01PM -0700, Daniel L. Miller wrote:
>Doug Ledford wrote:
>>Anyway, I happen to *like* the idea of using full disk devices, but the
>>reality is that the md subsystem doesn't have exclusive ownership of the
>>disks at all times, and without that it really needs to stake a claim on
>>the space instead of leaving things to chance IMO.
>>   
>I've been re-reading this post numerous times - trying to ignore the 
>burgeoning flame war :) - and this last sentence finally clicked with me.
>
I am sorry Daniel, when i read Doug and Bill, stating that your issue
was not having a partition table, i immediately took the bait and forgot
about your original issue.
I have no reason to believe your problem is due to not having a
partition table on your devices.

....
sda: unknown partition table
....
sdb: unknown partition table
....
sdc: unknown partition table
....
sdd: unknown partition table

the above clearly shows that the kernel does not see a partition table
where there is none which happens in some cases and bit Doug so hard.
Note, it does not happen at random, it should happen only if you use a
partitioned md device with a superblock at the end. Or if you configure
it wrongly as Doug did. (i am not accusing Doug of being stupid at all,
it is a fairly common mistake to make and we should try to prevent this
in mdadm as much as we can)
Again, having the kernel find a partition table where there is none,
should not pose a problem at all unless there is some badly designed software
like udev/hal that believes it knows better than you about what you have
on your disks.
but _NEITHER OF THESE IS YOUR PROBLEM_ imho

I am also sorry to say that i fail to identify what the source of your
problem is, we should try harder instead of flaming between us.

Is it possible to reproduce it on the live system
e.g. unmount, stop array, start it again and mount.
I bet it will work flawlessly in this case.
then i would disable starting this array at boot, and start it manually
when the system is up (stracing mdadm, so we can see what it does)

I am also wondering about this:
md: md0: raid array is not clean -- starting background reconstruction
does your system shut down properly?
do you see the message about stopping md at the very end of the
reboot/halt process?

L.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
