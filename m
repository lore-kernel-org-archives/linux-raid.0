From: seth vidal <skvidal@phy.duke.edu>
Subject: Re: raid 0 on different size devices?
Date: 19 Nov 2003 15:05:11 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1069272311.6952.36.camel@opus>
References: <Pine.LNX.4.44.0311191300350.6810-100000@eglifamily.dnsalias.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0311191300350.6810-100000@eglifamily.dnsalias.net>
To: Dan Egli <dan@eglifamily.dnsalias.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> How do I setup a linear array?

a raidtab for use with mkraid might look something like this:
raiddev             /dev/md0
raid-level                  linear
nr-raid-disks               2
chunk-size                  32
persistent-superblock       1
    device          /dev/hda1
    raid-disk     0
    device          /dev/hdc1
    raid-disk     1


or you can use mdadm -C -llinear etc etc etc - man mdadm for complete
options.

-sv


