From: "Customer Service" <it4soho@it4soho.com>
Subject: RE: Promise SuperSwap 1000 & linux software raid ?
Date: Fri, 26 Mar 2004 13:06:08 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <IKEGIEMOLKKHNAHLOLIDCEONCAAA.it4soho@it4soho.com>
References: <200403241117.i2OBHJv06429@mail.macqel.be>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200403241117.i2OBHJv06429@mail.macqel.be>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Phillipe (et. al)...

The Linux drivers for ATA-RAID do not support the hot-swap and hot-rebuild
feature of the Promise SuperSwap line of ATA drive trays -- only the Promise
provided drivers can do that (see
http://www.promise.com/support/download/download2_eng.asp?productId=88&categ
ory=driver&os=3 )

The problem with these drivers is that they are generally tied to the
original kernel release of the RHL kernels. However, there is a way to
force-load the driver with later kernel releases (see the HOWTO here:
http://www.tldp.org/HOWTO/Linux-Promise-RAID1-HOWTO/modinstall.html )

Also note that the Linux kernel raid cannot be mixed with the Promise
drivers... so some care is necessary (I think it is nicely covered in the
above howto)

I use the Promise driver over the kernel driver for precisely the reason you
have inquired -- the hot rebuild capability. Good luck with your use of this
information!!!

Best Regards,

Dan McAllister, President
IT4SOHO, LLC

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org]On Behalf Of Philippe De Muyter
Sent: Wednesday, March 24, 2004 6:17 AM
To: linux-raid@vger.kernel.org
Subject: Promise SuperSwap 1000 & linux software raid ?


Sorry to disturb you.

I have found this mail address when searching for information on experience
with the promise superswap 1000 ide hot swap enclosure on linux.

We have superswap 1000 enclosure here with fasttrak tx 2000 pci card, and
I would like to use that with the software raid system of linux.   My users
request hot-swap capability, with no human intervention to initiate
reconstruction.  We need raid1 (mirroring).

How can that be achieved ?

I already tried myself, but we have several problems :

- if we power up the computer with only one disk, linux will not see the
second disk when it is inserted.

- if we power up with two disks, and then replace one disk, the replaced
disk
is not initialized correctly (slow transfer e.g.) and mdadm does not see
that the disk is back.  We must manually issue the following script to
initiate a reconstruction :

	    mdadm -r /dev/md1 /dev/hdg2
	    mdadm -r /dev/md0 /dev/hdg1
	    sfdisk -d /dev/hde > /tmp/partitions.hdg
	    hdparm -w /dev/hdg
	    hdparm -d 1 /dev/hdg
	    hdparm -m 16 /dev/hdg
	    sfdisk /dev/hdg < /tmp/partitions.hdg
	    mdadm -a /dev/md0 /dev/hdg1
	    mdadm -a /dev/md1 /dev/hdg2

- the leds are not handled the way they are with the proprietary promise
driver.

We currently use linux-2.4.21.

Thanks in advance.

Philippe De Muyter  phdm at macqel dot be  Tel +32 27029044
Macq Electronique SA  rue de l'Aeronef 2  B-1140 Bruxelles  Fax +32 27029077
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

