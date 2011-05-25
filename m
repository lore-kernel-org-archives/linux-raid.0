From: John McMonagle <johnm@advocap.org>
Subject: Can not start md0 after upgrade.
Date: Wed, 25 May 2011 08:19:26 -0500
Message-ID: <201105250819.27372.johnm@advocap.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just upgraded a poweredge 1850 server from Debian lenny to squeeze and can not 
boot with the new 2.6.32 kernel.

From lspci  have this controller:
SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT 
Dual Ultra320 SCSI (rev 08)


Running mdadm raid with root on md0.

Normally run xen but all  info is for when running without xen.

I can still boot with the 2.6.26 kernel but not with the new 2.6.32 kernel.
Under 2.6.32 it fails to start md0.
in the busy box console 
Can see all the needed partitions.
What was sda and sdb are now sdb and sdc that should not matter??
mdadm.conf is:
DEVICE partitions
CREATE owner=root group=disk mode=0660 auto=yes
HOMEHOST <system>
MAILADDR xxxxx@advocap.org
ARRAY /dev/md0 level=raid1 num-devices=2 
UUID=6f744c89:d2578f95:c150b018:d9f789b1
ARRAY /dev/md1 level=raid1 num-devices=2 
UUID=7938d59c:28a69e5e:3facbdc2:12974557

raid1 mptbase mptscsih and mptspi module are loaded.
Looks right but does not start md0.

Any ideas?

Thanks

John
