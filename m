From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2.6.23-rc7 0/3] async_tx and md-accel fixes for 2.6.23
Date: Fri, 21 Sep 2007 11:48:23 -0700
Message-ID: <20070921114823.49d00263.akpm@linux-foundation.org>
References: <20070921012141.17157.65717.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070921012141.17157.65717.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de, yur@emcraft.com, saeed.bishara@gmail.com, shannon.nelson@intel.com
List-Id: linux-raid.ids

On Thu, 20 Sep 2007 18:27:35 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Fix a couple bugs and provide documentation for the async_tx api.
> 
> Neil, please 'ack' patch #3.
> 
> git://lost.foo-projects.org/~dwillia2/git/iop async-tx-fixes-for-linus

Well it looks like Neil is on vacation or is hiding from us or something.

In which case our options would be to go ahead and merge your #3 with
our fingers crossed, or wait and do it in 2.6.23.1 or .2.

How serious is this bug which you're fixing?  Will it affect users
of "legacy" MD setups, or only those who have enabled fancy dma-engine
features?

Either way, we need to get #2 (at least) in to Linus.
