From: Tom Maddox <tmaddox@thereinc.com>
Subject: Re: Bizarre RAID "failure"
Date: Thu, 19 Feb 2004 16:44:42 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1077237882.9970.4.camel@s8n-1.thereinc.com>
References: <1077230692.28817.485.camel@s8n-1.thereinc.com>
	 <Pine.LNX.4.55.0402191434590.6370@umi.cfht.hawaii.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.55.0402191434590.6370@umi.cfht.hawaii.edu>
To: Kanoa Withington <kanoa@cfht.hawaii.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2004-02-19 at 16:39, Kanoa Withington wrote:
> It might not be related but I've seen odd behaviour with that kernel
> and XFS family when xfs_repair/XFS Recovery is run while the array is
> resyncing.
> 
> If you have the opportunity to try some tests, you might try booting
> the system without the volume mounted to avoid the automatic XFS
> checking. When the resync is complete, then try mounting the volume.
> 
> -Kanoa

Yep, tried that.  I got identical results, unfortunately.

Thanks,

Tom

