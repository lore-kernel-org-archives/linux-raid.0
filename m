From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm --grow failed
Date: Sun, 18 Feb 2007 08:08:50 +1100
Message-ID: <17879.28386.46081.159672@notabene.brown>
References: <20070217030514.M74974@liquid-nexus.net>
	<45D7490E.6080309@tmr.com>
	<Pine.LNX.4.64.0702171415500.29573@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Justin Piszcz on Saturday February 17
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Marc Marais <marcm@liquid-nexus.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday February 17, jpiszcz@lucidpixels.com wrote:
> 
> Is growing an array with > 1 disk at a time permissible?  I've grown a 
> raid 5 from 1.8tb to 3.3tb but always 1 disk at a time.

Sure is.  >0 is the current requirement.
You can grow a 2 drive raid5 directly to a 10drive if you like.

NeilBrown
