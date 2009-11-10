From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Known-good LSI PCIe SAS HBAs?
Date: Tue, 10 Nov 2009 16:54:33 +0000
Message-ID: <73e903670911100854o1b48380apb5b0a86c44ae9dcb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm looking to replace a problematic Marvell PCIe SAS JBOD controller
from Supermicro, type AOC-SASLP-MV8. (mdadm freaks out on it and the
controller drops the drives - there has been discussion of the problem
on the list. Seems to be a mvsas driver problem but seems to surface
only under mdadm use.)

It's a nice controller, but we have to get an array going, so I'm
shelving the Marvell card and getting a new one. I'll be using mdadm
raid5 / raid6 over the controller.

This one, LSI SAS 3081E-R, looks good with eight SAS ports for around $200:
http://www.lsi.com/storage_home/products_home/host_bus_adapters/sas_hbas/internal/sas3081e-r/index.html

I can't find anything concrete regarding Linux, but I did find a
known-good confirmation for Solaris/ZFS here:
http://jmlittle.blogspot.com/2008/06/recommended-disk-controllers-for-zfs.html

Can anyone confirm/deny that the PCIe JBOD controllers from LSI work
on Linux out of the box? Or give other recommendations for 8 port
controllers in the $150-$200 range? (Or thereabouts. It'd be great to
know about any known-good 4-port controllers for even up to $250.)

Thanks!

-- Kristleifur
