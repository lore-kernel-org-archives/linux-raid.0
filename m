From: Tregaron Bayly <tbayly@bluehost.com>
Subject: Re: Disable raid auto assemble at boot
Date: Fri, 31 May 2013 12:04:43 -0600
Message-ID: <CE1B4262-7C89-44F8-B8CC-3E296EB78935@bluehost.com>
References: <CAGmni9prcynqMeprE3Nmjzkn2QgTkeHPxq=qSGzQBrt_bAziCQ@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGmni9prcynqMeprE3Nmjzkn2QgTkeHPxq=qSGzQBrt_bAziCQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Salatiel Filho <salatiel.filho@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

If you wish to stop the assembly permanently you could blacklist the kernel module, but it doesn't sound like this is your intention.

Your arrays might be assembled either in the initial ramdisk (less likely since your root filesystem is not raid) or by udev once the root filesystem is mounted.

udev seems more likely to me based on how it started when you changed metadata versions to one that places the superblock at the beginning of the device.  This may make it so that blkid understands this is raid and udev invokes a rule to assemble.  A quick experiment could be disassembling the arrays and then running 'udevadm trigger'.  If your arrays are assembled then you know to inspect your udev rules to find exactly where this is happening and perhaps insight into how to control it.

hth,

Tregaron

On May 31, 2013, at 11:26 AM, Salatiel Filho <salatiel.filho@gmail.com> wrote:

> Could anyone tell me how can i avoid the auto assemble of my raid
> device during boot?
> I am running:
> debian 7.0 with kernel 3.9.3-amd64
> 
> #cat /proc/cmdline
> BOOT_IMAGE=/vmlinuz-3.9.3-amd64 root=/dev/sda2 ro quiet panic=3
> raid=noautodetect
> 
> #cat /etc/mdadm/mdadm.conf
> CREATE owner=root group=disk mode=0660 auto=yes
> HOMEHOST <system>
> MAILADDR root
> ARRAY /dev/md/md1 metadata=1.2 name=zotac:md1
> UUID=082dc730:aedd3e21:1820edc4:6f20acd0
> ARRAY /dev/md/md0 metadata=1.2 name=zotac:md0
> UUID=d260f467:92241c75:0c742da1:8af824f6
> 
> 
> both /etc/init.d/mdadm and /etc/init.d/mdadm-raid are disabled.
> 
> all raid components are set to FD type.
> 
> And somehow the array is always assembled at boot.
> I started notice this 'forced auto assemble' after replace the 0.9
> metadata to 1.2 metadata.
> 
> Thanks !
> 
> 
> 
> 
> 
> []'s
> Salatiel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
