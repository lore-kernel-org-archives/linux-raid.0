From: "John P. Looney" <valen@tuatha.org>
Subject: Re: Problems with RAID1 on cobalt raq3
Date: Mon, 19 Aug 2002 15:08:16 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020819140815.GY26818@jinny.ie>
References: <200208172056.g7HKuHm05754@raq.iceblink.org> <1029624922.14769.119.camel@atherton>
Reply-To: valen@tuatha.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1029624922.14769.119.camel@atherton>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Aug 17, 2002 at 03:55:38PM -0700, Duncan Laurie mentioned:
> > [root@midir root]# raidhotadd /dev/md1 /dev/hda2                   
> > md: can not import hda2, has active inodes!
> > md: error, md_import_device() returned -16
> > /dev/md1: can not hot-add disk: invalid argument.

 I've just tryed to get RAID1 going on another non-cobalt host, and I seem
to be doing something simple wrong, as I get something quite similar here
too:

[root@jny02 /root]# raidhotadd  /dev/md0 /dev/hda5
/dev/md0: can not hot-add disk: invalid argument.
md: trying to hot-add hda5 to md0 ... 
md: can not import hda5, has active inodes!
md: error, md_import_device() returned -16
[root@jny02 /root]# mount
/dev/md0 on / type ext2 (rw)
none on /proc type proc (rw)
/dev/hda1 on /boot type ext2 (rw)
none on /dev/pts type devpts (rw,gid=5,mode=620)
 
 This is likely because to get it to boot, like the cobalt, I'm actually
passing root=/dev/hda5 to the kernel, not /dev/md0. 

 When I used "root=/dev/md0", the kernel booted, mounted root, and then
moaned that it couldn't find init (so I had to wonder what filesystem it
ended up mounting). I tryed to setup my lilo.conf from;
    http://www.tldp.org/HOWTO/mini/Boot+Root+Raid+LILO-5.html
but because I don't quite understand what it's doing, I could be doing
something wrong:

 My lilo.conf is:

boot=/dev/hda
map=/boot/map
install=/boot/boot.b
linear
disk=/dev/md0
    bios=0x80
    sectors=63
    heads=255
    cylinders=5005
partition=/dev/md1
    start=63
image=/boot/bzImage
    label=2.4.18
    read-only
    root=/dev/md0

 Is there anything obviously wrong with that ?
                                                        
John                                                    

