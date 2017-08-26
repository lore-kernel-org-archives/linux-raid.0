From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: I/O hangs after resuming from suspend-to-ram
Date: Sat, 26 Aug 2017 18:17:11 +0100
Message-ID: <59A1AD17.70208@youngman.org.uk>
References: <3926917.BCSovyVWdL@natalenko.name>
 <2602983.s9jWEo5DpR@natalenko.name> <1579257.t1hTzJa9iD@natalenko.name>
 <4679671.be02cq1OFG@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <4679671.be02cq1OFG@merkaba>
Sender: linux-block-owner@vger.kernel.org
To: Martin Steigerwald <martin@lichtvoll.de>, Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

On 26/08/17 12:19, Martin Steigerwald wrote:
> Also… when a hang happened the mouse pointer was frozen, Ctrl-Alt-F1 didn´t 
> work and so on… so it may easily be a completely different issue.
> 
> I did not see much point in reporting it so far… as I have no idea on how to 
> reliably pin-point the issue. It happens once every few days, so a bisect 
> again is out of questions – (it is anyway for a production machine for me) –, 
> it appears to be a hard freeze, so no debug data… its one of these "you don´t 
> get to debug me" hangs again. I really have no idea how to a get hold on such 
> complexity. I am hoping to at least pin-point the exact kernel option that 
> triggers this issue, but it may take weeks to do so. I´d really love a way for 
> the kernel to at least to write out debug data before doing hanging 
> completely.

This sounds like what I'm getting - SuSE 42.3, no raid, doesn't happen
when the power lead is in (but I think the laptop is configured not to
suspend when powered, precisely to avoid exactly this).

It happens to me quite often, unfortunately, but it seems a KDE issue in
that applications work fine, UNTIL KDE seems to get control of the mouse
at which point I can't do anything.

I've got a feeling it's related to wireless networking actually, my
setup is somewhat borked because KDE, systemd, and wifi don't seem to
work nicely together :-(

Cheers,
Wol
