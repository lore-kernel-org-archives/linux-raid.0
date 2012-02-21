From: Phil Turmel <philip@turmel.org>
Subject: Re: Starting a RADI1 array after the filesystem has being used through
 LVM?
Date: Tue, 21 Feb 2012 07:27:17 -0500
Message-ID: <4F438DA5.6070209@turmel.org>
References: <4F42654B.8050407@agenda.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F42654B.8050407@agenda.si>
Sender: linux-raid-owner@vger.kernel.org
To: Danilo Godec <danilo.godec@agenda.si>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Danilo,

On 02/20/2012 10:22 AM, Danilo Godec wrote:
> Hello,
> 
> one of my servers uses two iSCSI volumes in a RAID1 array with LVM on
> top. Apparently the RADI1 array wasn't properly started on the last
> reboot, but LVM still detected both partitions on physical disks as
> PV's and simply used one of them (seen as /dev/sdb1).

I'm going to guess that you have meta-data v1.0, which starts the
raid content at block zero of the members of your raid1.  This makes
it possible to confuse an md device with a raw device.

> Unfortunately, this gone by unnoticed and has been runnig like that
> for some time.

Scary. But may I suggest tolerating the lack of redundancy just a little
longer to fix it permanently...
> 
> The size of the volume is 7TB (with 5TB used), so I'd like to do with
> as little downtime as possible.

This can be fixed with no downtime, since you chose (wisely, IMHO) to
layer LVM on top of your raid.
> 
> The question is - is it safe to simply stop LVM, start the array in
> degraded mode with the 'current' disk (/dev/sdb1), start LVM and then
> re-add the 'non-current' one (/dev/sda1)?
> 
> Also - how can I prevent LVM from using these two partitions
> directly? I'd rather see the server startup fail then silently do
> wrong...  I already have the 'md_component_detection = 1' option in
> my 'lvm.conf'.

You should have metadata v1.1 or v1.2 on this array.  The modern default
is v1.2.  This will prevent LVM from seeing the bare devices in the
future.

So, the procedure would be:

1) Create a new degraded md raid1 with the non-current device
    mdadm --create /dev/mdX --level 1 -n 2 --metadata=1.2 --bitmap=internal /dev/sda1 missing
2) Add the new array to your LVM setup with
    pvcreate /dev/mdX
    vgextend groupname /dev/mdX
3) Move the running volumes from one PV to the other within the group
    pvmove /dev/sdb1 /dev/mdX
4) Drop the old PV 
    vgreduce groupname /dev/sdb1
    pvremove /dev/sdb1
5) Add the old PV to the new array
    mdadm --zero-superblock /dev/sdb1
    mdadm /dev/mdX --add /dev/sdb1
6) Update mdadm.conf and your initramfs to reflect the new array.

Enjoy.

Do check that all device names in my instructions are correct, and pick
a suitable 'X' for /dev/mdX.

HTH,

Phil
