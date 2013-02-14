From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: Set disk faulty / hot disk remove ioctl bug for read-only MD?
Date: Thu, 14 Feb 2013 13:23:01 +0100
Message-ID: <511CD725.4000808@profitbricks.com>
References: <alpine.DEB.2.02.1302121559540.11804@jlaw-desktop.mno.stratus.com> <20130213133820.6496b074@notabene.brown> <511B7CE6.5060806@profitbricks.com> <511BA386.30304@profitbricks.com> <20130214085521.6efe814e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130214085521.6efe814e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Joe Lawrence <Joe.Lawrence@stratus.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13.02.2013 22:55, NeilBrown wrote:
> On Wed, 13 Feb 2013 15:30:30 +0100 Sebastian Riemer
> <sebastian.riemer@profitbricks.com> wrote:
>> Damn, I've got a kernel which still crashes in
>> reap_sync_thread->raid1_spare_active() with NULL pointer dereference
>> although this patch is applied. So the fix isn't correct, yet.
>>
>> I did some "objdump -S" on raid1.ko and found the issue at the following
>> code location in raid1_spare_active():
>> #	for (i = 0; i < conf->raid_disks; i++) {
>> #		struct md_rdev *rdev = conf->mirrors[i].rdev;
>> #		struct md_rdev *repl = conf->mirrors[conf->raid_disks + i].rdev;
>>
>> A resync was pending (create without --assume-clean).
>> For me it looks like the faulty setting races with the syncer. The rdev
>> isn't registered in the personality anymore but the syncer tries to
>> access it for immediate resync.
>>
> 
> Where exactly is it crashing?  Can I see the complete Oops message?
> The code you have identified cannot crash unless conf->raid_disks has become
> inconsistent with the allocation of ->mirrors, and that is very unlikely.
> Both 'rdev' and 'repl' are tested for NULL before they are used...

Sorry, turned out to be a local issue. In an own check directly in the
next line I've forgotten to check rdev for NULL. Thanks for the help!

I'm developing a raw-to-md migration at the moment. With that I can let
MD sync from a device without an MD superblock to a device with MD
superblock.

Cheers,
Sebastian

