From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: Disappointing performance of copy (MD raid + XFS)
Date: Tue, 15 Dec 2009 10:53:23 -0600
Message-ID: <4B27BF03.6090602@sandeen.net>
References: <4B204334.1000605@shiftmail.org> <4B207620.3060605@sandeen.net>	 <4B21A34C.9090100@shiftmail.org>  <20091211032610.GH30608@discord.disaster> <1260895872.7209.46.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1260895872.7209.46.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Kasper Sandberg <postmaster@metanurb.dk>
Cc: Dave Chinner <david@fromorbit.com>, Asdo <asdo@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>, =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>, Gabor Gombas <gombasg@sztaki.hu>, xfs@oss.sgi.com
List-Id: linux-raid.ids

Kasper Sandberg wrote:
> On Fri, 2009-12-11 at 14:26 +1100, Dave Chinner wrote:
>> On Fri, Dec 11, 2009 at 02:41:32AM +0100, Asdo wrote:
>>> I have checked the other problem I had which I was mentioning, that I  
> <snip>
>>> Also with noalign and rotorstep at 255 the stripe_cache_size stays  
>>> usually in the lower half (below 16000 out of 32000) while with defaults  
>>> it's stuck for most of the time at the maximum and processes are stuck  
>>> sleeping in MD locks for this reason.
>> That really does sound like a misaligned filesystem - the stripe
>> cache will grow larger the more RMW cycles that need to be
>> performed...
> Sorry to interrupt, I would very much like to see if my array/xfs is
> properly aligned and all that stuff which has been mentioned inhere,
> could any of you please post the things required to check? filesystem is
> straight on md raid6, debian lenny.
> 
> 
> <snip>
> 

use xfs_info on your mountpoint, and compare the stripe unit and width
to what md tells you.  xfs_info stripe unit/width output is in fs blocks
units.

-Eric
