From: "Philippe De Muyter" <phdm@macqel.be>
Subject: Promise SuperSwap 1000 & linux software raid ?
Date: Wed, 24 Mar 2004 12:17:19 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200403241117.i2OBHJv06429@mail.macqel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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

- if we power up with two disks, and then replace one disk, the replaced disk
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

- the leds are not handled the way they are with the proprietary promise driver.

We currently use linux-2.4.21.

Thanks in advance.

Philippe De Muyter  phdm at macqel dot be  Tel +32 27029044
Macq Electronique SA  rue de l'Aeronef 2  B-1140 Bruxelles  Fax +32 27029077
