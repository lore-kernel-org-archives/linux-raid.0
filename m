From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Best way to create RAID-6 for swap partition - existing one failed
Date: Wed, 18 May 2011 17:26:03 -0500
Message-ID: <4DD4477B.3000704@hardwarefreak.com>
References: <811592.40689.qm@web65112.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <811592.40689.qm@web65112.mail.ac2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gavin Flower <gavinflower@yahoo.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, mb@gem.win.co.nz
List-Id: linux-raid.ids

On 5/18/2011 3:42 PM, Gavin Flower wrote:

> I just checked the man page for mkswap, it still recommends using a partition.

Gavin, you know who Andrew Morton is, yes?  His opinion on the subject:

http://lkml.org/lkml/2005/7/7/326

Don't know about you, but I think I'll trust Morton's opinion on this
more than the writer of the mkswap man page.  BTW, the similarities
between what I wrote earlier and Morton's comments in the lkml thread
above are not coincidental. ;)

-- 
Stan
