From: Steven Ihde <sihde@cs.stanford.edu>
Subject: Re: 2.6.0: ext3 journal aborted with ext3/lvm/raid5
Date: Wed, 7 Jan 2004 13:31:11 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040107213111.GA17713@hamachi.dyndns.org>
References: <20040107205326.GA14511@hamachi.dyndns.org> <20040107210816.GQ1882@matchmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040107210816.GQ1882@matchmail.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 07, 2004 at 01:08:16PM -0800, Mike Fedyk wrote:
> On Wed, Jan 07, 2004 at 12:53:26PM -0800, Steven Ihde wrote:
> > 
> > I get "Aborting journal on device dm-x" and associated errors about
> > every week or two.  This is on a 2.6.0 kernel, ext3 filesystem running
> > on lvm over md raid5.  This has been happening since at least some
> > point in the 2.6.0-test series.
> 
> Have you run fsck on this filesystem?

I've fsck'ed it a number of times, because after the journal aborts
the fs is remounted read-only but unclean.  So I take the system down,
run fsck, fsck works (and a subsequent e2fsck -nf is clean), and then
I bring the system back up.  On the chance that there is a lingering
inconsistency in the filesystem I have rebuilt it from scratch twice
(by making a new, empty ext3 fs on the device, and copying in all the
files from a backup on another fs) and the problem persists.  So I
don't think the fs data itself is the problem.

> 
> Can you find the version of 2.6.0-test where this started?

This is a relatively new raid5 array -- I've been having this problem
ever since I created the array, which was sometime after I switched to
the 2.6.0-test series.  So I'm not claiming there is (or isn't) a
version of 2.6.0-test that works -- only that 2.6.0-test* and 2.6.0
are the only versions I've tried, and that's where I've seen the
problem.

-Steve
