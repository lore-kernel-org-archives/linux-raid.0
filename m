From: Robey Holderith <robey@flaminglunchbox.net>
Subject: Re: out of sync raid 5 + xfs = kernel startup problem
Date: Wed, 13 Apr 2005 22:07:59 -0400
Message-ID: <425DD07F.8090802@flaminglunchbox.net>
References: <425C7D1E.30708@flaminglunchbox.net> <16988.39872.477594.821987@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16988.39872.477594.821987@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

Neil Brown wrote:

>On Tuesday April 12, robey@flaminglunchbox.net wrote:
>  
>
>>My raid5 system recently went through a sequence of power outages.  When 
>>everything came back on the drives were out of sync.  No big issue... 
>>just sync them back up again.  But something is going wrong.  Any help 
>>is appreciated.  dmesg provides the following (the network stuff is 
>>mixed in):
>>
>>    
>>
>
>Here's the main problem.
>
>You've got a degraded, unclean array.  i.e. one drive is
>failed/missing and md isn't confident that all the parity blocks are
>correct due to an unclean shutdown (could have been in the middle of a
>write). 
>This means you could have undetectable data corruption.
>
>md wants you to know this an not assume that everything is perfectly
>OK.
>
>You can still start the array, but you will need to use
>  mdadm --assemble --force
>which means you need to boot first ... got a boot CD?
>
>I should add a "raid=force-start" or similar boot option, but I
>haven't yet.
>
>So, boot somehow, and
>  mdadm --assemble /dev/md0 --force /dev/sd[a-f]2
>
>  mdadm /dev/md0 -a /dev/sdd2
>
> wait for sync to complete (not absolutely needed).
>
>Reboot.
>  
>
Thanks for the help.  I rebooted using a rescue partition and used the 
two commands.  After about 2 hours of synching the array decided that 
sdf had failed and ceased its synch.  I restarted and then tried to 
assemble the array once again.  sdd2 and sdf2 are now both marked as 
spares and the array had only 4/6 partitions... dead.  Can I force the 
device numbers within the array?  I know that sdd2 was position 5 and 
sdf2 was position 3.  I'd like to save what I can... most of the data on 
the array can be reproduced... but it takes so much time.

If anyone is interested during my attempts to force the array to run I 
got a segfault in mdadm.  I'll post a snippet here... ignore if it's old 
news.

md: pers->run() failed ...
Unable to handle kernel NULL pointer dereference at 0000000000000030 RIP:
<ffffffff802c9350>{md_error+64}

Again... thanks for any and all help.

-Robey
