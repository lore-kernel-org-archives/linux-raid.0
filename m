From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH md 1 of 2] Add interface to md driver for userspace
 monitoring of events.
Date: Mon, 6 Sep 2004 11:05:54 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16699.47090.307180.958993@cse.unsw.edu.au>
References: <20040903122034.15346.patches@notabene>
	<E1C33nX-00040i-9v@notabene.cse.unsw.edu.au>
	<20040903031920.11e31d3f.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Friday September 3
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-raid.ids

On Friday September 3, akpm@osdl.org wrote:
> NeilBrown <neilb@cse.unsw.edu.au> wrote:
> >
> > Every interesting md event (device failure, rebuild, add,remove etc) gets treated 
> >  as an 'urgent data' on /proc/mdstat and cause select to return if waiting for exceptions, 
> >  and poll to return if waiting PRIority data.
> > 
> >  To collect an event, the program must re-read /proc/mdstat from start to finish,
> >  and then must select/poll on the file descriptor (or close it).
> > 
> >  Events aren't returned as a list of individual events, only as a notification
> >  that something might have happened, and reading /proc/mdstat should show what 
> >  it was.
> > 
> >  If a program opens /proc/mdstat with O_RDWR it signals that it intends
> >  to handle events.  In some cases the md driver might want to wait for
> >  an event to be handled before deciding what to do next.  For example
> >  when the last path of a multipath fails, the md driver could either
> >  fail all requests, or could wait for a working path to be provided.
> >  It can do this by waiting for the failure event to be handled, and
> >  then making the decission.  A program that is handling events should
> >  read /proc/mdstat to determine new state, and then handle any events
> >  before either calling select/poll.  By doing this, or by closing the
> >  file, the program indicates that it has done all that it plans to do
> >  about the event.
> 
> Christoph points out that this is fairly wild procfs abuse.  We want to be
> moving away from that sort of thing, not adding to it.

I guess it depends on what you mean by "wild procfs abuse"...
Given that /proc/mdstat already exists it doesn't seem too
unreasonable to add a little functionality to it.  How much does it hurt?

> 
> Is it possible to use rml's new event stuff from rc1-mm3's
> kernel-sysfs-events-layer.patch?  Or a bare netlink interface?  Or
> raidfs?

sysfs:  
  Probably.  I would like to improve sysfs support for md but I
  haven't taken the plunge yet to figure out how it all works.
  kevents may well be ok, but as you may need to handle
  multipath-failed events in times if high memory pressure, and need
  to handle it before pressure can be relieved, I prefer to minimise
  the number of kmallocs needed to get the event to userspace.

bare netlink:
  Probably perter sysfs... Funny, but I remember reading a comment in
  the code (2.4 I think, ages ago) about netlink being deprecated or
  something like that, so I never bothered looking at it.  I wonder
  what it meant.

raidfs:
  I've thought about that a couple of times, but don't think it would
  really gain us anything.  I'm not a big fan of "lots of little
  filesystems".   It sound's like an admins nightmare. 


mdadm already uses this (if it is available) and redhat ship it in
their 2.4 kernel (particularly for multipath support).  I know that
isn't a very strong argument, but given that abuse already exists (in
that mdstat exists) is it sufficient argument to justify a small
extension to that abuse?

NeilBrown

