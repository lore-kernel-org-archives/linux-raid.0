From: Peter Mairhofer <63832452@gmx.net>
Subject: BUG?: MD UUIDs changed?
Date: Sun, 03 May 2009 13:49:19 +0200
Message-ID: <gtk0c2$in4$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a Software RAID 1 with Debian lenny (2.6.26) on the top if two 
1GB RAID disks (Promise SATA300 TX2). I build three MDs (all RAID1) with 
the following commands:

# mdadm --create /dev/md0 --verbose --level=1 --raid-devices=2 /dev/sda1 
/dev/sdb1
# mdadm --create /dev/md1 --verbose --level=1 --raid-devices=2 /dev/sda2 
/dev/sdb2
# mdadm --create /dev/md2 --verbose --level=1 --raid-devices=2 /dev/sda3 
/dev/sdb3

(md0 = Linux root, md1 = data (LVM), md2=swap)
Finally, I saved the configuration with:

# mdadm --examine --scan >> /etc/mdadm/mdadm.conf
# cat /etc/mdadm/mdadm.conf
[...]
ARRAY /dev/md0 level=raid1 num-devices=2 
UUID=a17a69b8:8fffe883:f742d439:f75daca2
ARRAY /dev/md1 level=raid1 num-devices=2 
UUID=97b4ff9d:246a656e:27cc7924:96506d18
ARRAY /dev/md2 level=raid1 num-devices=2 
UUID=b9b6b4d8:ad052c30:dde8335f:840c6bd3

Well, everything worked fine.

But then I wanted to test my SATA RAID and did the following:

1.) Just plugged off one drive (sda)
2.) MDs were in the [_U]-state (/proc/mdstat)
3.) I made an SCSI bus-rescan

Now I wanted to readd the the "failed" drive:

4.) plugged in the drive again
5.) I made an SCSI bus-rescan
6.) the drive appeared as sdd
7.) Removed the failed drives:
     # mdadm --manage /dev/md0 --remove failed
     # mdadm --manage /dev/md1 --remove failed
     # mdadm --manage /dev/md2 --remove failed
8.) added the new (old) ones:
     # mdadm --manage /dev/md0 --add /dev/hdd1
     # mdadm --manage /dev/md1 --add /dev/hdd2
     # mdadm --manage /dev/md2 --add /dev/hdd3

The MDs were rebuilt successfully and now I have [UU]-states again.

But suddenly the UUIDs have changed! In my optinion this should not 
happen because I did not recreate the MDs! I just removed and added 
devices. As you can see, the UUID changed compared to the output above:

# mdadm --examine --scan
ARRAY /dev/md0 level=raid1 num-devices=2 
UUID=ecd91936:b1a55e83:84db6932:6eb15673
ARRAY /dev/md1 level=raid1 num-devices=2 
UUID=97b4ff9d:246a656e:27cc7924:96506d18
ARRAY /dev/md2 level=raid1 num-devices=2 
UUID=8e413e87:bd062cc3:82a1dfb2:c7b8d31a

The very vers strange thing: Only the UUIDs from md0 and md2 changed!

The first question: Why did this happen? Should this ever happen? What 
went wrong? Is this a bug?

The second question: Should I rewrite the mdadm.conf with the new UUIDs?

Regards,
Peter


