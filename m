From: Shaohua Li <shli@kernel.org>
Subject: Re: PROBLEM: Kernel BUG with raid5 soft + Xen + DRBD - invalid opcode
Date: Mon, 9 Jan 2017 14:44:35 -0800
Message-ID: <20170109224435.sfyrvkxhajgrq2i5@kernel.org>
References: <585D6C34.2020908@gmail.com>
 <20170104223015.cr6vtyhxuwxrg76g@kernel.org>
 <e56edc2b-f2ad-2ab1-4184-5d7cad80085a@gmail.com>
 <20170105193745.qnmqsussxy7nasdn@kernel.org>
 <2717981a-4308-3f7b-15c6-f384a41fd445@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2717981a-4308-3f7b-15c6-f384a41fd445@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: MasterPrenium <masterprenium.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, xen-users@lists.xen.org, linux-raid@vger.kernel.org, "MasterPrenium@gmail.com" <MasterPrenium@gmail.com>, xen-devel@lists.xenproject.org
List-Id: linux-raid.ids

On Sun, Jan 08, 2017 at 02:31:15PM +0100, MasterPrenium wrote:
> Hello,
> 
> Replies below + :
> - I don't know if this can help but after the crash, when the system
> reboots, the Raid 5 stack is re-synchronizing
> [   37.028239] md10: Warning: Device sdc1 is misaligned
> [   37.028541] created bitmap (15 pages) for device md10
> [   37.030433] md10: bitmap initialized from disk: read 1 pages, set 59 of
> 29807 bits
> 
> - Sometimes the kernel completely crash (lost serial + network connection),
> sometimes only got the "BUG" dump, but still have network access (but a
> reboot is impossible, need to reset the system).
> 
> - You can find blktrace here (while running fio), I hope it's complete since
> the end of the file is when the kernel crashed : https://goo.gl/X9jZ50

Looks most are normal full stripe writes.
 
> > I'm trying to reproduce, but no success. So
> > ext4->btrfs->raid5, crash
> > btrfs->raid5, no crash
> > right? does subvolume matter? When you create the raid5 array, does adding
> > '--assume-clean' option change the behavior? I'd like to narrow down the issue.
> > If you can capture the blktrace to the raid5 array, it would be great to hint
> > us what kind of IO it is.
> Yes Correct.
> The subvolume doesn't matter.
> -- assume-clean doesn't change the behaviour.

so it's not a resync issue.

> Don't forget that the system needs to be running on xen to crash, without
> (on native kernel) it doesn't crash (or at least, I was not able to make it
> crash).
> > > Regarding your patch, I can't find it. Is it the one sent by Konstantin
> > > Khlebnikov ?
> > Right.
> It doesn't help :(. Maybe the crash is happening a little bit later.

ok, the patch is unlikely helpful, since the IO size isn't very big.

Don't have good idea yet. My best guess so far is virtual machine introduces
extra delay, which might trigger some race conditions which aren't seen in
native.  I'll check if I could find something locally.

Thanks,
Shaohua
