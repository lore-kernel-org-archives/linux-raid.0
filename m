From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: I/O hangs after resuming from suspend-to-ram
Date: Sat, 26 Aug 2017 21:33:04 +0200
Message-ID: <3987895.gqtK3X00tl@merkaba>
References: <3926917.BCSovyVWdL@natalenko.name> <4679671.be02cq1OFG@merkaba> <59A1AD17.70208@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <59A1AD17.70208@youngman.org.uk>
Sender: linux-block-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

Wols Lists - 26.08.17, 18:17:
> On 26/08/17 12:19, Martin Steigerwald wrote:
> > Also… when a hang happened the mouse pointer was frozen, Ctrl-Alt-F1
> > didn´t
> > work and so on… so it may easily be a completely different issue.
> > 
> > I did not see much point in reporting it so far… as I have no idea on how
> > to reliably pin-point the issue. It happens once every few days, so a
> > bisect again is out of questions – (it is anyway for a production machine
> > for me) –, it appears to be a hard freeze, so no debug data… its one of
> > these "you don´t get to debug me" hangs again. I really have no idea how
> > to a get hold on such complexity. I am hoping to at least pin-point the
> > exact kernel option that triggers this issue, but it may take weeks to do
> > so. I´d really love a way for the kernel to at least to write out debug
> > data before doing hanging completely.
> 
> This sounds like what I'm getting - SuSE 42.3, no raid, doesn't happen
> when the power lead is in (but I think the laptop is configured not to
> suspend when powered, precisely to avoid exactly this).
> 
> It happens to me quite often, unfortunately, but it seems a KDE issue in
> that applications work fine, UNTIL KDE seems to get control of the mouse
> at which point I can't do anything.
> 
> I've got a feeling it's related to wireless networking actually, my
> setup is somewhat borked because KDE, systemd, and wifi don't seem to
> work nicely together :-(

Well my issue isn´t related to wireless networking as my laptop at home is 
using good old cable based ethernet. I do use Plasma tough. The issue of the 
original poster appears to be blk-mq related.

As written, I have no idea whether my issue is related to blk-mq in any way. 
Thats the next step I´d test. If the current kernel runs stable… then I´d 
enable blk-mq by default again and test whether the hangs reappear. Unless I 
can pinpoint the issue to blk-mq… I have nothing further to comment here, I 
think. (And I didn´t intend to use the thread for every hang on resume issue 
that currently may exist. I just don´t know yet whether my issue is related to 
blk-mq so I chimed in.)

Thanks,
-- 
Martin
