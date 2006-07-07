From: Neil Brown <neilb@suse.de>
Subject: Re: Kernel 2.6.17 and RAID5 Grow Problem (critical section backup)
Date: Sat, 8 Jul 2006 08:38:03 +1000
Message-ID: <17582.57931.816012.142421@cse.unsw.edu.au>
References: <Pine.LNX.4.64.0607070830450.2648@p34.internal.lan>
	<Pine.LNX.4.64.0607070845280.2648@p34.internal.lan>
	<Pine.LNX.4.64.0607070849140.3010@p34.internal.lan>
	<Pine.LNX.4.64.0607071037190.5153@p34.internal.lan>
	<17582.55703.209583.446356@cse.unsw.edu.au>
	<Pine.LNX.4.64.0607071814510.8499@p34.internal.lan>
	<17582.57549.204471.855655@cse.unsw.edu.au>
	<Pine.LNX.4.64.0607071832200.8499@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Justin Piszcz on Friday July 7
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday July 7, jpiszcz@lucidpixels.com wrote:
> 
> I guess one has to wait until the reshape is complete before growing the 
> filesystem..?

Yes.  The extra space isn't available until the reshape has completed
(if it was available earlier, the reshape wouldn't be necessary....)

NeilBrown
