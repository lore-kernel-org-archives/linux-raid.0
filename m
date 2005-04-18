From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Questions about software RAID
Date: Mon, 18 Apr 2005 22:15:41 +0200
Message-ID: <d4hdj2-e6h.ln1@news.it.uc3m.es>
References: <1113853825.1483.34.camel@debian>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

tmp <skrald@amossen.dk> wrote:
> 1) I have a RAID-1 setup with one spare disk. A disk crashes and the
> spare disk takes over. Now, when the crashed disk is replaced with a new
> one, what is then happening with the role of the spare disk? Is it
> reverting to its old role as spare disk?

Try it and see.  Run raidsetfaulty on one disk.  That will bring the
spare in.  Run raidhotremove on the original.  Then "replace" it
with raidhotadd.

> If it is NOT reverting to it's old role, then the raidtab file will
> suddenly be out-of-sync with reality. Is that correct?

Shrug. It was "out of sync" as you call it the moment the spare disk
started to be used not as a spare but as part of the array.

> Does the answer given here differ in e.g. RAID-5 setups?

No.

> 2) The new disk has to be manually partitioned before beeing used in the
> array. What happens if the new partitions are larger than other
> partitions used in the array?

Bigger is fine, obviously!

> What happens if they are smaller?

They can't be used.

> 3) Must all partition types be 0xFD? What happens if they are not?

They can be anything you like. If they aren't, then the kernel
can't set them up at boot.

> 4) I guess the partitions itself doesn't have to be formated as the
> filesystem is on the RAID-level. Is that correct?

?? Sentence does not compute, I am afraid.


> 5) Removing a disk requires that I do a "mdadm -r" on all the partitions
> that is involved in a RAID array.

Does it? Well, I see that you mean "removing a disk intentionally".

> I attempt to by a hot-swap capable
> controler, so what happens if I just pull out the disk without this
> manual removal command?

The disk will error at the next access and will be faulted out of the
array.

> Aren't there some more hotswap-friendly setup?

?? Not sure what you mean. You mean, can you program the hotplug system
to do a setfaulty and remove from the array? Yes. Look at your hotplug
scripts in /etc/hotplug. But it' always going to be late hatever it
does, given that pulling the array is the trigger!

> 6) I know that the kernel does stripping automatically if more
> partitions are given as swap partitions in /etc/fstab. But can it also
> handle if one disk crashes? I.e. do I have to let my swap disk be a
> RAID-setup too if I wan't it to continue upon disk crash?

People have recently pointed out that raiding your swap makes sense
exactly in order to cope robustly with this eventually. You'd have had
to raid everything ELSE on the dead disk, of course, so I'm not quite
as sure as everyone else that it's a truly staggeringly wonderful idea. 

Peter

