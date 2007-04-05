From: Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: raid6 rebuild
Date: Thu, 5 Apr 2007 07:50:30 +0200
Message-ID: <20070405055030.GA6978@xi.wantstofly.org>
References: <20070404194638.GB3712@xi.wantstofly.org> <e9c3a7c20704042022p6088bdcdl97740d2a95818caf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e9c3a7c20704042022p6088bdcdl97740d2a95818caf@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: mingo@redhat.com, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 04, 2007 at 08:22:00PM -0700, Dan Williams wrote:

> >While my RAID6 array was rebuilding after one disk had failed (which
> >I replaced), a second disk failed[*], and this caused the rebuild
> >process to start over from the beginning.
> >
> >Why would the rebuild need to start over from the beginning in this
> >case?  Why couldn't it just continue from where it was?
> 
> I believe it is because raid5 and raid6 share the same error handler
> which sets MD_RECOVERY_ERR after losing any disk.  It should probably
> not set this flag in 1-disk lost raid6 case, but I might be
> overlooking something else.

Right, so you're saying that it's probably a bug rather than an
intentional 'feature'?
