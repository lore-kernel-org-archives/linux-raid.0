From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: raid6 low performance 8x3tb drives in singledegraded mode(=7x3tb)
Date: Wed, 19 Sep 2012 11:31:33 -0500
Message-ID: <5059F365.8000400@hardwarefreak.com>
References: <504FD153.9090602@sandberg-consult.dk> <20120919162557.03df6af2@notabene.brown> <20120919134030.222e4b04@natsu>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120919134030.222e4b04@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: NeilBrown <neilb@suse.de>, Kasper Sandberg <kontakt@sandberg-consult.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/19/2012 2:40 AM, Roman Mamedov wrote:

> "/sys/block/md*/md/stripe_cache_size" is absolutely the first thing one should
> look at when facing a problem with md RAID5/6 write performance.

No.  The first thing one should do is verify that the md/RAID stripe is
properly aligned to physical sector boundaries on the drives, and that
the filesystem is properly aligned to the md/RAID stripe size.  If these
are not correct then tweaking stripe_cache_size isn't going to help
much, if at all.

-- 
Stan

