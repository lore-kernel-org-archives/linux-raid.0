From: Neil Brown <neilb@suse.de>
Subject: Re: write-intent bitmaps
Date: Sun, 27 Jan 2008 22:21:33 +1100
Message-ID: <18332.26941.370395.885100@notabene.brown>
References: <200801272134.57690.russell@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Russell Coker on Sunday January 27
Sender: linux-raid-owner@vger.kernel.org
To: russell@coker.com.au
Cc: linux-raid@vger.kernel.org, pkg-mdadm-devel@lists.alioth.debian.org
List-Id: linux-raid.ids

On Sunday January 27, russell@coker.com.au wrote:
> http://lists.debian.org/debian-devel/2008/01/msg00921.html
> 
> Are they regarded as a stable feature?  If so I'd like to see distributions 
> supporting them by default.  I've started a discussion in Debian on this 
> topic, see the above URL for details.

Yes, it is regarded as stable.

However it can be expected to reduce write throughput.  A reduction of
several percent would not be surprising, and depending in workload it
could probably be much higher.

It is quite easy to add or remove a bitmap on an active array, so
making it a default would probably be fine providing it was easy for
an admin to find out about it and remove the bitmap is they wanted the
extra performance.

NeilBrown
