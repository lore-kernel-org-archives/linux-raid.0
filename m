From: Zeno Davatz <zdavatz@generika.cc>
Subject: Re: Fatal: map file must be on the boot RAID partition
Date: 07 May 2003 19:46:11 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1052329570.1551.165.camel@zrr>
References: <1052325714.1551.137.camel@zrr> <3EB93BF5.4E3912EE@SteelEye.com>
	 <1052327381.649.140.camel@zrr>  <3EB93F4D.501B2106@SteelEye.com>
Reply-To: zdavatz@generika.cc
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EB93F4D.501B2106@SteelEye.com>
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 2003-05-07 at 19:15, Paul Clements wrote:
> Zeno Davatz wrote:
> 
> > Yes, ok. I did that but after a reboot 'df' gives me:
> > 
> > /dev/hdc2 instead of /dev/md0
> > 
> > Why would that be?
> 
> did you change your /etc/fstab? what does /proc/mdstat say?

Ok it worked YES!!

When I reboot 'df' now gives me:

/dev/md0

What I done:

lilo.conf:
disk=/dev/md0
boot=/dev/hda
root=/dev/hdc

I also done 

append="md=0,/dev/hda2,/dev/hdc2"

I am quite happy now, as I do not have to recompile the kernel.

Lets see what happens after Raidhodadd.

Thanks for your time and help.

Zeno

