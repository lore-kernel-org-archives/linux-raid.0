From: Henrik Holst <henrik.holst@idgmail.se>
Subject: Re: Ubuntu - RAID Array not "assembling" on boot.
Date: Tue, 21 Nov 2006 21:13:00 +0100
Message-ID: <45635DCC.3010500@idgmail.se>
References: <1164139592.12278.276853539@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1164139592.12278.276853539@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Reeves <john.reeves@mailc.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Reeves wrote:
> Hey,
> 
> Having a great deal of difficulty getting my 3 disk RAID 5 array to
> reappear on restart, Ubuntu 6.10.  Here's the contents of my
> /etc/mdadm/mdadm.conf file:
> 
> ARRAY /dev/md0 level=raid5 num-devices=3
> UUID=6a9a102a:101addd2:f95758f6:11ac6d3c 
> 
> Obviously /dev/md0 does not "appear" on restart, the only way I can get
> the RAID Array to assemble is to issue the following:
> 
> mknod -m 0660 /dev/md0 b 9 0
> mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1
> 
> I can add these lines to my /etc/init.d/bootmisc.sh which does work, but
> seeing as I'm not 100% sure what the mknod command is doing, and the
> fact that I'm pretty sure that this is not the way it's mean to be... 
> (the mknod is required, or mdadm complains that /dev/md0 does not
> exist).  
> 
> I'm nearly tearing my hair out over this one, so if someone could be of
> assistance I would be greatly appreciative.

Try "dpkg-reconfigure mdadm" as root. Under Debian this will give you
the chance to configure the startup configuration for all software raids
in the system. Under any cirtumstances you should not have to use mknod.
Instead try adding the --auto=yes switch to mdadm. Then mdadm will
create the node itself.

/Henrik Holst

