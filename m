From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: booting into /dev/md0 after an upgrade to squeeze
Date: Mon, 18 Oct 2010 23:18:50 +0200
Message-ID: <20101018231850.46d1375c@atak.bl.pg.gda.pl>
References: <20101018201448.62a76ba6@atak.bl.pg.gda.pl>
	<4CBCA4AE.5020504@seoss.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CBCA4AE.5020504@seoss.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Small <tim@seoss.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tim Small said:     (by the date of Mon, 18 Oct 2010 20:49:02 +0100)

> On 18/10/10 19:14, Janek Kozicki wrote:
> > But, maybe do you have some experience with booting into raid1 /dev/md0
> > after upgrading to squeeze?
> >    
> 
> You can stop grub doing the root=uuid= thing by changing /etc/default/grub
> 
> If you can get someone to the keyboard, then you can probably get them 
> to edit what grub is using as a one-off - i.e. change the root=uuid=xxx 
> entry to root=/dev/md0 (or even just one half of the mirror if you need 
> to get it working, then you can fix it later)...
> 
> It's also worth checking the contents of /etc/mdadm/mdadm.conf is 
> sensible - maybe if you duplicated the partition (with dd maybe, if you 
> said you duplicated the UUID), then it contains an incorrect uuid= line?

yes I duplicated with dd. And at first grub2 was booting into that
duplicated copy. So I invoked:

  tune2fs /dev/sdd3 -U random

to change the uuid of that copied partition. And then it stopped
booting at all, read on.

> 
> If it's incorrect, you may need to regenerate the initramfs having 
> corrected it (a copy is placed in the initramfs files) with 
> "update-initramfs -k all -u"
> 
> In a similar situations, where I have no remote console (IPMI SoL, Intel 
> AMT etc.), I like to use "qemu -snapshot ..." to verify that a system 
> will boot up correctly by pointing it at the real hard disks (see recent 
> post to this list).

thanks for your help,

Now I visited this server and I managed to boot it by hand. But I'm
unable to reboot it correctly. here's what happens:

grub2 starts initrd, which in turn starts /dev/md1 and /dev/md2. Then
it fails to find root because it resides on /dev/md0.

While in initrd shell I am able to bring up /dev/md0 by:

  mdadm -Af /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdh1

Then I just press Ctrl-D to exit initrd shell, and it continues
booting into /dev/md0. And uuid of ext3 filesystem on /dev/md0
matches that which grub2 is looking for, so uuid is correct. The
problem is with /dev/md0 not starting up.

Now - why initrd manages to bring up even a complex raid6
on /dev/md2, but cannot bring up /dev/md0 which is a basic raid1 ?

Maybe it's that weird name 'backup':0  while other arrays have names
backup:1 and backup:2 ? I don't know why it's with those quotes. I
never defined this name, it was set automatically when creating that
array years ago.

Currently each time when it boots I must be there to bring
up /dev/md0 by hand. Then it works (until next reboot).


array -D printout:

backup:~# mdadm -D /dev/md0
/dev/md0:
        Version : 1.0
  Creation Time : Wed Oct 31 09:13:41 2007
     Raid Level : raid1
     Array Size : 979924 (957.12 MiB 1003.44 MB)
  Used Dev Size : 979924 (957.12 MiB 1003.44 MB)
   Raid Devices : 6
  Total Devices : 4
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Mon Oct 18 23:09:49 2010
          State : active, degraded
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

           Name : 'backup':0
           UUID : 75b0f878:79539d6c:eef22092:f47a6e6f
         Events : 3455506

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       6       8      113        1      active sync   /dev/sdh1
       7       8       17        2      active sync   /dev/sdb1
       5       8       33        3      active sync   /dev/sdc1
       4       0        0        4      removed
       8       8        1        5      active sync   /dev/sda1



and mdadm.conf:

backup:~# cat /etc/mdadm/mdadm.conf 
# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default, scan all partitions (/proc/partitions) for MD superblocks.
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE partitions

# auto-create devices with Debian standard permissions
CREATE owner=root group=disk mode=0660 auto=yes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR root

# definitions of existing MD arrays

# This file was auto-generated on Tue, 23 Oct 2007 22:18:08 +0200
# by mkconf $Id: mkconf 261 2006-11-09 13:32:35Z madduck $

# ARRAY /dev/md/0 level=raid1 metadata=1 num-devices=6 UUID=75b0f87879:539d6cee:f22092f4:7a6e6f name='backup':0
# ARRAY /dev/md/2 level=raid1 metadata=1 num-devices=6 UUID=4fd340a6c4:db01d6f7:1e03da2d:bdd574 name=backup:2
# ARRAY /dev/md/1 level=raid6 metadata=1 num-devices=6 UUID=22f22c3599:613d5231:d407a655:bdeb84 name=backup:1

ARRAY /dev/md/0 metadata=1.0 UUID=75b0f878:79539d6c:eef22092:f47a6e6f name='backup':0
ARRAY /dev/md/2 metadata=1.0 UUID=4fd340a6:c4db01d6:f71e03da:2dbdd574 name=backup:2
ARRAY /dev/md/1 metadata=1.1 UUID=22f22c35:99613d52:31d407a6:55bdeb84 name=backup:1
backup:~# 


any ideas?

I was trying to change the name from 'backup':0 to backup:0, but I
must be doing something wrong, or it's not possible. ... or do I have
to do this while assembling, and cannot do that on "live" array?


thank you for your time
-- 
Janek Kozicki                               http://janek.kozicki.pl/  |
