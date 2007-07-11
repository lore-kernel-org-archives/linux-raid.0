From: Nix <nix@esperi.org.uk>
Subject: Re: Software based SATA RAID-5 expandable arrays?
Date: Thu, 12 Jul 2007 00:29:14 +0100
Message-ID: <87wsx6senp.fsf@hades.wkstn.nix>
References: <95941.71200.qm@web54102.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <95941.71200.qm@web54102.mail.re2.yahoo.com> (Michael's message of "11 Jul 2007 21:08:55 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Michael <big_green_jelly_bean@yahoo.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Daniel Korstad <dan@korstad.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11 Jul 2007, Michael stated:
> I am running Suse, and the check program is not available

`check' isn't a program. The line suggested has a typo: it should
be something like this:

30 2 * * Mon   echo check > /sys/block/md0/md/sync_action

The only program that line needs is `echo' and I'm sure you've got
that. (You also need to have sysfs mounted at /sys, but virtually
everyone has their systems set up like that nowadays.)

(obviously you can check more than one array: just stick in other lines
that echo `check' into some other mdN at some other time of day.)

-- 
`... in the sense that dragons logically follow evolution so they would
 be able to wield metal.' --- Kenneth Eng's colourless green ideas sleep
 furiously
