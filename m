From: dean gaudet <dean@arctic.org>
Subject: Re: md autodetect only detects one disk in raid1
Date: Sat, 27 Jan 2007 13:39:52 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0701271333440.1763@twinlark.arctic.org>
References: <1169923959.18828.41.camel@duo>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1169923959.18828.41.camel@duo>
Sender: linux-raid-owner@vger.kernel.org
To: kenneth johansson <ken@kenjo.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

take a look at your mdadm.conf ... both on your root fs and in your 
initrd... look for a DEVICES line and make sure it says "DEVICES 
partitions"... anything else is likely to cause problems like below.

also make sure each array is specified by UUID rather than device.

and then rebuild your initrd.  (dpkg-reconfigure linux-image-`uname -r` on 
debuntu).

that "something else in the system claim use of the device" problem makes 
me guess you're on ubuntu pre-edgy... where for whatever reason they 
included evms in the default install and for whatever inane reason evms 
steals every damn device in the system when it starts up.  
uninstall/deactivate evms if you're not using it.

-dean

On Sat, 27 Jan 2007, kenneth johansson wrote:

> I run raid1 on my root partition /dev/md0. Now I had a bad disk so I had
> to replace it but did not notice until I got home that I got a SATA
> instead of a PATA. Since I had a free sata interface I just put in in
> that. I had no problem adding the disk to the raid1 device that is until
> I rebooted the computer. 
> 
> both the PATA disk and the SATA disk are detected before md start up the
> raid but only the PATA disk is activated. So the raid device is always
> booting in degraded mode. since this is the root disk I use the
> autodetect feature with partition type fd.
> 
> Also Something else in the system claim use of the device since I can
> not add the SATA disk after the system has done a complete boot. I guess
> it has something to do with device mapper and LVM that I also run on the
> data disks but I'm not sure. any tip on what it can be??
> 
> If I add the SATA disk to md0 early enough in the boot it works but why
> is it not autodetected ?
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
