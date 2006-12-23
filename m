From: Neil Brown <neilb@suse.de>
Subject: RE: list of devices that belong to an array
Date: Sat, 23 Dec 2006 11:03:13 +1100
Message-ID: <17804.29249.402037.648763@cse.unsw.edu.au>
References: <5C1FD43E5F1B824E83985A74F396286E03EA2B37@bby1exm08.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Don Hiatt on Friday December 22
Sender: linux-raid-owner@vger.kernel.org
To: Don Hiatt <Don_Hiatt@pmc-sierra.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday December 22, Don_Hiatt@pmc-sierra.com wrote:
> 
> > 
> > Secondly, given a device that is part of an array, is there a way to 
> > figure out all the other components if you are using the 1.2 superblock?
> > uuid=`mdadm -Eb $DEV | sed -ne 's/.* \(UUID=[^ ]*\).*/\1/p'` mdadm -Esv | grep -B1 $uuid | grep devices=
> 
> Yes, but wouldn't this only tell me about the devices that are currently in the system
> and but not *all* the devices that make up the array? For example:
> 
>   * say a RAID is composed of /dev/sata[1-4]
> 
>   * If I use the "-ESv" option with all devices installed (they are hotplugged) then
>     it will list "devices=/dev/sata3,/dev/sata4,/dev/sata1,/dev/sata2"
> 
>   * However, say I pull /dev/sata2 and repeat the command, all I will see is:
>     "devices=/dev/sata3,/dev/sata4,/dev/sata1"

What else could it say?  /dev/sata2 does not exist, there is no such
thing at this point in time, so telling you that it is part of an
array is meaningless....

> 
> What I am trying to do is determine if all the devices are present in the system 
> before I attempt to startup the RAID. I know I can use "--no-degraded" to get the
> similiar behaviour but I'd like to be able to determine component list outside of
> this mechanism.

Well... If you do
   mdadm -E $DEV | grep 'Array Slot'
you get something like:

    Array Slot : 2 (0, 1, 2, 3, failed, 4)

So this device has Array Slot of '2', and you should expect to see
devices with Array Slots of 0, 1, 2, 3, 5 (The positions of the
non-failed entries in the list).
Once you have found all those devices, you know you have them all.

What exactly are you trying to do?   Have you looked at the new "-I"
mode.  It automagically starts an array once all expect devices are
present. 

NeilBrown
