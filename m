From: danfisher@bwkip.com
Subject: Re: adding raid 1 to rh 7.1
Date: Wed, 30 Oct 2002 18:00:14 GMT
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200210301751.g9UHpCr31058@dc5.bwkip.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  One problem is you cannot mkraid when the drive is mounted.

So I tried using the root+root+boot-raid howto and going from non-raid to 
raid1.  I cannot get it to boot to the floppy after merging the kernel.
To install the kernel I just downloaded the kernel-2.4.9-34 and the new 
modutils-13-0.7 and did an rpm -Uvh and followed that how-to.  It installed 
ok .  Here is the error I am getting when I try booting with the floopy  after 
step 4.5.




md: export_rdev(hdb5)
md: considering hdb1 ...
md: adding hdb1 ...
md: created md1
md: bind<hdb1,1>
md: running: <hdb1>
md: hdb1's event counter: 000000002
md: RAID level 1 does not need chunksize! Continuing anyway.
request_module[md-personality-3]: Root fs not mounted
md.c: personality 3 is not loaded!
md :do_md_run() returned -22
md: md1 stopped.
md: unbind<hdb1,0>
md: export_rdev(hdb1)
md: ... autorun DONE.
NET4: Linux TCP/IP 1.0 for NET4.0
IP Protocols: ICMP,UDP, TCP, IGMP
IP: routing cache hash table of 2048 buckets, 16Kbytes
IP: Hash tables configured (established 16384 bind 16384)
Linux IP multicast router 0.06 plus PIM-SM
NET4: Unix domain sockets 1.0/SMP for Linux NET4.0
EXT2-fs: unable to read superblock
isofs_read_super: bread failed, dev=09:00, iso_blknum=16, block=32
Kernel panic: VFS: Unable to mount root fs on 09:00


Any help is appreciated

-Dan
PS:  I tried

<That kernel should include RAID support, you should not need to 
<recompile. Just set up the /etc/raidtab, then do mkraid /dev/md0 and you 
<should be up and running. Read the Software RAID FAQ (www.tldp.org) 
<and 
<it should make it very clear how to proceed.

<Cheers,
<Vlad


danfisher@bwkip.com wrote:

>I have a system up and running with RedHat 7.1 and need to raid it.  I
>don't know how to recompile the kernel to add raid support for raid 1.
>I am using the latest kernel 2.4.9-34.  Any help is appreciated.
>
>-Dan
>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>






---------------------------------------------
This message was sent using The Internet Place, Inc. Webmail.
http://www.internetplace.net/


