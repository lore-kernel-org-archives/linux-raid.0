From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: raid1 repair does not repair errors?
Date: Tue, 04 Feb 2014 23:34:43 +0400
Message-ID: <52F140D3.8080703@msgid.tls.msk.ru>
References: <52EE3910.3040205@msgid.tls.msk.ru> <20140203120431.400a8a1b@notabene.brown> <20140203153644.4c530672@notabene.brown> <52EF45A0.3010401@msgid.tls.msk.ru> <52EFD608.6020106@msgid.tls.msk.ru> <20140204153042.4288240c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140204153042.4288240c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

04.02.2014 08:30, NeilBrown wrote:
[]
> I'm really on a roll here, aren't I.

Well, we both are, unless I don't understand what "on a roll" means :)

> I looked again and that code I've been trying to fix as actually perfectly
> fine.  I'm not sure whether to be happy to sad about that.
> 
> But... I've found the bug.  I know this time because I actually tested it.
> I tested and current mainline and it didn't work.  So I hunted and found a
> bug.
> But that buggy code isn't in 3.10.
> So I tested 3.10 and it crashed.
> Ah-ha I though.  So I looked at 3.10.27, and  it has different code.  It has
> the buggy code.  So I tested that and  it didn't work.
> Then I applied  the patch below, and now it does.
> 
> The bug was introduced by
> 
> commit 30bc9b53878a9921b02e3b5bc4283ac1c6de102a
> Author: NeilBrown <neilb@suse.de>
> Date:   Wed Jul 17 15:19:29 2013 +1000
> 
>     md/raid1: fix bio handling problems in process_checks()
> 
> which moved the clearing for bi_flags up in a function to before it was
> tested.  That wasn't really the right thing to do.
> 
> When that was backported to 3.10 it fixed the crash, but introduce this new
> bug.
> 
> Anyway enough of my rambling - here is the patch.  As I don't much feel like
> trusting my own results just a the moment I look forward to your
> confirmation, one way or the other.

Wow.  I see.
Indeed, I'm running latest 3.10 now, 3.10.28.  I never really thought
about testing other versions, because, well, this didn't look like some
new issue to me, I thought it is some old stuff which hasn't changed
much in 3.13 and up.  Well, if either of us knew it is specific to 3.10.y,
we'd both behave differently from the beginning, aren't we? :)

So I tried your patch (on top of my initial just-the-debugging changes), had to
fix a few MIME =damages on the go, but that is not really interesing.  And
this version actually appears to work, but does it silently.

After a repair run with your last patch applied, I see this:

[  767.456457] md: requested-resync of RAID array md1
[  767.486818] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  767.517404] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for requested-resync.
[  767.548977] md: using 128k window, over a total of 2096064k.
[  808.174908] ata6.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 action 0x0
[  808.206395] ata6.00: irq_stat 0x40000008
[  808.237186] ata6.00: failed command: READ FPDMA QUEUED
[  808.267635] ata6.00: cmd 60/80:00:00:3e:3e/00:00:00:00:00/40 tag 0 ncq 65536 in
[  808.267635]          res 41/40:00:23:3e:3e/00:00:00:00:00/40 Emask 0x409 (media error) <F>
[  808.329226] ata6.00: status: { DRDY ERR }
[  808.359915] ata6.00: error: { UNC }
[  808.392438] ata6.00: configured for UDMA/133
[  808.421989] sd 5:0:0:0: [sdd] Unhandled sense code
[  808.451361] sd 5:0:0:0: [sdd]
[  808.480329] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  808.509679] sd 5:0:0:0: [sdd]
[  808.538719] Sense Key : Medium Error [current] [descriptor]
[  808.568061] Descriptor sense data with sense descriptors (in hex):
[  808.597257]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
[  808.626981]         00 3e 3e 23
[  808.656380] sd 5:0:0:0: [sdd]
[  808.685550] Add. Sense: Unrecovered read error - auto reallocate failed
[  808.715375] sd 5:0:0:0: [sdd] CDB:
[  808.744933] Read(10): 28 00 00 3e 3e 00 00 00 80 00
[  808.774678] end_request: I/O error, dev sdd, sector 4079139
[  808.804412] end_sync_read: !BIO_UPTODATE
[  808.834040] ata6: EH complete
[  809.486124] md: md1: requested-resync done.

and now, all pending sectors are gone from the drive, and subsequent reads
of this place does not produce any errors.

However, mismatch_cnt right after this repair run shows 128 (and never goes
larger than 0 on subsequent repair runs).  I'm not sure what this 128 really
means, shouldn't it be just one for a single unreadable 512 bytes?

At the same time, mdadm --monitor reports:

Feb  4 23:19:24 mother mdadm[4793]: RebuildFinished event detected on md device /dev/md1
Feb  4 23:21:13 mother mdadm[4793]: RebuildFinished event detected on md device /dev/md1, component device  mismatches found: 128 (on raid level 1)

So, your patch appears to work now, the only issue is that it is too silent:
I'd expect to see at least some mention of "repairing this or that block", or
something like that.

Meanwhile I found an interesting option of hdparm -- it is --make-bad-sector.
So, despite all the warnings around it, I tried it on this very same prod.
server, and marked the same sector as bad again, and re-run the whole thing
(verifying that read of that sector actually produces an error).  And it all
repeated exactly: repair run silently fixed the error and reported 128 found
mismatches, and after repair run, this place is readable again.


(What I'd love to see now, which is not related to mdadm in any way - is an
ability to remap this place on the drive once and for all, making the first
Reallocate_Event_Count to actually happen, to not bother with it ever again.
As was possible with old good scsi drives, for many years..  Anyone know if
it still possible today with sata drives?  To remap this place and be done
with it, instead of repeating the same - rewrite, it is good now, but with
time it becomes unreadable, so rewrite it again, ad infinitum...)

> Thanks,

Thank you!

Should I try 3.13 kernel too (now when I know how to make a bad sector),
just to verify it works fine without additional patches?

/mjt
