From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid 5 to 6 migration
Date: Tue, 05 Feb 2013 08:04:12 -0500
Message-ID: <5111034C.4000009@turmel.org>
References: <BLU0-SMTP433B0BCF64D448CC81098D2C91C0@phx.gbl>,<510C0075.9010908@turmel.org> <COL114-W137DD8871889508BBF087BC91C0@phx.gbl> <510C07FA.4090405@turmel.org> <BLU0-SMTP45011D3540FEA010403D4ABC9010@phx.gbl> <5110005E.103@turmel.org> <BLU0-SMTP1112AC3113196A419EBCD79C9000@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP1112AC3113196A419EBCD79C9000@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Dominique <dcouot@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/05/2013 05:36 AM, Dominique wrote:
> 
> Thanks for the detailled answer. I read through all of it to identify
> what I did not understood before starting. I have a few clarificacions
> for you and a few questions.
> 
> Yes, that's the way my console looks like. I usually don't have problem
> with UTF8 output (i.e. not garbled), I figured it was the result of the
> lsdrv.... Nasty to read, but it's all there.

Thanks for the report.  I'll have to set up a VM with your distro and
play a bit.

> I am running Ubuntu 12.04.1 server on this relatively new raid5 setup.
> I think I understood most of the reshaping instructions, but I need to
> clarify your point related to the timeout. I tried to execute it in a
> simple bash file and got stopped at the beginning just for the lack of a
> timeoutfile?
> 
> After looking for it, I realised that sd[abcdef] were all symlinks
> pointing to another part of the system, where there is no driver
> directory. After browsing, i figured out that /sys/block/sda/device did
> led to a timeout file. Can you please confirm, it is the one we want ?

Yes, sorry.  Typo on my part.

> A last point I need to clarify: is the reshaping (although long) data
> destructive (backup will be done in all cases)?

The reshape may need a small backup file for critical section(s).  If it
does, it will refuse to proceed until you specify one with
"--backup-file=..." in the "--grow" operation.  If your system crashes
during the reshape, be sure to specify the same backup file when
re-assembling.

But yes, redundancy is maintained throughout the reshape.

> Thanks,

You're welcome.

Phil

