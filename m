From: Brad Campbell <brad@wasp.net.au>
Subject: Re: is automount affecting root device? huh?
Date: Thu, 01 Jul 2004 16:39:06 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40E405EA.8040803@wasp.net.au>
References: <Pine.LNX.4.58.0407010801300.471@jupiter.toms.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0407010801300.471@jupiter.toms.net>
To: Tom Oehser <tom@toms.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tom Oehser wrote:
> Hi-
> 
> I have 2 raid-5 arrays, one is md software raid running on a Highpoint
> 1540, the other one is a Mylex Acceleraid-250 hardware scsi raid card.
> 
> Lilo is working fine to boot from the Mylex.  But, if I have the md on
> the Highpoint autodetected, and if it doesn't have a /etc/fstab entry,
> it seems to screw up the kernel's root device!?!
> 

While I was using Highpoint 1540's with an autodetected raid 5 on these with the boot drive on hda, 
I had to use ide=reverse to make the machine boot from the "correct" drive. Changing the 1540's out 
for Promise SATA 150 TX4 controllers made this problem go away.

I never really investigated it any further
Regards,
Brad
