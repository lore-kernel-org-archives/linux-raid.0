From: Simon McNair <simonmcnair@gmail.com>
Subject: flummoxed why I can't umount my md device.  fuser and lsof show no
 files locked
Date: Mon, 20 Jun 2011 18:48:40 +0100
Message-ID: <4DFF87F8.8050202@gmail.com>
Reply-To: simonmcnair@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi all,
A colleague of mine questioned the fact that I created my raid array 
using the command 'mkfs -t ext4 -v -m .1 -b 4096 -E 
stride=16,stripe-width=144 /dev/md0'.  He said that "When creating file 
systems on lvm or md volumes, |mkfs.ext4| chooses an optimal geometry."

I wanted to run 'mkfs.ext4 -n /dev/md0' to see what settings it would 
choose that were different to mine but it keeps saying:
"/dev/md0 is apparently in use by the system; will not make a filesystem 
here!".

I also can't stop the array using 'mdadm --stop /dev/md0' as it says 
mdadm: failed to stop array /dev/md0: Device or resource busy.  pretty 
much the same error occurs when trying lvchange -an /media/local/Raid

I've no problem with any of this except I can't find out what process 
has a handle on the mount and/or why.  so I can't stop/kill it.

I tried lsof | grep /media/local/Raid and fuser -m /media/local/Raid to 
no avail.  I also tried ps aux | grep Raid.  I've stopped pretty much 
everything in init.d including samba,nfs,mediatomb,squeezebox and 
anything I can think of that I've installed.

Any advice/ideas please ?

cheers
Simon



