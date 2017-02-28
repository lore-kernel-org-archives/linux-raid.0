From: Mattias Wadenstein <maswan@acc.umu.se>
Subject: Performance regression with HP HW raid (hpsa) between 3.18.21 and
 3.18.22 (and later)
Date: Tue, 28 Feb 2017 14:38:48 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1702281413390.19268@stalin.acc.umu.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: christian.ehrhardt@canonical.com, esc.storagedev@microsemi.com
List-Id: linux-raid.ids

Hi!

We recently noticed a big performance hit when upgrading distro kernel 
versions (Ubuntu trusty->xenial) for bulk io ("dd if=/dev/zero of=/dev/sdb 
bs=256k" as easy reproducable case), performance dropping from 1.8GB/s to 
0.6GB/s on our raidsets. With some fiddling we found this to come from a 
change between mainline kernels 3.18.21 and 3.18.22.

Christian Erhardt of helpful Ubuntu support helped pin this down to a 
particular change where newer kernels trust what the HW raid controller 
advertises for max_sectors_kb, even though it seems like the controller 
doesn't like getting big merged IOs larger than 1024k.

Our discussion, data and conclusion is documented in:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1668557

Posting here to raise some awareness and maybe providing some feedback to 
relevant maintainers for how to handle this case, where the hardware raid 
controller seems to be able to technically handle large IOs, but at a 
significant performance hit.

We're applying the workaround of capping max_sectors_kb to something 
performance-sensible like the old value of 512, and hopefully this mail 
can help someone else facing the same issues.

/Mattias Wadenstein
