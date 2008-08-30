From: "David Lethe" <david@santools.com>
Subject: Re: Linux tries to bring up raid before the disks are finished initializing
Date: Sat, 30 Aug 2008 16:21:00 -0500
Message-ID: <271601c90ae6$5c615209$5001a8c0@exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Myers <mikesm559@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Most mobos and controllers have a spinup delay settting exactly for this purpose.   increase the setting so that you allow sufficient time for everything to spin up before your system starts booting the OS.

-----Original Message-----

From:  "Mike Myers" <mikesm559@yahoo.com>
Subj:  Linux tries to bring up raid before the disks are finished initializing
Date:  Sat Aug 30, 2008 2:18 pm
Size:  1K
To:  "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>

I've sent this to the OpenSUSE list too, but thought I might ask here to as it is really linux raid question: 
 
I have a Opensuse 11.0 system running as a server with about 18 
data disks hooked to the local motherboard SATA ports, and 3 SATA port 
multipliers hooked to a Adaptec 1430SA controller.  Because of how the 
PMP code works (all the EH stuff resetting the PMP port, reseting the PMP, etc..., etc, and how long it takes to spin up each disk on boot, it can take 
awhile before the disks are all spun up and online.  About half the 
time I boot the system, linux  thinks the disks are already up and 
proceeds to run the /etc/init.d/boot.md and boot.lvm files, which of 
course fail to assemble the disks because they haven't fully come 
online yet, and dumps me into a single-user mode shell to fix the disks. 
 
The bottom line is about half the time I try to boot the system, it 
fails and needs some console work before I can bring it up.  Does 
anyone know if there is a fixed time delay somewhere that waits for the 
disks to spin up or does it use a different way of telling if it's done? 
 
A few details: Kernel is 2.6.26.3, 6 SATA ports on the ICH10R (1 is the dystem disk), 1 Adaptec 1430SA with 4 ports, and 3 3726 PMP's hooked to 3 of the 4 ports, and 2 SI3132 controllers with nothing currently hooked to them. 
 
Thanks, 
Mike 
 
 
       
-- 
To unsubscribe from this list: send the line "unsubscribe linux-raid" in 
the body of a message to majordomo@vger.kernel.org 
More majordomo info at  http://vger.kernel.org/majordomo-info.html 
 


