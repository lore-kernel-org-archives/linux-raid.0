From: Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 006 of 10] md: Set/get state of array via sysfs
Date: Wed, 31 May 2006 22:33:56 -0700
Message-ID: <20060601053356.GK2697@moss.sous-sol.org>
References: <20060601150955.27444.patches@notabene> <1060601051358.27613@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1060601051358.27613@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

* NeilBrown (neilb@suse.de) wrote:
> 
> This allows the state of an md/array to be directly controlled
> via sysfs and adds the ability to stop and array without
> tearing it down.
> 
> Array states/settings:
> 
>  clear
>      No devices, no size, no level
>      Equivalent to STOP_ARRAY ioctl

It looks like this demoted CAP_SYS_ADMIN to CAP_DAC_OVERRIDE for the
equiv ioctl.  Intentional?
