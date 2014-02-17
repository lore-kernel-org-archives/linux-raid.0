From: Phil Turmel <philip@turmel.org>
Subject: Re: AW: QNAP 8 port RAID5 md0 recovery of missing MBR and md superblocks
Date: Mon, 17 Feb 2014 08:47:17 -0500
Message-ID: <530212E5.2030003@turmel.org>
References: <52CBF747.7020505@epos-cat.de> <A2EC67620EC7424F9EC3DD49243E9060466DC09B@AUDIINSX0328.audi.vwg> <A2EC67620EC7424F9EC3DD49243E9060466EC018@AUDIINSX0328.audi.vwg>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A2EC67620EC7424F9EC3DD49243E9060466EC018@AUDIINSX0328.audi.vwg>
Sender: linux-raid-owner@vger.kernel.org
To: "Samer, Michael (I/ET-83, extern)" <extern.michael.samer@audi.de>, "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Good morning Michael,

On 02/17/2014 08:33 AM, Samer, Michael (I/ET-83, extern) wrote:
> Greetings to all
> 
> As my thread from the 6.2.2014 didn't bring any hint or any reply or way out, I need advise if my way is approved:

I travel a lot, and didn't see your posts.  Help from someone usually
pops up.  Sorry it didn't work that way for you.

Anyways, it means I don't have your initial report.  Please show "mdadm
-E /dev/sd[a-z]3".

mdadm --create --assume-clean is a terrible solution, except when its
the right one.  I'd like to make sure.

> I reconstructed the part table (testdisk import from a working disk) and now I'm only missing the md superblock on three disks (sdb3/sdf3/sdg3) for my md0 integrity.
> 
> I'd do the following:
> 
> a) "mdadm --stop /dev/md0"
> 
> b) "mdadm --create --assume-clean --verbose --force --run /dev/md0 --level=5 --raid-devices=8 /dev/sda3 missing /dev/sdc3 /dev/sdd3 /dev/sde3 /dev/sdf3 /dev/sdg3 /dev/sdh3"

Device order matters--it must match the device roles in the --examine
reports.  If three devices have no metadata, you might have to do this
step multiple times with different combinations.  (Never writing to the
array until you find the right one.)

> or to include the "most datas available" version
> c) "mdadm --create --verbose --assume-clean /dev/md0 --level=5 --raid-devices=8 /dev/sd{a,b,c,d,e,f,g,h}3"
> to gather at least the older layout & data

No, leave out the drive that dropped out first.

> d) "fsck.ext4 /dev/md0" on the array afterwards

"fsck -n" first to make sure of the device order.

HTH,

Phil
