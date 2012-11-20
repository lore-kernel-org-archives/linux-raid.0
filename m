From: Joseph Glanville <joseph.glanville@orionvm.com.au>
Subject: Re: [RFC 1/2]raid1: only write mismatch sectors in sync
Date: Wed, 21 Nov 2012 04:00:17 +1100
Message-ID: <CAOzFzEjtWR_hC_qem2qB_+Z=UM_dVnJPQgswuh0yHy8+_4uvQg@mail.gmail.com>
References: <20120726080150.GA21457@kernel.org>
	<20120731155304.11c40f9b@notabene.brown>
	<CANejiEWZk6JcErw9Y6cqpotYMypQA_jvv8N0612FBq81Lo8jVQ@mail.gmail.com>
	<20120911105908.51681433@notabene.brown>
	<20120912052941.GA15827@kernel.org>
	<20120918145710.55394bd4@notabene.brown>
	<20120919055106.GA1305@kernel.org>
	<20120919171646.6bc35ba5@notabene.brown>
	<20120920015655.GB6798@kernel.org>
	<20121017051113.GA17821@kernel.org>
	<20121018095601.7aa3238b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121018095601.7aa3238b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Sorry for necro'ing a very old thread.

> You still haven't answered my main question, which possibly means I haven't
> asked it very clearly.
>
> You are saying that this new behaviour should not be the default and I think
> I agree.
> So the question is:  how it is selected?
>
> You cannot expect the user to explicitly enable it any time a resync or
> recovery starts that should use this new feature.  You must have some
> automatic, or semi-automatic, way for the feature to be activated, otherwise
> it will never be used.
>
> I'm not asking "when should the feature be used" - you've answered that
> question a few time and it really isn't an issue.
> The question it "What it the exact process by which the feature is turned on
> for any particular resync or recovery?"
>
> NeilBrown
>

Stumbled across this looking for trim and also 'compare and trim
rather than write 0's' behavior for md.
Personally where a device is non_rotational and support discard this
feature would be a big boon.
Detecting if a device is non_rotational and testing for discard
support should probably be sufficient, this is considered enough for
btrfs to switch itself into SSD mode.

It is true that older SSDs trim is quite slow. and even now trim
causes the SATA queue to be flushed but it's still much better for the
life and performance of the majority of current flash devices.
If anything for users that know they have a very strange SSD or SSD
like device the ability to disable it easy with an option on the rdev
would be good.

Especially for users that are using md in odd configurations (like 2
remote block devices on arrays that support thin provisioning for
example).
I know of atleast another user on the linux-raid list that is using md
like this and there should also be all the old users of "fast md raid"
(predecessor to write-mostly and write intent bitmap)

Joseph.

-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
