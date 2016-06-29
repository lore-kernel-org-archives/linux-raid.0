From: Edward Kuns <eddie.kuns@gmail.com>
Subject: Re: URE, link resets, user hostile defaults
Date: Wed, 29 Jun 2016 13:16:00 -0500
Message-ID: <CACsGCyRd388u4XXCSnoK4TpNoPibjhdgEJsHS=vR6aztDc=+2A@mail.gmail.com>
References: <CAJCQCtT1qi1yLjE3Lor3ScVJx7aX4A_S_iM_=VhDtDCD_C9uqw@mail.gmail.com>
 <57721A47.8070203@suse.de> <CAJCQCtQ=DXWg6qK1+9bwQxrzpKUsRvaiaAnatYR-dupg7JOVzQ@mail.gmail.com>
 <20160629121751.GT15597@hungrycats.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160629121751.GT15597@hungrycats.org>
Sender: linux-raid-owner@vger.kernel.org
To: Zygo Blaxell <u0oo5pgu@umail.furryterror.org>
Cc: Chris Murphy <lists@colorremedies.com>, Hannes Reinecke <hare@suse.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jun 29, 2016 at 7:17 AM, Zygo Blaxell
<u0oo5pgu@umail.furryterror.org> wrote:
> OK, but the two links you provided are not examples of these.

But there *are* plenty of examples of this.  I've run into this
personally, before I knew to specifically check the ERC/TLER/whatever
configuration on all my drives and pro-actively configure them
properly.

When the only two options are 1) long kernel timeout and URE is caught
and fixed, or 2) short kernel timeout and the drive is detected as
failed and kicked from all arrays, then I'll take #1 please.
Obviously, trying to detect misconfiguration and drives that don't
support ERC/TLER and fixing the timeout accordingly would be better.
I agree with others, the current default behavior is unintentionally
user-hostile.

> Long timeouts don't really serve anyone, even in single-disk cases.

This statement is too dogmatic.  It depends on the drive.  For a drive
with the proper features and settings, that is guaranteed to respond
in a few seconds unless it has truly totally failed, I agree with you.
For a drive with those features but misconfigured (e.g., by default),
best is to configure it properly, so in that case I agree with you but
changes are needed somewhere to get the configuration to occur
automatically.  For a consumer drive that lacks those features
entirely, I disagree with you.  Although for that case, it would be
worth having an alarm of some sort be triggered perhaps similar to the
EMails generated when an array degrades.  That would let the user know
that the drive is responding very slowly (probably indicating
recoverable read errors) and may fail soon.  Again, changes are needed
to do that.

              Eddie
