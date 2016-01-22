From: Phil Turmel <philip@turmel.org>
Subject: Re: md failing mechanism
Date: Fri, 22 Jan 2016 17:18:25 -0500
Message-ID: <56A2AAB1.6070305@turmel.org>
References: <56A26E11.2090703@yandex.ru> <56A28309.9080806@turmel.org>
 <56A2A2C3.9000801@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56A2A2C3.9000801@yandex.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Dark Penguin <darkpenguin@yandex.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/22/2016 04:44 PM, Dark Penguin wrote:
> Oh! Thank you! I really wanted to see a reliable "what's supposed to
> happen" sequence!

You're welcome.

> As for my case, those were indeed, um, "cheap desktop drives" - to be
> precise, some 80-Gb IDE drives in a Pentium-4 machine; "it works well
> for a small file server", I thought, oblivious to the finer details
> about the process of failure handling... But, I also have "big" file
> servers, so that timeout mismatch issue is something worth paying
> attention!
> 
> And also, now I understand why I probably "should have been scrubbing".
> =/ Do I understand correctly that "scrubbing" means those "monthly
> redundancy checks" that mdadm suggests? And I suppose what it does is
> just the same - read every sector and attempt to write it back upon
> failure, otherwise kicking the device?

A "check" scrub reads every sector every member device's data area.  If
any fail, the normal reconstruct and rewrite will fix it.  It also looks
for successfull reads where the data is inconsistent between mirrors or
between data blocks and parity blocks.  Those are counted for you to review.

A "repair" scrub reads forcibly ensures consistent redundancy by copying
mirror one to the others, and recomputing parity from data.  It will
also reconstruct if needed.

The "check" mode is your recommended regular scrub.  I do mine weekly,
but monthly is probably fine.  "Repair" is needed if "check" reports any
mismatches.

> ..... is all that correct?

From one of your reading assignments: (
http://marc.info/?l=linux-raid&m=135811522817345&w=1 )

> Options are:
> 
> A) Buy Enterprise drives. They have appropriate error timeouts and work
> properly with MD right out of the box.
> 
> B) Buy Desktop drives with SCTERC support. They have inappropriate
> default timeouts, but can be set to an appropriate value. Udev or boot
> script assistance is needed to call smartctl to set it. They do *not*
> work properly with MD out of the box.
> 
> C) Suffer with desktop drives without SCTERC support. They cannot be
> set to appropriate error timeouts. Udev or boot script assistance is
> needed to set a 120 second driver timeout in sysfs. They do *not* work
> properly with MD out of the box.
> 
> D) Lose your data during spare rebuild after your first URE. (Odds in
> proportion to array size.)
> 
> One last point bears repeating: MD is *not* a backup system, although
> some people leverage it's features for rotating off-site backup disks.
> Raid arrays are all about *uptime*. They will not save you from
> accidental deletion or other operator errors. They will not save you if
> your office burns down. You need a separate backup system for critical
> files.

Since that was written, 'A' would now include almost-enterprise drives
with RAID ratings like the Western Digital Red family.  And the
recommended timeout for 'C' has drifted upward to 180.

[trim /]

> Still, I don't think it has anything to do with what has happened to my
> "small file server"...

That's why I asked for the dmesg.  It could have been a bug.  No crisis
if it's lost, so long as you've accepted one of A through D above.

Phil

ps.  convention on kernel.org is reply-to-all and no top-posting.
