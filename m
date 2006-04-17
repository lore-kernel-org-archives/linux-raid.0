From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: accessing mirrired lvm on shared storage
Date: Mon, 17 Apr 2006 14:15:11 -0400
Message-ID: <170fa0d20604171115v53347680r36a1792cbd98676e@mail.gmail.com>
References: <44355BC9.4020608@mailing.kaufland-informationssysteme.com>
	 <20060407134636.2bce1917@mwdsp001>
	 <17468.32144.316047.478627@cse.unsw.edu.au>
	 <170fa0d20604130757s22407500ude1bcc16d499273@mail.gmail.com>
	 <17474.51965.988298.906463@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17474.51965.988298.906463@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/16/06, Neil Brown <neilb@suse.de> wrote:
> On Thursday April 13, snitzer@gmail.com wrote:
> > On 4/12/06, Neil Brown <neilb@suse.de> wrote:
> >
> > > One thing that is on my todo list is supporting shared raid1, so that
> > > several nodes in the cluster can assemble the same raid1 and access it
> > > - providing that the clients all do proper mutual exclusion as
> > > e.g. OCFS does.
> >
> > Very cool... that would be extremely nice to have.  Any estimate on
> > when you might get to this?
> >
>
> I'm working on it, but there are lots of distractions....
>
> The first step is getting support into the kernel for various
> operations like suspending and resuming IO and resync.
> That is progressing nicely.

Sounds good... will it be possible to suspend/resume IO to only
specific members of the raid1 (aka partial IO/resync suspend/resume)? 
If not I have a tangential raid1 suspend/resume question: is there a
better/cleaner way to suspend and resume a raid1 mirror than removing
and re-adding a member?

That is you:
1) establish a 2 disk raid1
2) suspend the mirror but allow degraded changes to occur  (remove member?)
3) after a user specified interval resume the mirror to resync (re-add member?)
4) goto 2

Using the write-intent bitmap the resync should be relatively cheap. 
However, would it be better to just use mdadm to tag a member as
write-mostly and enable write-behind on the raid1?  BUT is there a way
to set the write-behind to 0 to force a resync at a certain time (it
would appear write-behind is a create-time feature)?

thanks,
mike
