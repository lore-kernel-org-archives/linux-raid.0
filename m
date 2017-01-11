From: Shaohua Li <shli@kernel.org>
Subject: Re: ANNOUNCE: mdadm 4.0 - A tool for managing md Soft RAID under
 Linux
Date: Wed, 11 Jan 2017 08:52:41 -0800
Message-ID: <20170111165241.yavdwc57v6yodx7g@kernel.org>
References: <1cd97490-e650-d98b-466a-095292dc5b98@gmail.com>
 <58751E90.5090306@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <58751E90.5090306@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bruce Dubbs <bruce.dubbs@gmail.com>
Cc: Jes Sorensen <jes.sorensen@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Brown, Neil" <neilb@suse.com>
List-Id: linux-raid.ids

On Tue, Jan 10, 2017 at 11:49:04AM -0600, Bruce Dubbs wrote:
> Jes Sorensen wrote:
> > I am pleased to announce the availability of
> >     mdadm version 4.0
> > 
> > It is available at the usual places:
> >     http://www.kernel.org/pub/linux/utils/raid/mdadm/
> > and via git at
> >     git://git.kernel.org/pub/scm/utils/mdadm/mdadm.git
> >     http://git.kernel.org/cgit/utils/mdadm/
> > 
> > The update in major version number primarily indicates this is a
> > release by it's new maintainer. In addition it contains a large number
> > of fixes in particular for IMSM RAID and clustered RAID support.  In
> > addition this release includes support for IMSM 4k sector drives,
> > failfast and better documentation for journaled RAID.
> 
> Thank you for the new release.  Unfortunately I get 9 failures running the
> test suite:
> 
> tests/00raid1...          FAILED
> tests/07autoassemble...   FAILED
> tests/07changelevels...   FAILED
> tests/07revert-grow...    FAILED
> tests/07revert-inplace... FAILED
> tests/07testreshape5...   FAILED
> tests/10ddf-fail-twice... FAILED
> tests/20raid5journal...   FAILED
> tests/10ddf-incremental-wrong-order...  FAILED

Yep, several tests usually fail. It appears some checks aren't always good.  At
least the 'check' function for reshape/resync isn't reliable in my test, I saw
07changelevelintr fails frequently.

Thanks,
Shaohua
