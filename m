From: David Mansfield <md@dm.cobite.com>
Subject: Re: raid5, media scans and stripe-wise resync
Date: Mon, 25 Oct 2004 17:09:49 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1098738589.5399.58.camel@duxeon.cobite.com>
References: <200410252029.i9PKTEN26833@www.watkins-home.com>
	 <1098736532.5399.52.camel@duxeon.cobite.com>
	 <20041025224838.04c51a0b.pegasus@nerv.eu.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041025224838.04c51a0b.pegasus@nerv.eu.org>
To: Jure Pe_ar <pegasus@nerv.eu.org>
Cc: bugzilla@watkins-home.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2004-10-25 at 16:48, Jure Pe_ar wrote:
> On Mon, 25 Oct 2004 16:35:32 -0400
> David Mansfield <md@dm.cobite.com> wrote:
> 
> > The point is that NEITHER DRIVE 'FAILS'.  They just have unrecoverable
> > read errors, or bad sectors.  As long as the two bad sectors are not in
> > the same stripe, you have not lost any data (theoretically, for s/w and
> > realistically for h/w).
> 
> As I see the problem, the definition of what is a "failed drive" is
> different from sysadmin's point of view and from md's point of view.
> 

Exactly.  md always kicks the entire drive out.  Hardware raid doesn't
take these extreme measures if a sector reassignment can take care of
the problem immediately.  

In the md case, we are stuck with having to resync an entire disk, which
is terrible if there is another sector on a different disk that is bad.


> Md freaks out on every single unrecoverable read error, but these usualy do
> not indicate a completely failed and dead drive. 
> 

In fact, very often an unrecoverable read error is an isolated defect.

> What needs to be done is to give md some more knowledge about disk errors,
> disk behaviour at dying and possibly integrate it in some way with smartd.
> This has been requested every now and then at least for the last three
> years, however nobody started to work on something like this, at least I'm
> not aware of any such activity.
> 

Ok.  Thanks for the info.  I tried googling and came up with nothing.

> How exactly this could / should be acomplished is an interesting topic too.
> 

If only I had an extra few months...

David


