From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: mdadm: use static major/minor numbers.
Date: Tue, 20 Nov 2012 12:36:52 +0000
Message-ID: <50AB7964.60002@mpstor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

I recently updated mdadm-2.6.9 to mdadm-3.2.6 on a system (own busybox 
based distro) that had its kernel version updated from 2.6.35 to 3.4.

Everything works well apart from a feature I used that I seem to be 
unable to reactivate:

In the past, to ensure knowing the number of possible RAID devices that 
could be created on the system, I used static major:minor mappings by 
building the /dev/md/dXX and /dev/md/dXXpXX entries (with major 254, and 
three minors for each device for 3 partitions), allowing me to be 
certain that 64 RAID devices could be created at all times.

When creating an array, the /dev/md/dXX and dXXpXX devices "nodes" would 
be used (not recreated) and the major/minor number these devices point 
to would be used for the actual MD block device.

This was a very handy feature. With the latest mdadm, I simply cannot do 
that, as creating a /dev/md/dXX will in fact remove that device file and 
symlink it to /dev/md_dXX. I then created /dev/md_dXX devices prior to 
creating an array, and got the following error message: "mdadm: 
/dev/md_d3 exists but looks wrong, please fix".

Looking through the source I can see that mdadm basically verifies if 
the file's major/minor matches the one that it had planned for the 
device, which in this case doesn't.

Is there any way to work around that? Or in fact, I don't actually 
*need* to use static major/minor numbers, but I need to know in advance 
how many RAIDs I'll be able to create provided I'll always use 2 
partitions for them and can provide the -amdp2 argument to mdadm to make 
sure that only 2 partitions devices nodes are created.

Is there a way to know the maximum number of RAIDs that can be created, 
provided that nothing else uses major 9 and 254?

Thank you very much in advance for your help!

Regards,
Ben.
