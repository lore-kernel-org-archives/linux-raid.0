From: Neil Brown <neilb@suse.de>
Subject: Re: hangs with 2.6.15-rc5
Date: Wed, 21 Dec 2005 12:14:17 +1100
Message-ID: <17320.44137.337545.50069@cse.unsw.edu.au>
References: <E1Eoqi0-0000FX-Im@highlab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Sebastian Kuzminsky on Tuesday December 20
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Kuzminsky <seb@highlab.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday December 20, seb@highlab.com wrote:
> I'm seeing hard system lockups with 2.6.15-rc5 when trying to use a
> RAID-6 array as a PV for LVM2.
> 
> I've got four SATA disks hanging off a Marvell 6081 controller.  The disks
> work great when I access them "raw" (without going through md or dm).
> Nice & fast & reliable.  The disks work great when used "raw" as PVs
> for an LVM2 setup.  And they work great when used in a RAID-6 array.
> 
> The problem comes when I build a RAID-6 array and try to use the array
> as a PV.  The system hangs within several seconds of touching the array.
> No messages on the console, no blinky on the Caps Lock, and no pingy on
> the network...
> 
> My guess is it's an interaction between the RAID code and the LVM code,
> since both pieces work fine on their own.
> 
> Any suggestions on how to debug this?  I'm kind of stumped here...
> 

alt-sysrq-P ?
alt-sysrq-T ?

NeilBrown
