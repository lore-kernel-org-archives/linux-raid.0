From: Neil Matai <neil@matai.kiwi.nz>
Subject: Re: Simultaneous assembly on multiple hosts
Date: Sat, 4 May 2013 15:22:26 +1200
Message-ID: <20130504032226.GE31411@chc-5.metaname.net>
References: <20130504020146.GD31411@chc-5.metaname.net>
 <CALFpzo6CUZSeAcNK1A=8HdyjaGnKiN4Mtt01u_w=3p7WG-wY2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALFpzo6CUZSeAcNK1A=8HdyjaGnKiN4Mtt01u_w=3p7WG-wY2A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 03, 2013 at 08:25:59PM -0600, Marcus Sorensen wrote:
> > Is it dangerous have an array assembled on two hosts at the same time?
> > Say I have servers A and B exporting devices a and b via ATA over
> > Ethernet or similar to hosts C and D.  If a and b are components of an
> > array then both C and D automatically assemble the array as soon as
> > the components a and b are exported but is this safe (on the proviso
> > that only one of C or D is ever writing to the array at any time and
> > that there is no write-behind caching above the array device)?
> Yes, it is dangerous. There are some limited situations where it may work,
> without a bitmap and some cluster aware application in control of what
> blocks are written, but you can't for example mount it ext4 and write to
> only one side at a time. That's why people use drbd.

Sorry.  I should have said what it was for.  I realise that mounting a
typical file system twice would be dangerous (also with drdb).  The
intention would have been to live migrate guest systems between C and
D so the file system remains mounted (once) inside the guest system
but nowhere else.  Would it work in this scenario without a bitmap or
would this scenario also lead to data loss?  Would it make any
difference if 0.9 metadata were use to create the array?

Many thanks,

- neil

