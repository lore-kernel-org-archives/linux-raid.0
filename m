From: Ken Walker <ken.walker@manchester.ac.uk>
Subject: my first raid disaster on reboot :o(
Date: Tue, 6 Sep 2005 14:25:41 +0100
Message-ID: <60F5F1E2B94AD4119F0B00B0D0215FFF01A69F90@bsc.tt.umist.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've got debian 3.1, kernel 2.6 installed on a machine with two 9.1g SCSI
and 4 160g IDE's.

The SCSI is split up into /  /usr  /var  /swap  /tmp  and /home, each set as
a raid1.

The IDE's are set up as raid1 on the ide channels, such that hda is mirrored
with hdc and hdb is mirrored with hdd.

I had to move the system today so powered down with shutdown -h now.

On reboot i just get / mounted ( i think ) and everything else says mdx
corrupt superblock or such and not a valid ext2 fs.

all the mirrors were set us as ext3 and when it was up and running
/proc/mdstat said all was well.

/etc/fstab has all the raids present.


I'm kinda stuck as to where to start.


Could anybody point me in the right direction please.

many thanks

Ken
