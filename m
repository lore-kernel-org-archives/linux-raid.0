From: Maarten <maarten@ultratux.net>
Subject: Re: lilo boot problems
Date: Tue, 31 Aug 2004 02:22:23 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408310222.24563.maarten@ultratux.net>
References: <200408251458.46575.maarten@ultratux.net> <200408280044.55286.maarten@ultratux.net> <20040830082625.GA9916@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040830082625.GA9916@apartia.fr>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 30 August 2004 10:26, Louis-David Mitterrand wrote:
> On Sat, Aug 28, 2004 at 12:44:55AM +0200, maarten wrote:
> > On Friday 27 August 2004 15:04, Laurent CARON wrote:
> > > maarten wrote:

>
> > > you have to reconstruct your array first.
> >
> > Eeh...  You're joking, right ?
> > The array holds no data as yet so it is possible, but several things seem
> > too odd about this advice.  First, there is nothing wrong with this
> > array, it was created by mdadm with all the right options. Second, this
> > being linux (not windows) I can hardly believe one has to solve problems
> > by no other means than starting all over ("reinstall windows") if the
> > only error is due to the bootmanager interacting with the kernel
> > (remember, this error doesn't occur with other, earlier, kernels).
> >
> > Anyway, I chose to work around it by installing grub (and it works fine).
>
> By "reconstruct" I think Laurent meant "synchronize". In effect,
> degraded arrays would produce that error with lilo with certain versions
> of kernel 2.6.x

Ah, okay.  This would make sense, yes.  But it creates a catch-22 situation 
because I can't add the missing drive to the array when I have booted off 
that single drive, and I can't boot off the array due to this lilo error.
Not that that can't be fixed...

Maarten

