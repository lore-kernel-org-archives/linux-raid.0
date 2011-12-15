From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] md/raid5: fix bug that could result in reads from a
 failed device.
Date: Wed, 14 Dec 2011 16:02:48 -0800
Message-ID: <20111215000248.GA3543@kroah.com>
References: <20111215105439.628fe074@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111215105439.628fe074@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: stable@vger.kernel.org, linux RAID <linux-raid@vger.kernel.org>, Alexander Lyakas <alex.bolshoy@gmail.com>, tim.gardner@canonical.com
List-Id: linux-raid.ids

On Thu, Dec 15, 2011 at 10:54:39AM +1100, NeilBrown wrote:
> 
> hi Greg,
>  When I sent you a backport of 355840e for 3.0.y I messed up and missed half
>  of the required patch.  This is the other half.  So if 3.0 is still open for
>  updates I would appreciate you applying this.

Now applied, thanks for the patch.

greg k-h
