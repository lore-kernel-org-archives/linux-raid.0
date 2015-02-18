From: Chris <email.bug@arcor.de>
Subject: Re: What are mdadm maintainers to do? (error recovery redundancy/data loss)
Date: Wed, 18 Feb 2015 11:04:35 +0000 (UTC)
Message-ID: <loom.20150218T102011-486@post.gmane.org>
References: <loom.20150214T222329-324@post.gmane.org> <20150216142845.0d50207c@notabene.brown> <loom.20150216T124230-883@post.gmane.org> <54E1EDEA.1030503@turmel.org> <loom.20150216T165111-551@post.gmane.org> <54E226B5.1080500@turmel.org> <loom.20150216T183419-387@post.gmane.org> <20150217104906.62d36c62@notabene.brown> <loom.20150217T080345-764@post.gmane.org> <CAJCQCtQvoB0yPPc=RXPPyJhpaFwH0pQTRCRaR_ycTbzHrD6rLw@mail.gmail.com> <54E3C51C.2080106@websitemanagers.com.au> <CAJCQCtTv-HMX77GWqA+_1rfkWodsTETp_Y3w5En-N4nGCymWsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>

Hello all,

the discussion about SCTERC boils down to letting the drive attempt ERC a
little more or less. For any given disk experience seems to tell the slight
difference is, that if ERC is allowed longer you may see the first
unrecoverable erros (UREs) just a little (maybe only a month) later.

UREs are inevitable. Thus, if I run a filesystem on just a single drive it
will get corrupted at some point, nothing to do about it.

Wait, except..., use a redundant raid! And here it makes a lot of a
difference that the drive's ERC actually terminates before the controller
timeout, to not loose all your redundacy again and be in hight risk of UREs
showing up during the re-sync.

So for a proper comparison we need to look at the difference it makes in the
usage scenarios (error delay vs. loosing redundant error resilence + URE
triggering), not at the single recoverable/unrecoverable error incidence. It
looks to me, that it makes a lot of a differnce to redundant raids and no
qualitative difference to single disk filesystems.

And we need to keep in mind that single disk filesystems do also depend on
the disk to stop grinding away with ERC attempts before the controller
timout. Otherwise disk reset may make the system clear buffers and loose
open files? Without prolonging the linux default controller timout, SCTERC
can prevent that where supported.



> in any case the proper place to change the default kernel command
> timer value is in the kernel, not with a udev rule.

Right. And as you write increasing the controller timout has clear downsides.

Noteing as well, as long as the proposed script (a temporary safety measure)
maximizes the controller timeout to remedy for disks that don's support
SCTERC, this would even fix the timout mismatch for single disk filesystems.
(Letting the controller wait until the disk finally succeeds or fails its
recovery attempts.)

So the proposed script actually provides a case that brings benefit for
raid0 setups as well (as long as the linux default is not adaptive to the
disk parameters), but increasing the controller timout in all cases would
introduce long and unreported i/o blocking into all redundant setups.


> I don't know if a udev rule can say "If the drive exclusively uses md,
> lvm, btrfs, zfs raid1, 4+ or nested of those, and if the drive does
> not support configurable SCT ERC, then change the kernel command timer
> for those devices to ~120 seconds" then that might be a plausible
> solution to use consumer drives the manufacturer rather explicitly
> proscribes from use in raid...

The script called by the udev rule could do that, but can be kept as simple
as proposed, and can set SCTERC regardles, because setting SCTERC below the
controller timout makes a qualitative difference in running the redundant
arrays and a marginal difference in running non-redundant filesystems. (And
nevertheless, set long controller timout for devices that don's support SCTERC.)



After all, this looks like a quite simple change is appropriate:

In udev-md-raid-assembly.rules, below LABEL="md_inc" (only handling all md
suppported devices) add one rule:

# fix timouts for redundant raids, if possible
TEST="/usr/sbin/smartctl", ENV{MD_LEVEL}=="raid[1-9]*",
RUN+="/usr/bin/mdadm-erc-timout-fix"


And in a new /usr/bin/mdadm-erc-timout-fix file implement:

  if smartctl -l scterc ${HDD_DEV} returns "Disabled" 
    /usr/sbin/smartctl -l scterc,70,70 ${HDD_DEV}
  else
    if smartctl -l scterc ${HDD_DEV} does not return "seconds"
      echo 180 >/sys/block/${HDD_DEV}/device/timeout


Regards,
Chris


