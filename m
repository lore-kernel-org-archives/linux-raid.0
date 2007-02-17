From: Corey Hickey <bugfood-ml@fatooh.org>
Subject: Re: 2.6.20: reproducible hard lockup with RAID-5 resync
Date: Sat, 17 Feb 2007 02:58:01 -0800
Message-ID: <45D6DFB9.3090009@fatooh.org>
References: <45D55366.4010904@fatooh.org> <17877.25722.404051.470040@notabene.brown> <45D620D5.3060805@fatooh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45D620D5.3060805@fatooh.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Corey Hickey wrote:
> When I get home (late) tonight I'll try running dd and badblocks on the 
> corresponding drives and partitions.

Well, I haven't been able to reproduce the problem that way. I tried the
following:

$ dd id=/dev/hda of=/dev/null
$ badblocks /dev/hda
$ badblocks -n /dev/hda

...and the same for sda6, sdb, sdc6, sdd, and md2. In each case I killed
the test after several seconds, on the assumption that if the problem
was reproducible within less than a second by triggering a resync, it
wouldn't take long any other way.

If anyone has any suggestions for further tests I can do, I'll be happy
to try them out.

Thanks,
Corey
