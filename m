From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH md 1 of 2] Add interface to md driver for userspace
 monitoring of events.
Date: Fri, 3 Sep 2004 03:19:20 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040903031920.11e31d3f.akpm@osdl.org>
References: <20040903122034.15346.patches@notabene>
	<E1C33nX-00040i-9v@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1C33nX-00040i-9v@notabene.cse.unsw.edu.au>
To: NeilBrown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-raid.ids

NeilBrown <neilb@cse.unsw.edu.au> wrote:
>
> Every interesting md event (device failure, rebuild, add,remove etc) gets treated 
>  as an 'urgent data' on /proc/mdstat and cause select to return if waiting for exceptions, 
>  and poll to return if waiting PRIority data.
> 
>  To collect an event, the program must re-read /proc/mdstat from start to finish,
>  and then must select/poll on the file descriptor (or close it).
> 
>  Events aren't returned as a list of individual events, only as a notification
>  that something might have happened, and reading /proc/mdstat should show what 
>  it was.
> 
>  If a program opens /proc/mdstat with O_RDWR it signals that it intends
>  to handle events.  In some cases the md driver might want to wait for
>  an event to be handled before deciding what to do next.  For example
>  when the last path of a multipath fails, the md driver could either
>  fail all requests, or could wait for a working path to be provided.
>  It can do this by waiting for the failure event to be handled, and
>  then making the decission.  A program that is handling events should
>  read /proc/mdstat to determine new state, and then handle any events
>  before either calling select/poll.  By doing this, or by closing the
>  file, the program indicates that it has done all that it plans to do
>  about the event.

Christoph points out that this is fairly wild procfs abuse.  We want to be
moving away from that sort of thing, not adding to it.

Is it possible to use rml's new event stuff from rc1-mm3's
kernel-sysfs-events-layer.patch?  Or a bare netlink interface?  Or raidfs?
