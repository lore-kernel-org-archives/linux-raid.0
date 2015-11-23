From: Phil Turmel <philip@turmel.org>
Subject: Re: Recovering RAID5 with 2, actually 1, faulty disks.
Date: Mon, 23 Nov 2015 13:24:54 -0500
Message-ID: <565359F6.3020201@turmel.org>
References: <189791448292518@web28m.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <189791448292518@web28m.yandex.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Semyon Enskiy <semyon.enskiy@yandex.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Semyon,

On 11/23/2015 10:28 AM, Semyon Enskiy wrote:
> Hi all,
> 
> I am sorry for bad English, it is not my primary language.

No worries.  Good report.

> Does solution, described here -
> "http://marc.info/?l=linux-raid&m=144659416216285&w=2", matches for mine
> issue?

No, not related.  You have v1.2 metadata.

> Please, read issue description below, I am ready to provide additional info.
> 
> RAID1 (md1; boot), RAID10 (md2; swap, root) and
> RAID5 (md3; LVM -> ext4 -> data)
> are placed on 10 disks, each of them is 4TB WD Red with 3 partitions on it.
> All disks model is WDC WD40EFRX-68WT0N0.

This is very good.  You don't have a timeout mismatch problem.

> sd?1 partitions belongs to md1, sd?2 belongs to md2, sd?3 belongs to md3.
> 
> sdj caught IO error and was reinitialized under new minor and in-/dev/ IDs,
> in fact partitions on it was dropped from arrays.

This bothers me.  With no timeout issue, this must be a real problem.
Possibilities:

1) Drive, cable, or controller hardware flaw.
2) Transient power supply problem.
3) Kernel bug.
4) Memory bit flip if no ECC Ram.

I've looked at your dmesg, and I'm concerned about the errors on ata12
and ata8.  They report the error source as the ata bus.  And they are
happening during your check scrubs.  That suggests the sustained load
across the entire array during the scrub is stressing some component.
Insufficient power has been the most popular reason for this in the
past.  Since it seems to be happening to ata12 the most, with some ata8,
it might just be loose connectors or bad cables.

> sdk1 and sdk2, previous sdj1 and sdj2 accordingly, was readded to their
> arrays by me, but md3 stay leave sdj3 as member of array, I can't do
> anything with it, only receiving errors like that:
>     # mdadm /dev/md3 -r detached
>     mdadm: Cannot find 8:147: No such file or directory
> so sdk3 can't be readded.

This is likely a kernel bug.  A reboot at this point would probably have
cleared it and made --re-add possible.

> So I've managed to grow md3 array with command like following, do not
> remember why and strictly command:
>     # mdadm --grow --raid-devices=11 -add /dev/md3 /dev/sdk3
> array start to reshaping, but caught second error and reshaping process
> stalled with 1536 bytes transferred. Then was executed near two useless
> commands, like making sdk3 spare device.

Yeah, growing the array was a mistake.  (Where'd that idea come from?)
With mdadm v3.3 or later, you can use --assemble --update=revert-reshape
to cancel this.  It is at position 1536, so hasn't actually done any
significant reshaping yet.

--re-add was the correct operation for you to perform.  When it failed
due to a busy device, fixing the busy device issue is the correct next
step.  But this is no longer possible, as some new metadata has been
written to the device as part of the --grow operation.

The grow operation made no progress due to a kernel bug, I believe.  You
have stuck task backtraces in your dmesg for what I believe are
operations directed at the missing but not removed sdj.  Not making
progress is a lucky chance, as reshape is not the right answer anyways.

> Now md3 consists 11 devices, was 10, has 2 faulty devices, actually 1 - old
> sdj3 and sdj3 under new ID - sdk3, which is slightly corrupted by writing
> 1536 bytes.

> Seems, that I should and write data back to source block device to do it
> consistent and able to reboot, recreate array with one corrupted device and
> resync it.

No, I think you may really have bad hardware.  Check all of your power
and sata cables -- replace the cables to sdj/sdk.  Check the voltage on
the drive power rails.

When you are sure power is OK, and all the sata connectors are seated
tightly, reboot into an environment that has mdadm v3.3, and revert the
reshape.

> After this all happened, host was not rebooted, stay online, FS on md3 array
> unavailable, smartctl reports (-H argument), that all disks are healthy.

smartctl's health report is not sufficient info.  Please supply the
output of:

for x in /dev/sd[a-z] ; do echo $x ; smartctl -i -A $x ; done

Paste this inline in your next reply, with word-wrap turned off.

Then we might be able to say what's next.

> # dmesg
> "http://paste.debian.net/335374/"

External resources generally don't last as long as this list's archives.
 In the future, please paste inline anything important.  This list
accepts messages up to ~100k.

Phil

