From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: Partitioned raid and major number
Date: Wed, 25 Feb 2004 15:56:26 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040225145624.GA1513@cistron.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

	I see that Linus merged partitioned raid into bitkeeper.
The major number of partitioned raid devices is allocated dynamically.

I want to set up a server with 2 disks in RAID1 mode, partitioned.
To be able to boot from it, the RAID1 device needs to have a fixed
major number (I don't want to be forced to use an initrd). Is it
planned to ask LANANA for a fixed major number? If not, would a
patch to pass the major number on the kernel command line be accepted ?

Thanks,

Mike.
