From: Neil Brown <neilb@suse.de>
Subject: Re: RAID 5 array keeps dropping drive on boot
Date: Tue, 8 Nov 2005 10:55:11 +1100
Message-ID: <17263.59743.163989.959271@cse.unsw.edu.au>
References: <2A807893-B5A6-4EF1-B862-1D6F22D71B60@fnuck.dk>
	<17263.57266.902113.362087@cse.unsw.edu.au>
	<5DD8751D-7FE2-4179-9887-853A704DE0D6@fnuck.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Troels Bang Jensen on Tuesday November 8
Sender: linux-raid-owner@vger.kernel.org
To: Troels Bang Jensen <marvin@fnuck.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday November 8, marvin@fnuck.dk wrote:
> 
> Unfortunately I'm sure;
> 
>     Device Boot      Start         End      Blocks   Id  System
> /dev/hdc1               1           6       48163+  fd  Linux raid  
> autodetect
> /dev/hdc2               7          30      192780   82  Linux swap /  
> Solaris
> /dev/hdc3              31       36481   292792657+  fd  Linux raid  
> autodetect

Ok, thanks.
So I read your original email again and see:

> I just tried rebooting during a synchronization (had to move the  
> computer), and the state of /dev/hdc3 is now:
...
> ...but it's not synching.

I wouldn't expect it to be syncing.  You rebooted during a recovery
(onto a spare).  This is quite different from a resync (after a crash,
or on a newly created array).
If you reboot during a recovery, you have to start the recovery again
at the start.

Have you actually had the array completely recoverred since swapping
hdc? 

> 
> So I think I should be safe. Still, all partitions on the drives are  
> primary partitions. Could that be the explanation?

No, I don't think you are facing this issue.

NeilBrown
