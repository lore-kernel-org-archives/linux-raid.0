From: Patrik Jonsson <patrik@ucolick.org>
Subject: mdadm --assemble weirdness?
Date: Tue, 28 Nov 2006 17:23:21 -0800
Message-ID: <456CE109.7000202@ucolick.org>
References: <1162293818.32109.113.camel@kenny> <17735.14472.835153.186432@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17735.14472.835153.186432@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I just got a new SATA controller and moved some of my drives around, so
the device numbers of course got all messed up. I expected mdadm to be
able to handle that, which it did when I moved one device. However, when
I moved the next 3, things got weird. Here's the output from mdadm
--assemble --scan -v:

... <removed unmatching devices>
mdadm: /dev/sdj1 is identified as a member of /dev/md5, slot 3.
mdadm: /dev/sdi1 is identified as a member of /dev/md5, slot 2.
mdadm: /dev/sdh1 is identified as a member of /dev/md5, slot 1.
mdadm: /dev/sdg1 is identified as a member of /dev/md5, slot 0.
mdadm: /dev/sdf1 is identified as a member of /dev/md5, slot 6.
mdadm: /dev/sde1 is identified as a member of /dev/md5, slot 7.
mdadm: /dev/sdd1 is identified as a member of /dev/md5, slot 9.
mdadm: /dev/sdc1 is identified as a member of /dev/md5, slot 8.
mdadm: /dev/sdb1 is identified as a member of /dev/md5, slot 5.
mdadm: /dev/sda1 is identified as a member of /dev/md5, slot 4.
mdadm: added /dev/sdh1 to /dev/md5 as 1
mdadm: added /dev/sdi1 to /dev/md5 as 2
mdadm: added /dev/sdj1 to /dev/md5 as 3
mdadm: added /dev/sda1 to /dev/md5 as 4
mdadm: added /dev/sdb1 to /dev/md5 as 5
mdadm: added /dev/sdf1 to /dev/md5 as 6
mdadm: added /dev/sde1 to /dev/md5 as 7
mdadm: added /dev/sdc1 to /dev/md5 as 8
mdadm: added /dev/sdd1 to /dev/md5 as 9
mdadm: added /dev/sdg1 to /dev/md5 as 0
mdadm: /dev/md5 assembled from 7 drives - not enough to start the array.

The added drives are the correct ones, but how it adds 10 drives but
then thinks that it's only assembled 7 mystifies me. Is this a bug?

Regards,

/Patrik

