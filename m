From: "Sean R. Funk" <sfunk1x@gmail.com>
Subject: MDADM RAID 6 Bad Superblock after reboot
Date: Wed, 18 Oct 2017 18:14:36 +0000
Message-ID: <AA5FDF15-8966-4793-9215-2814C1A6848D@gmail.com>
References: <6a0f0e0b-6b03-8ec1-b02f-b17b0447aff8@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6a0f0e0b-6b03-8ec1-b02f-b17b0447aff8@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Hi there,

After attempting to add a GPU to a VM running on a CentOS 7 KVM host I
have, the machine forcibly rebooted=2E Upon reboot, my /dev/md0 raid 6 XFS
array would not start=2E

Background:

Approximately 3 weeks ago I added 3 additional 3TB HDD's to my existing
5 disk array, and grew it using the *raw* disks as opposed to the
partitions=2E Everything appeared to be working fine (raw disk was my
mistake, as it had been a year since I had expanded this array
previously, simply forgot steps) until last night=2E WHen I added the GPU
via VMM, the host itself rebooted=2E

Unfortunately, the machine has no network access at the moment and I can
only provide pictures of text from whats displayed on the screen=2E The
system is booting into emergency mode and its failing because the
/dev/md0 array isn't starting (and then NFS fails, etc)=2E

Smartctl shows no errors with any of the disks, and mdadm examine shows
no superblocks on the 3 disks I added before=2E The array is in the
inactive state, and it shows only 5 disks=2E

To add to that, apparently I had grown the cluster while SELinux had
been enabled as opposed to permissive - so there was a audit log of
mdadm trying to modify /etc/mdadm=2Econf=2E I'm guessing it was trying to
update the configuration file as to the drive configuration=2E

Smartctl shows each drive is fine, and the first 5 drives have equal
numbers of events=2E I'm presuming the data is all still intact=2E

Any advice on how to proceed? Thanks!
