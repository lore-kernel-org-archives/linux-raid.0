From: Alvin Oga <aoga@Maggie.Linux-Consulting.com>
Subject: Re: Raid1 fast resync
Date: Thu, 2 Jan 2003 01:44:33 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.3.96.1030102013608.31808A-100000@Maggie.Linux-Consulting.com>
References: <3E130F39.3000706@attbi.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E130F39.3000706@attbi.com>
To: Philip Cameron <pecameron@attbi.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


hi ya philip

On Wed, 1 Jan 2003, Philip Cameron wrote:

> Do any of you know of work that is going on to improve the raid 1 resync 
> speed? I am starting to evaluate approaches to reducing the time to 
> resync the disks.
> 
> I am involved in a project on a fault tolerant x86 based server that has 
> hot plugable scsi disks and PCI busses. There are two PCI busses and 3 
> mirrrored sets of two disks. When a PCI bus is pulled all of the mirrors 
> are broken so when the PCI bus is again inserted, all of the disks 
> resync which takes hours. Also, during development the resync after 
> crash really slows down debug.

without knowing more details ... here's some comments

- when a pci card is pulled out, you stand a good chance that the cpu bios
  will need to be reset ( re-saved )
	- the machine goes into bios mode, whether you like it or not

- since you are using scsi disks..
	- when you pull out a scsi disk, the next time you reboot,
	the scsi drives will be in different order if you lost sda
	or lost sdb and you had sdc  which is now your new sdb

- if you have 2 pci buses...
	- put sda  on pci #1
	and put sdb ( mirrored ) onto pci #2

	- if any pci buss dies, your system can still function properly
	since its mirror is on the other pci buss which is working

- to avoid resyncing the raid data...
	- use a 3rd (spare) disk local to the 2 disks
	when one disk dies, the spare supposed to kick-in 

	- have a spare system, that mirror's the "main" data,
	and rebuild a spare disk on a constant basis so that
	the "spare" can be plugged into the "main" data asap
	whenver a disk dies that didnt have a spare previously

	- when resyncing... you only need to "resync changed data"
	( changed/new files for today ) and NOT the whole array
	which might have a year's worth of data..

	- yesterday's hot swap ( spare ) is ready to go anytime

- if you want more raid interactivity and keyboard/ssh control,
  renice the apps and raid parameters

have fun
alvin

