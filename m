From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Q: Is this how 'check' works (on raid10 in particular)?
Date: Tue, 5 Aug 2008 12:17:40 +0200
Message-ID: <20080805101740.GB14670@rap.rap.dk>
References: <cccedfc60808030532u14cfd668vfeca77a79996d11@mail.gmail.com> <20080803125413.GA10118@rap.rap.dk> <cccedfc60808041836s37637ff2x3d65543ab7d3d105@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cccedfc60808041836s37637ff2x3d65543ab7d3d105@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Aug 04, 2008 at 08:36:33PM -0500, Jon Nelson wrote:
> The patch Keld sent me makes a significant difference:
> 
> Before:
> (Stock 2.6.25.11 x86-64 openSUSE 11.0 kernel raid10 module):   4.5h to 5.5h
> 
> After:
> Same kernel, minor changes to raid10.c and compiled:  1h 56m.
> 
> ::
> 
> Aug  4 18:37:09 turnip kernel: md: data-check of RAID array md0
> Aug  4 20:33:24 turnip kernel: md: md0: data-check done.
> 
> 
> > My idea is to do the checks in bigger blocks, then you would minimize
> > the trashing, by minimizing the number of times you need to move the
> > head.  And this would not need much change in the code. I have done a
> > patch to do this, but I have not yet tested it.

Thanks for testing it. It sounds good, and as I expected it to behave.
I think the patch is clean and I have sent it to the list and Neil for
inclusion in the tree.

Best regards
keld
