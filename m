From: Neil Brown <neilb@suse.de>
Subject: Re: Raid-1 to Raid-5 conversion possible?
Date: Thu, 25 Jan 2007 09:39:45 +1100
Message-ID: <17847.57393.35146.578984@notabene.brown>
References: <584a96130701241433m340fc79fhc04a6cf5c9456c16@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Vidar Sonerud on Wednesday January 24
Sender: linux-raid-owner@vger.kernel.org
To: Vidar Sonerud <vidar.sonerud@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday January 24, vidar.sonerud@gmail.com wrote:
> I have for a long time been wondering if it is possible to convert a 2
> disk Raid-1 array to a  3 disk Raid-5 array using mdadm?
> 
> Tonight I stumbled upon this article:
> 
> http://www.n8gray.org/blog/2006/09/05/stupid-raid-tricks-with-evms-and-mdadm/
> 
> Is this safe / ok to do? Any comments from you mdadm experts?

Yes, that should be safe - in principle.
I've never used EVMS tools so I cannot comment on the particular
commands that the article says to run.

I would do it with mdadm:

1/ stop the array
   mdadm -S /dev/md0
2/ Recreated as a RAID5 array
   mdadm -C /dev/md0 -l5 -n2 --assume-clean /dev/sda1 /dev/sdb1
3/ Add a spare
   mdadm /dev/md0 -a /dev/sdc1
4/ Grow the array
   mdadm -G /dev/md0 -n 3

all done.

Of course you have to change the device names to fit your hardware.

NeilBrown
