From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 not being reassembled correctly after device swap
Date: Mon, 2 Jul 2007 08:12:14 +1000
Message-ID: <18056.9918.537787.152462@notabene.brown>
References: <200707012321.48346.infomails@tronserver.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Michael Frotscher on Sunday July 1
Sender: linux-raid-owner@vger.kernel.org
To: Michael Frotscher <infomails@tronserver.dyndns.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday July 1, infomails@tronserver.dyndns.org wrote:
> Hello RAID-Experts,
> 
> I have three RAID5 consisting of different partitions on 3 disks (Debian 
> stable) running the root-filesystem on a md (/boot is a separate non-raid 
> partition) which is running rather nicely. For convenience I plugged all 
> drives into the first ide controller making them hda, hdb and hdc. So far, so 
> good. The partitions are flagged "fd", i.e. Linux raid autodetect.
> 
> As I have another builtin-ide-controller onboard, I'd like to distribute the 
> disks for performance reasons, moving hdb to hde and hdc to hdg. The arrays 
> would then consist of drives hda, hde and hdg.
> 
> This should not be a problem, as the arrays should assemble themselves using 
> the superblocks on the partitions, shouldn't it? 
> 
> However, when I switch one drive (hdc), the array starts degraded with two 
> drives present because it is still looking for hdc, which of course now is 
> hdg. This shouldn't be happening. 
> 
> Well, then I re-added hdg to the degraded array, which went well and the array 
> rebuilded itself. I now had healthy arrays consisting of hda, hdb and hdg. 
> But after a reboot the array was degraded again and the system wanted its hdc 
> drive.
> 
> And yes, I edited /boot/grub/device.map and changed hdc to hdg, so that can't 
> be the reason.
> 
> I seem to be missing something here, but what is it?

Kernel logs from the boot would help here.
Maybe /etc/mdadm/mdadm.conf lists "device=...." where it shouldn't.
Maybe the other IDE controller uses a module that it loaded late.
Logs would help.

NeilBrown
<
