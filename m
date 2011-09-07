From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] mdadm: close parent file descriptors when starting
 mdmon.
Date: Wed, 7 Sep 2011 12:55:38 +1000
Message-ID: <20110907125538.0c76d3c6@notabene.brown>
References: <20110829154949.15993.32383.stgit@gklab-128-044.igk.intel.com>
	<20110830093157.1ae34f8c@notabene.brown>
	<679865E03F4C71419D9847EA3AACB163021C84@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <679865E03F4C71419D9847EA3AACB163021C84@IRSMSX102.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Patelczyk, Maciej" <maciej.patelczyk@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 30 Aug 2011 13:30:26 +0000 "Patelczyk, Maciej"
<maciej.patelczyk@intel.com> wrote:

> > -----Original Message-----
> > From: NeilBrown [mailto:neilb@suse.de]
> > Sent: Tuesday, August 30, 2011 1:32 AM
> > To: Patelczyk, Maciej
> > Cc: linux-raid@vger.kernel.org
> > Subject: Re: [PATCH] mdadm: close parent file descriptors when starting
> > mdmon.
> > 
> > On Mon, 29 Aug 2011 17:49:49 +0200 Maciej Patelczyk
> > <maciej.patelczyk@intel.com> wrote:
> > 
> > > When mdadm is invoked by fork-and-exec it inherits all open file
> > > descriptors and when mdadm forks to exec mdmon those file descriptors
> > > are passed to mdmon. Mdmon closes only first 97 fd and that in some
> > > cases is not enough.
> > 
> > Can you describe and actual can when it is not enough?  Maybe there is
> > some
> > other problem where mdadm is not closing things as it should.
>  
> There is one:
> CIM Server (Sfcbd - Small Footprint CIM Broker) -> registered provider 
> -> intermediate library -> mdadm -> mdmon
> 
> We register provider in Sfcbd which brings some functionality to cim server.
> It uses our library which calls mdadm (popen). Later mdadm is calling mdmon
> (fork&exec).
> 
> The problem is that Sfcbd is a server and it has more than 100 files opened.
> Open files handles are passed down to mdadm (popen behavior) and here we have
> a problem.

This is a problem with Sfcbd, or with your library.  You shouldn't allow
these file descriptor to get through to mdadm.
Ideally they should all be marked 'close on exec'.
Probably the easiest though is for your library to not use popen directly but
to write your own which closes all extra fds between fork and exec.

I really do now want mdadm to have to close fds that someone else opened
(except 0,1, and 2).

NeilBrown


