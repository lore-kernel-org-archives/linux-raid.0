From: Neil Brown <neilb@suse.de>
Subject: Re: [mdadm GIT PULL] static analysis fixes
Date: Wed, 30 Dec 2009 13:58:00 +1100
Message-ID: <20091230135800.4c08d7a1@notabene.brown>
References: <1261526978.31952.7.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1261526978.31952.7.camel@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Ed Ciechanowski <ed.ciechanowski@intel.com>, marcin.labun@intel.com, artur.wojcik@intel.com
List-Id: linux-raid.ids

On Tue, 22 Dec 2009 17:09:38 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Hi Neil, please pull from:
> 
>   git://github.com/djbw/mdadm.git klockwork
> 
> ...to receive a collection of static analysis fixes.  These are
> independent of other recent development and can be pulled separately.
> Full diff below.

I did get a conflict with validate_geometry_imsm_orom, but it was easily
sorted out.

All pulled and pushed.

Thanks,
NeilBrown
