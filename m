From: Neil Brown <neilb@suse.de>
Subject: Re: raid=noautodetect is apparently ignored?
Date: Tue, 26 Jun 2007 16:38:43 +1000
Message-ID: <18048.46195.870920.626128@notabene.brown>
References: <1182837145.3627.27.camel@sibyl.beware.dropbear.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ian Dall on Tuesday June 26
Sender: linux-raid-owner@vger.kernel.org
To: Ian Dall <ian@beware.dropbear.id.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday June 26, ian@beware.dropbear.id.au wrote:
> When I try and disable auto detection, with kernel boot parameters, it
> goes ahead and auto assembles and runs anyway. The md= parameters seem
> to be noticed, but don't seem to have any other effect (beyond resulting
> in a dmesg).

Odd....
 Maybe you have an initrd which is loading md as a module, then
 running "raidautorun" or similar?

> 
> This is driving me nuts. Maybe changing the type of the hda partitions
> would help?

Definitely.  Change the partition types.

NeilBrown
