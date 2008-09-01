From: Mike Myers <mikesm559@yahoo.com>
Subject: Re: [opensuse] Opensuse doesn't wait long enough for the disks to spin up before trying to configure raid
Date: Mon, 1 Sep 2008 12:20:46 -0700 (PDT)
Message-ID: <901830.6549.qm@web30803.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Anders Johansson <ajohansson@suse.de>, opensuse@opensuse.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok, well I had a chance to try out the longer MDADM_DEVICE_TIMEOUT delay parameter today (we had a power failure in the neighborhood that the UPS couldn't outlast).  It didn't make any difference.  The first time coming up, it tried to assemble the array before all the devices had been detected and created, and failed.  I manually entered the shell, and did a reboot, and the 2nd time every device was detected rapidly (presumably because the disks were already spun-up and online) and then it came up just fine.

I noted that after the initial md assembly attempted failed during the first attempt at startup, the EH process of discovering the disks (and presumably spinning them up) from the port multipliers was still going on.  Since a device is not created until the disk is spun up, the udev events did not appear to get triggered in such a way as for the mdadm to realize it had to wait.  When boot.md was hit, only the base 6 drives attached to the onboard SATA ports and one of the PMP's and it's associated drives were online and detected.  The 2nd and 3 PMP's and their associated disks did not complete their EH process (and then begin to create the devices for the actual disks) until after md had tried to assemble the disks.

So I must be looking for a different paramter to add a delay other than the md delays specified in /etc/sysconfig/mdadm.  Any ideas?

I have cc'd the linux-raid list on this as well.

Thanks,
Mike




----- Original Message ----
From: Anders Johansson <ajohansson@suse.de>
To: opensuse@opensuse.org
Sent: Saturday, August 30, 2008 12:33:54 PM
Subject: Re: [opensuse] Opensuse doesn't wait long enough for the disks to spin up before trrying to configure raid

On Saturday 30 August 2008 21:03:34 Mike Myers wrote:
> The bottom line is about half the time I try to boot the system, it fails
> and needs some console work before I can bring it up.  Does anyone know if
> there is a fixed time delay somewhere that waits for the disks to spin up
> or does it use a different way of telling if it's done?

I'm not sure what exactly is failing here. Once the disk identifies itself on 
the bus, a udev event causes the device node to get created. Does it get 
created?

What exactly is the error message when boot.lvm fails to assemble the logical 
volumes?

boot.md will wait 60 seconds for all udev events to get processed. Would it 
help to increase that (in /etc/sysconfig/mdadm, the value is 
MDADM_DEVICE_TIMEOUT)?

Otherwise, you have to let us know exactly where in the chain things fail

Anders
-- 
To unsubscribe, e-mail: opensuse+unsubscribe@opensuse.org
For additional commands, e-mail: opensuse+help@opensuse.org


      
