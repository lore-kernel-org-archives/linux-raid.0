From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 08/29] drivers, md: convert mddev.active from atomic_t to
 refcount_t
Date: Thu, 9 Mar 2017 09:11:54 -0800
Message-ID: <20170309171154.zlcz63uqikzyu5hz@kernel.org>
References: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
 <1488810076-3754-9-git-send-email-elena.reshetova@intel.com>
 <20170307190449.baceyzzngsz776x7@kernel.org>
 <2236FBA76BA1254E88B949DDB74E612B41C5606B@IRSMSX102.ger.corp.intel.com>
 <20170308101914.GB15198@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170308101914.GB15198@kroah.com>
Sender: linux-raid-owner@vger.kernel.org
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Mar 08, 2017 at 11:19:14AM +0100, gregkh@linuxfoundation.org wrote:
> On Wed, Mar 08, 2017 at 09:42:09AM +0000, Reshetova, Elena wrote:
> > > On Mon, Mar 06, 2017 at 04:20:55PM +0200, Elena Reshetova wrote:
> > > > refcount_t type and corresponding API should be
> > > > used instead of atomic_t when the variable is used as
> > > > a reference counter. This allows to avoid accidental
> > > > refcounter overflows that might lead to use-after-free
> > > > situations.
> > > 
> > > Looks good. Let me know how do you want to route the patch to upstream.
> > 
> > Greg, you previously mentioned that driver's conversions can go via your tree. Does this still apply?
> > Or should I be asking maintainers to merge these patches via their trees? 
> 
> You should ask them to take them through their trees, if they have them.
> I'll be glad to scoop up all of the remaining ones that get missed, or
> for subsystems that do not have trees.

ok, applied, thanks!
