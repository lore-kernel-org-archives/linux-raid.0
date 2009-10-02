From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 0/3] md fixes for 2.6.32-rc
Date: Fri, 2 Oct 2009 14:13:07 +1000
Message-ID: <19141.32211.742547.19481@notabene.brown>
References: <20091002011747.24095.70355.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Thursday October 1
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday October 1, dan.j.williams@intel.com wrote:
> Hi Neil,
> 
> A few fixes:
> 1/ The multicore option is not ready for prime time

But it is already marked experimental...
So do we really need to revert?  or is the current code broken beyond
repair?

> 2/ A fix for raid5 init failures

Yep, thanks!

> 3/ A reminder that the fix you sent to Greg a while back has not found
>    its way upstream.

I've nagged Greg about this, thanks.

NeilBrown
