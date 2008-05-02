From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/3] md: ping userspace on 'write-pending' events
Date: Fri, 2 May 2008 12:10:20 +1000
Message-ID: <18458.30732.453556.480932@notabene.brown>
References: <20080430011826.20468.93265.stgit@dwillia2-linux.ch.intel.com>
	<20080430011933.20468.45086.stgit@dwillia2-linux.ch.intel.com>
	<18457.19136.168378.816525@notabene.brown>
	<e9c3a7c20805011357h2e4944a1t653018ed00c66179@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Thursday May 1
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday May 1, dan.j.williams@intel.com wrote:
> 
> [ thinking out loud here to make sure we are on the same page ]
> 
> I had to convince myself that it is still holding off writes while
> MD_CHANGE_DEVS is set.  And yes, MD_CHANGE_PENDING is not cleared
> until after MD_CHANGE_DEVS is handled.  So, the mddev->flags==0 test
> was indeed more restrictive than it needed to be.  Adding the
> unqualified wait_event() to md_allow_write() also makes sense since it
> is needed in the 'external' case and should be a nop in the
> '!external' case since those bits are cleared in md_update_sb().
> 
> Simple test confirms this is working as expected.

Good, thanks.

NeilBrown
