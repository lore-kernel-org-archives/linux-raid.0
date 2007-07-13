From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [-mm PATCH 0/2] 74% decrease in dispatched writes, stripe-queue
 take3
Date: Fri, 13 Jul 2007 15:54:00 -0700
Message-ID: <20070713155400.24689606.akpm@linux-foundation.org>
References: <20070713223257.25202.74399.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070713223257.25202.74399.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: neilb@suse.de, raziebe@gmail.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 13 Jul 2007 15:35:42 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> The following patches replace the stripe-queue patches currently in -mm.

I have a little practical problem here: am presently unable to compile
anything much due to all the git rejects coming out of git-md-accel.patch.

It'd be appreciated if you could keep on top of that, please.  It's a common
problem at this time of the kernel cycle.  The quilt trees are much worse - Greg's
stuff is an unholy mess.  Ho hum.
