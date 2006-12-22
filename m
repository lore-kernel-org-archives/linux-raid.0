From: Don Hiatt <Don_Hiatt@pmc-sierra.com>
Subject: RE: list of devices that belong to an array
Date: Fri, 22 Dec 2006 15:36:33 -0800
Message-ID: <5C1FD43E5F1B824E83985A74F396286E03EA2B37@bby1exm08.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Don Hiatt <Don_Hiatt@pmc-sierra.com>
List-Id: linux-raid.ids


> 
> Secondly, given a device that is part of an array, is there a way to 
> figure out all the other components if you are using the 1.2 superblock?
> uuid=`mdadm -Eb $DEV | sed -ne 's/.* \(UUID=[^ ]*\).*/\1/p'` mdadm -Esv | grep -B1 $uuid | grep devices=

Yes, but wouldn't this only tell me about the devices that are currently in the system
and but not *all* the devices that make up the array? For example:

  * say a RAID is composed of /dev/sata[1-4]

  * If I use the "-ESv" option with all devices installed (they are hotplugged) then
    it will list "devices=/dev/sata3,/dev/sata4,/dev/sata1,/dev/sata2"

  * However, say I pull /dev/sata2 and repeat the command, all I will see is:
    "devices=/dev/sata3,/dev/sata4,/dev/sata1"

What I am trying to do is determine if all the devices are present in the system 
before I attempt to startup the RAID. I know I can use "--no-degraded" to get the
similiar behaviour but I'd like to be able to determine component list outside of
this mechanism.


>The information you get with 0.90 is the names the devices had last time the array was assembled, which might 
>still be correct, or might not.  Unreliable information can be worse than no information.

Thanks for the clarification and I couldn't agree more about the unreliable information
statement. :)

Thank you very much for your time!

Cheers,

don

