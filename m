From: Steve Witt <sawitt@electra.rsc.raytheon.com>
Subject: /dev/md* Device Files
Date: Tue, 25 Jan 2005 14:54:05 -0800 (PST)
Message-ID: <Pine.LNX.4.61.0501251445420.6553@electra.rsc.raytheon.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm installing a software raid system on a new server that I've just 
installed Debian 3.1 (sarge) on. It will be a raid5 on 5 IDE disks using 
mdadm. I'm trying to create the array with 'mdadm --create /dev/md0 ...' 
and am getting an error: 'mdadm: error opening /dev/md0: No such file or 
directory'. There are no /dev/md* devices in /dev at the present time. I 
do have the md and raid5 kernel modules loaded. My question is: how do the 
/dev/md* files get created? Are they normal device file that are created 
with MAKEDEV?

Thanks...

