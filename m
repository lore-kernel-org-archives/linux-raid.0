From: Adriana Rasberry <adrianar@pacbell.net>
Subject: Software level 1 RAID issue
Date: Sun, 08 Jun 2003 14:13:38 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <01C32DC8.29C82EC0.adrianar@pacbell.net>
Reply-To: "razcon@pacbell.net" <razcon@pacbell.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi All,

I am still fighting my RAID 1 issue, the system still down.  Here is the 
status:

On Startup I get a Segmentation Fault as shown below:

"Setting default font      [OK]
               Welcome to /etc/rc.d/rc.sysinit: Line 70      49
segmentation fault LC_ALL=C grep -q Redhat ....etc
               Press I for interactive startup"


I am running Redht 9.0 with a Software raid level 1 on two IDE drives.

I can boot the system up in rescue mode and then have read only access to 
the system via /mnt/sysimage.
The raids seems to be synced and active but are now all in U_ mode.

Here is some of the config data:

/dev/hdb1 ext3 raid autodetect
/dev/hdb2 ext3 raid autodetect
/dev/hdb3 ext3 raid autodetect


md0  (hdb1 & hda1)
md1  (hda5 & hdb3)  (root)
md2 (hda2 & hdb2)  /home


I Attempted to follow the instructions in the Software-RIAD-HOWTO on 
recovery process but had the following issues, their does not seem to be a 
ckraid command on the system and when I go to run fsck the system reports a 
warning that the volume is mounted and that it is dangerous to run ckdsk 
while mounted (maybe it is ok, in that no services are running?).  If I 
fully un-mount the volume will I get an error like fstab or raidtab not 
found?

So, I am not sure how to fully un-mount the volumes needed to run the ckdsk 
(or even if ckdsk is what is needed). umount commands report that the 
volume is in use, so I assume that I need to do a raidstop then un-mount, 
or just have the system startup in rescue mode without mounting the 
volumes, but I do so will I get cannot find fstab or raidtab errors?

I believe that I need to run an fsck to resolve the Seg. fault issue, but 
have yet been able to do so.

Thanks in advance for any help that you can provide.

R,
Greg

