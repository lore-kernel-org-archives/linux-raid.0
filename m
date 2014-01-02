From: pg@lxraid2.for.sabi.co.UK (Peter Grandi)
Subject: Re: The chunk size paradox
Date: Thu, 2 Jan 2014 23:22:46 +0000
Message-ID: <21189.62662.712801.352081@tree.ty.sabi.co.uk>
References: <52C1C01A.7010407@ubuntu.com>
	<52C57C7B.80400@shiftmail.org>
	<52C588A7.6010207@hardwarefreak.com>
	<52C59468.6080200@ubuntu.com>
	<52C5A9AA.9090300@hardwarefreak.com>
	<52C5BC28.2020003@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C5BC28.2020003@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

> 512 byte sector native drives are now far less common,

Most smaller/faster SAS drivers still have 512 physical sectors,
but >= 2TB drives, especially those with < 7200RPM, tend to have
4KiB physical sectors (because 4KiB sector drives are cheaper).

> with many of the drives being native 4096 bytes witnh a
> translation layer for legacy systems that require 512 bytes.

On a PC here I have half-and-half:

  # lsscsi | grep sd.
  [0:0:0:0]    disk    ATA      WDC WD2002FAEX-0 05.0  /dev/sda
  [1:0:0:0]    disk    ATA      ST2000DM001-1CH1 CC44  /dev/sdb
  [2:0:0:0]    disk    ATA      ST2000DM001-9YN1 CC4C  /dev/sdc
  [3:0:0:0]    disk    ATA      Hitachi HDS72202 JKAO  /dev/sdd
  [6:0:0:0]    disk    ATA      WDC WD20EARX-32P AB51  /dev/sde
  [6:0:1:0]    disk    ATA      ST2000DL003-9VT1 CC32  /dev/sdf

  # grep . /sys/block/sd?/queue/physical_block_size
  /sys/block/sda/queue/physical_block_size:512
  /sys/block/sdb/queue/physical_block_size:4096
  /sys/block/sdc/queue/physical_block_size:4096
  /sys/block/sdd/queue/physical_block_size:512
  /sys/block/sde/queue/physical_block_size:4096
  /sys/block/sdf/queue/physical_block_size:512

They are all 2TB "consumer" drives, mostly recent ones. I am
slightly surprised that half still have 512 physical sectors.

[ ... ]
