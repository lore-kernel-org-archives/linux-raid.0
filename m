From: Neil Brown <neilb@suse.de>
Subject: Re: Cutting power without breaking RAID
Date: Fri, 30 Jun 2006 11:53:00 +1000
Message-ID: <17572.33788.832563.244065@cse.unsw.edu.au>
References: <20060628214350.GA23970@rigacci.org>
	<17571.20553.319133.437688@cse.unsw.edu.au>
	<20060629094806.GB8313@rigacci.org>
	<44A42106.3040801@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Thursday June 29
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Niccolo Rigacci <niccolo@rigacci.org>, linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday June 29, davidsen@tmr.com wrote:
> Why should this trickery be needed? When an array is mounted r/o it 
> should be clean. How can it be dirty. I assume readonly implies noatime, 
> I mount physically readonly devices without explicitly saying noatime 
> and nothing whines.

The 'filesystem' is mounted r/o.  The 'array' is not read-only, and
you cannot set an array to read-only while a filesystem is mounted
(because the array cannot tell that the mount is read-only).

A little while after the last write, an array will mark itself as
clean.  The effect of the 'kill -9', is to reduce this 'little while'
to 0.

So 
  remount readonly
  wait a little while
  kill machine 

would work too.

NeilBrown
