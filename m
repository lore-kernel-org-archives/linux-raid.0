From: "John Stoffel" <john@stoffel.org>
Subject: Re: Kernel RAID support
Date: Sun, 3 Sep 2006 08:50:18 -0400
Message-ID: <17658.53130.680004.690202@smtp.charter.net>
References: <44FA5261.4010207@sauce.co.nz>
	<1157256114.10326.0.camel@localhost>
	<44FA5BE1.1080706@sauce.co.nz>
	<44FAB356.1070109@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44FAB356.1070109@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Richard Scobie <richard@sauce.co.nz>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, josh@temp123.org
List-Id: linux-raid.ids


For 2.6.18-rc5-mm1, just edit drivers/md/Kconfig and change the 'if
CONFIG_BLOCK' to 'if BLOCK' and you'll be all set.  You can then run
'make oldconfig' and you should be all set.

It's a simple change, and easier than hunting down and applying a
patch at this point.  :]

-- 
VGER BF report: U 0.49976
