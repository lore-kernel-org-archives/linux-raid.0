From: Neil Brown <neilb@suse.de>
Subject: Re: Spare drive won't spin down
Date: Tue, 18 May 2010 10:50:49 +1000
Message-ID: <20100518105049.490aa652@notabene.brown>
References: <922812.29139.qm@web31703.mail.mud.yahoo.com>
	<20100507162034.1370d645@notabene.brown>
	<717013.48748.qm@web31703.mail.mud.yahoo.com>
	<20100507194704.3ffcf17e@notabene.brown>
	<4BE83B75.8050709@tmr.com>
	<20100512065318.44e934d4@notabene.brown>
	<4BF186DE.5050502@redhat.com>
	<20100518102312.01c85274@notabene.brown>
	<AANLkTiknwELDEgA2LKbhOkNJWlm-wxBozMZ4i0BUFtu2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTiknwELDEgA2LKbhOkNJWlm-wxBozMZ4i0BUFtu2@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Doug Ledford <dledford@redhat.com>, Bill Davidsen <davidsen@tmr.com>, Joe Bryant <tenminjoe@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 17 May 2010 17:38:04 -0700
Michael Evans <mjevans1983@gmail.com> wrote:

> You should make it a sysfs controllable option to keep the counter
> updated on spare discs or not.  The default can be to keep it within
> one as you currently are patching it to.  Then later you can change
> the default to the higher performance setting.  Better, the presence
> of that file can be used to test if the kernel supports it, and if it
> doesn't initramfs scripts can react accordingly.

There really isn't any need for user-space to know - this is an entirely
in-kernel thing.  mdadm already supports assembling arrays with widely
different event_counts.  It just gives them to the kernel and lets it make
the final decision.

And I think it is stretching things to call this a performance setting.  It
only changes behaviour when add devices is added/removed/failed or when an
array is started or reshaped.  None of those happen often enough that an
extra spin-up is really going to be an issue.

It is more an issue of simplicity and elegance.  I don't think a sysfs option
is appropriate for that.

But thanks for the suggestion.

NeilBrown

