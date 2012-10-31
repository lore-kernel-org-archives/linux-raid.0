From: Shaohua Li <shli@kernel.org>
Subject: Re: [RFC 1/2]raid1: only write mismatch sectors in sync
Date: Wed, 31 Oct 2012 11:25:33 +0800
Message-ID: <20121031032533.GA1487@kernel.org>
References: <20120918145710.55394bd4@notabene.brown>
 <20120919055106.GA1305@kernel.org>
 <20120919171646.6bc35ba5@notabene.brown>
 <20120920015655.GB6798@kernel.org>
 <20121017051113.GA17821@kernel.org>
 <20121018095601.7aa3238b@notabene.brown>
 <20121018011735.GA1448@kernel.org>
 <20121018122959.10bb6c87@notabene.brown>
 <20121018020134.GB1448@kernel.org>
 <20121018133657.1bd012f6@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121018133657.1bd012f6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Oct 18, 2012 at 01:36:57PM +1100, NeilBrown wrote:
> On Thu, 18 Oct 2012 10:01:34 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > On Thu, Oct 18, 2012 at 12:29:59PM +1100, NeilBrown wrote:
> > > On Thu, 18 Oct 2012 09:17:35 +0800 Shaohua Li <shli@kernel.org> wrote:
> > >  
> > > > > > Neil,
> > > > > > any further comments on this? This is a usable feature, I hope we can have some
> > > > > > agreements.
> > > > > 
> > > > > You still haven't answered my main question, which possibly means I haven't
> > > > > asked it very clearly.
> > > > > 
> > > > > You are saying that this new behaviour should not be the default and I think
> > > > > I agree.
> > > > > So the question is:  how it is selected?
> > > > > 
> > > > > You cannot expect the user to explicitly enable it any time a resync or
> > > > > recovery starts that should use this new feature.  You must have some
> > > > > automatic, or semi-automatic, way for the feature to be activated, otherwise
> > > > > it will never be used.
> > > > > 
> > > > > I'm not asking "when should the feature be used" - you've answered that
> > > > > question a few time and it really isn't an issue.
> > > > > The question it "What it the exact process by which the feature is turned on
> > > > > for any particular resync or recovery?"
> > > > 
> > > > So you worried about users don't know how to correctly select the feature. An
> > > > experienced user knows this, the usage scenario I mentioned describes how to do
> > > > the decision. For example, a resync after system crash should enable the
> > > > feature. I admit an inexperienced user doesn't know how to select it, but this
> > > > isn't a big problem to me. There are a lot of tunables in the kernel (even MD),
> > > > which can significantly impact kernel behavior. These tunables are just for
> > > > experienced users.
> > > > 
> > > > Thanks,
> > > > Shaohua
> > > 
> > > 
> > > You still aren't answering my question.
> > > 
> > > What exactly, precisely, specifically, will an "experienced user" do?
> > 
> > Set something to a sysfs entry to enable the feature (like my RFC patch does to
> > have a new sysfs entry for the feature), and readd disk. resync then does 'only
> > write mismatch data'. Is this what you asked?

sorry for the delay.
 
> Yes, that is the sort of thing I was asking for.
> When you say "readd disk" I assume you mean to use the --readd option to
> mdadm.
> The only works when there is a bitmap active on the array,  so relatively few
> blocks will be resynced so does it really matter which approach is taken?
> Always copy, or read-and-test?
> 
> Though maybe you really mean to "--add" the device.  In that case it would
> probably make sense to add some other option to mdadm to say "enable
> read-mostly recovery".  I wonder what a good name would be.
> --minimize-writes ??

Yep, it's '--add' case. For the '--readd' with bitmap case, bitmap can already
avoid a lot of write already. The useage case is something like:
one disk is broken; trim whole disk of a new disk; add the new disk
If source disk has a lot of 0 and we only write mismatch data, we can avoid
write a lot.

I believe we need such mechanism for '--create' too, if the first disk has some
data, but the second disk is empty.
 
> You earlier gave a list of scenarios in which you thought this would be
> useful.  It was:
> 
> > > > For 'compare and avoid write if equal' case:
> > > > 1. update SSD firmware. This doesn't change the data, but we need take one disk
> > > > off from the raid one time.
> > > > 2. One disk has errors, but these errors don't ruin most of the data (for
> > > > example, a pcie error)
> > > > 3. driver/os crash.
> > > > In all these cases, two raid disks must be resync, and they have almost identical
> > > > data. write avoidness will be very helpful for these.  
> 
> 
> For case '3', it would be a "resync" rather than a "recovery".  How would you
> expect an "advanced user" to choose read-and-test recovery in that case?
> There is no "readd" command happening.

If there is bitmap, maybe we don't need do read-and-test, so this one isn't
very necessary in current stage. If not, what I suggested is:
1. user suspends resync (write something to a sysfs file)
2. user enables read-and-test (again, write a sysfs file)
3. resume resync

Thanks,
Shaohua
