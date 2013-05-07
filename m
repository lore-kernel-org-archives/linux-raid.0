From: Ole Tange <tange@binf.ku.dk>
Subject: Re: --grow RAID6 gives: md: md_do_sync() got signal ... exiting + hang
Date: Tue, 7 May 2013 14:08:14 +0200
Message-ID: <CANU9nTkPUq7V5tnndE64H64jpb7yr6NMZSmcFrqUf8PmRQMsMg@mail.gmail.com>
References: <CANU9nTmqXjPFqU=p0vex2SgXjyv9L2NO5mafHoWqfH7n1kkhcw@mail.gmail.com>
 <20130507215436.46fb6857@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130507215436.46fb6857@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, May 7, 2013 at 1:54 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 7 May 2013 13:36:56 +0200 Ole Tange <tange@binf.ku.dk> wrote:
>
>> I am expanding my 9 harddisk RAID6 to 10 harddisk RAID6:
:
>> It is, however, hanging the system.
:
>> # Do the reshape
>> mdadm -v --grow /dev/md1 --raid-devices=10
>> --backup-file=/root/back-md1
>> mdadm: Need to backup 7168K of critical section..

This completed - did not hang.

> What does
>   grep . /sys/block/md1/md/*
> show? Or does it hang?

Hangs (ctrl-c works).

> What about "mdadm --examine /dev/sd*"

https://gist.github.com/anonymous/5532063

The disk box contains more drives than just the array in question. The
interesting array is: 242d6530:e2562ecb:1dcd2a97:15a1a868

> Did the "mdadm --grow" appear to complete, and return to the shell prompt?

Yes.

> What kernel version?  What mdadm version?

$ mdadm --version
mdadm - v3.2.5 - 18th May 2012

$ uname -r
3.2.0-0.bpo.1-amd64

> A hanging /proc/mdstat is definitely not a good sign.  The "got signal ...
> exiting" isn't good either.  I would expect more messages with that.
> You didn't just "grep md" in dmesg did you?  That is a complete dmesg output
> for the entire time period that could possibly be relevant?

dmesg of controller upgrade (after which everything worked fine)
followed by --grow at 4328065.432267

https://gist.github.com/anonymous/5532093

/Ole
