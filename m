From: Neil Brown <neilb@suse.de>
Subject: Re: Searching, but not finding...
Date: Tue, 11 May 2010 06:54:17 +1000
Message-ID: <20100511065417.204d585e@notabene.brown>
References: <AANLkTik7Ekdhv5qGMzyMu0Q5XhKq7JbaxZFLX6SKl5Zu@mail.gmail.com>
	<AANLkTinwZPdZw_kUEaV4wHRAI4n0hstu970_lyU04jt_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinwZPdZw_kUEaV4wHRAI4n0hstu970_lyU04jt_@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Boggs <BecauseImAwesome@Live.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 10 May 2010 13:07:44 -0700
Daniel Boggs <BecauseImAwesome@Live.com> wrote:

> My apologies Neil,
> 
> I tried to follow your direction and e-mail linux-raid@vger.kernel.org with
> the below e-mail, but it was returned as no longer valid.  I do not wish to
> bother you, and if you can redirect me to a better place to ask the below
> question, I will happily take direction.

linux-raid@vger.kernel.org definitely works, and I have taken the liberty of
copying this reply to that list.
I believe that vger.kernel.org is configured to reject mail containing HTML,
and you mail did contain HTML, so maybe that was the problem.

> 
> 
> After years of trial and error I am finally transferring my entire RAID to
> linux as a software RAID.  I have wanted to do it for some time, but just
> did not have the linux expertise to get it done.  My RAID 6 is building as I
> write this, but this is one feature I have not been able to locate.  Most of
> the hardware RAID I have used in the past had something called "Dynamic
> Sector Repair"  where it would do a low impact check through the raid to
> confirm and dynamically repair any damaged sectors or data. This is an
> amazing capability since it drastically reduces the likelihood of a
> catastrophic failure during a drive rebuild or some similar action.  Does
> mdadm have this capability at all?  Would it be possible to add it?  If not,
> are you aware of any apps that could?

We call this "scrubbing" mostly, and it is effecfed by:

  echo check > /sys/block/mdXX/md/sync_action

This will cause the array to read every block and check for consistency.  If
it hits a read error it will handle it the way all read errors are handled,
which is to compute the correct data from else where and write it back so the
drive has a chance to repair or relocate the sector.

It would probably make sense to add a function to mdadm to do this so that it
would be better documented by I haven't yet (though I accept patches....)

NeilBrown


> 
> If this is written in the documentation and I just missed it I apologize.
>  My understanding of linux is still on the low end.  Thank you for your
> time!
> 
>
> Daniel

