From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: how to clone a disk
Date: Sat, 11 Mar 2006 19:54:06 -0500
Message-ID: <1142124846.27020.59.camel@localhost.localdomain>
References: <1142038562.20484.234.camel@localhost.localdomain>
	 <dd43dcfb0603110353g1a4d51f6y9fe4caa4007b6e9c@mail.gmail.com>
	 <1142114892.27020.7.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0603111608480.21574@twinlark.arctic.org>
	 <1142122974.27020.43.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0603111623520.21574@twinlark.arctic.org>
	 <1142123767.27020.57.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0603111641320.21574@twinlark.arctic.org>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0603111641320.21574@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: "Paul M." <paul@gpmidi.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2006-03-11 at 16:47 -0800, dean gaudet wrote:
> On Sat, 11 Mar 2006, Ming Zhang wrote:
> 
> > On Sat, 2006-03-11 at 16:31 -0800, dean gaudet wrote:
> > > if you fail the disk from the array, or boot without the failing disk, 
> > > then the event counter in the other superblocks will be updated... and the 
> > > removed/failed disk will no longer be considered an up to date 
> > > component... so after doing the ddrescue you'd need to reassemble the 
> > > raid5.  i'm not sure you can convince md to use the bitmap in this case -- 
> > > i'm just not familiar enough with it.
> > 
> > i am little confused here. then what the purpose of that bitmap for? is
> > not that bitmap is for a component temporarily out of place and thus out
> > of sync a bit?
> 
> hmm... yeah i suppose that is the purpose of the bitmap... i haven't used 
> bitmaps yet though... so i don't know which types of events they protect 
> against.  in theory what you want to do sounds like it should work though, 
> but i'd experiment somewhere safe first.

yes, need to see if can find bitmap usage and purpose from archive here
or google.


> 
> -dean

