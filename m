From: "George Spelvin" <linux@horizon.com>
Subject: Re: 2.6.26-rc8 deadlock: RAID code?
Date: Sun, 06 Jul 2008 02:49:04 -0400
Message-ID: <20080706064904.10507.qmail@science.horizon.com>
References: <20080704125551.24267.qmail@science.horizon.com>
 <e9c3a7c20807050854o330279f7x3d64b1ec263f8800@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756281AbYGFGtV@vger.kernel.org>
In-Reply-To: <e9c3a7c20807050854o330279f7x3d64b1ec263f8800@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux@horizon.com, dan.j.williams@intel.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

"Dan Williams" <dan.j.williams@intel.com> wrote:
> Are you running with CONFIG_NUMA=n?  If so, you may be seeing the
> effects of kswapd not running. See the patch at:
>
>      http://marc.info/?l=linux-mm&m=121510360428340&w=2

Indeed I am.  My apologies for not including the kernel config.
That's in -rc9, so I've rebased to that and we'll see what happens.

Thank you so much!
