From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [PATCH 001 of 5] md: Avoid oops when attempting to fix read errors on raid10
Date: Mon, 1 May 2006 14:52:50 -0700
Message-ID: <20060501215250.GA11226@kroah.com>
References: <20060428124313.29510.patches@notabene> <1060428025015.30731@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1060428025015.30731@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
List-Id: linux-raid.ids

On Fri, Apr 28, 2006 at 12:50:15PM +1000, NeilBrown wrote:
> 
> We should add to the counter for the rdev *after* checking
> if the rdev is NULL !!!
> 
> Signed-off-by: Neil Brown <neilb@suse.de>

Queued to -stable, thanks.

greg k-h
