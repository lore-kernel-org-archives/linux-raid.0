From: Zeno Davatz <zdavatz@generika.cc>
Subject: Re: Fatal: map file must be on the boot RAID partition
Date: 07 May 2003 19:35:36 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1052328936.649.157.camel@zrr>
References: <1052325714.1551.137.camel@zrr> <3EB93BF5.4E3912EE@SteelEye.com>
	 <1052327381.649.140.camel@zrr>  <3EB93F4D.501B2106@SteelEye.com>
Reply-To: zdavatz@generika.cc
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EB93F4D.501B2106@SteelEye.com>
To: Linux-Raid <linux-raid@vger.kernel.org>
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
> did you change your /etc/fstab? 
Yes. I done

/dev/md0	/	default 0	0

but this give me a kernel panic if I set

root=/dev/md0 in my lilo.conf


> what does /proc/mdstat say?
I tells me that my raid is up and running:

Personalities : [linear] [raid1] [multipath]
read_ahead 1024 sectors
md0 : active raid1 ide/host0/bus0/target0/lun0/part2[0]
      76131968 blocks [2/1] [U_]
       
unused devices: <none>

I installed mdadm but it makes no difference.

Thanks for your time and help.

Zeno


