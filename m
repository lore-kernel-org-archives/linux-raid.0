From: Shaohua Li <shli@kernel.org>
Subject: Re: [RFC 1/2]raid1: only write mismatch sectors in sync
Date: Thu, 18 Oct 2012 10:01:34 +0800
Message-ID: <20121018020134.GB1448@kernel.org>
References: <20120911105908.51681433@notabene.brown>
 <20120912052941.GA15827@kernel.org>
 <20120918145710.55394bd4@notabene.brown>
 <20120919055106.GA1305@kernel.org>
 <20120919171646.6bc35ba5@notabene.brown>
 <20120920015655.GB6798@kernel.org>
 <20121017051113.GA17821@kernel.org>
 <20121018095601.7aa3238b@notabene.brown>
 <20121018011735.GA1448@kernel.org>
 <20121018122959.10bb6c87@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121018122959.10bb6c87@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Oct 18, 2012 at 12:29:59PM +1100, NeilBrown wrote:
> On Thu, 18 Oct 2012 09:17:35 +0800 Shaohua Li <shli@kernel.org> wrote:
>  
> > > > Neil,
> > > > any further comments on this? This is a usable feature, I hope we can have some
> > > > agreements.
> > > 
> > > You still haven't answered my main question, which possibly means I haven't
> > > asked it very clearly.
> > > 
> > > You are saying that this new behaviour should not be the default and I think
> > > I agree.
> > > So the question is:  how it is selected?
> > > 
> > > You cannot expect the user to explicitly enable it any time a resync or
> > > recovery starts that should use this new feature.  You must have some
> > > automatic, or semi-automatic, way for the feature to be activated, otherwise
> > > it will never be used.
> > > 
> > > I'm not asking "when should the feature be used" - you've answered that
> > > question a few time and it really isn't an issue.
> > > The question it "What it the exact process by which the feature is turned on
> > > for any particular resync or recovery?"
> > 
> > So you worried about users don't know how to correctly select the feature. An
> > experienced user knows this, the usage scenario I mentioned describes how to do
> > the decision. For example, a resync after system crash should enable the
> > feature. I admit an inexperienced user doesn't know how to select it, but this
> > isn't a big problem to me. There are a lot of tunables in the kernel (even MD),
> > which can significantly impact kernel behavior. These tunables are just for
> > experienced users.
> > 
> > Thanks,
> > Shaohua
> 
> 
> You still aren't answering my question.
> 
> What exactly, precisely, specifically, will an "experienced user" do?

Set something to a sysfs entry to enable the feature (like my RFC patch does to
have a new sysfs entry for the feature), and readd disk. resync then does 'only
write mismatch data'. Is this what you asked?
