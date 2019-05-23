From: Greg KH <greg@kroah.com>
Subject: Re: Fix bad backport to stable v3.16+
Date: Thu, 23 May 2019 19:44:33 +0200
Message-ID: <20190523174433.GB29438@kroah.com>
References: <5F8253BF-1167-4A48-A3AC-E0728E1EE6CB@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5F8253BF-1167-4A48-A3AC-E0728E1EE6CB@fb.com>
Sender: stable-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, Nigel Croxon <ncroxon@redhat.com>, "linux@thorsten-knabe.de" <linux@thorsten-knabe.de>
List-Id: linux-raid.ids

On Wed, May 22, 2019 at 04:30:33PM +0000, Song Liu wrote:
> Hi, 
> 
> As reported by Thorsten Knabe <linux@thorsten-knabe.de>. 
> 
> commit 4f4fd7c5798b ("Don't jump to compute_result state from check_result state")  
> was back ported to v3.16+. However, this fix was wrong.  
> 
> Please back port the following two commits to fix this issue. 
> 
> commit a25d8c327bb4 ("Revert "Don't jump to compute_result state from check_result state"")
> commit b2176a1dfb51 ("md/raid: raid5 preserve the writeback action after the parity check")

Added to 4.4+ for now.

thanks,

greg k-h
