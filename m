From: Iordan Iordanov <iordan@cdf.toronto.edu>
Subject: Re: debian software raid1
Date: Wed, 20 Apr 2011 10:51:29 -0400
Message-ID: <4DAEF2F1.8080204@cdf.toronto.edu>
References: <1303215166.2809.8.camel@valio>	<BANLkTik7iVaUH2bn9spW2gtV-TkjLH2Qag@mail.gmail.com>	<4DADB24F.2030300@cdf.toronto.edu> <20110420085148.12ac0002@notabene.brown> <4DAE29EA.4040306@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DAE29EA.4040306@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: NeilBrown <neilb@suse.de>, =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, b2 <b2@playtime.bg>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Joe,

On 04/19/11 20:33, Joe Landman wrote:
> This gets to my question, since we haven't tried this yet ... can we do
> whole device MD RAIDs, and boot from them? Is there anything special we
> need to do in their construction (use --auto=mdp or similar)? We'd
> really prefer to go this route rather than building multiple smaller
> RAIDs. We can manage the latter, but the former is far easier/cleaner to
> handle rebuilds with.

A few days ago (just before this thread started, coincidentally), I 
converted a single drive system to RAID1 by adding a second disk, and 
raiding the whole drive. This does have the drawback that any 
replacement drives have to be the same size or bigger than what you had 
to begin with. I am running Ubuntu 10.04.

A few things I had to make sure, and I disclaim that this is not an 
exhaustive list. I created the array and named it /dev/md0. Then, I had 
to do:

1) mdadm --examine --scan > /etc/mdadm/mdadm.conf
2) Rebuild initrd, so that upon boot the array will be assembled 
automatically based on this mdadm.conf. On Debian/Ubuntu, this can be 
done with update-initramfs.

When you partition /dev/md0 with whatever partitioner you prefer, the 
kernel does see the partitions, and makes /dev/md0pN for partition 
number N. Hence you can use these to mount/start swap.

For the record, I have been suspending/resuming that Ubuntu 10.04 with 
swap living on one of the RAID1 partitions with no ill effect, and will 
revisit this thread if I ever do experience issues!

Also, I was thinking of switching from RAID1 to RAID10 with near layout 
and two copies (effectively RAID1) in order to get faster reads - 
anybody have any opinion on this?

Cheers everyone, and thanks for all the discussion!
Iordan
