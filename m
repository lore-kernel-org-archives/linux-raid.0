From: Kasper Sandberg <postmaster@metanurb.dk>
Subject: Re: Disappointing performance of copy (MD raid + XFS)
Date: Tue, 15 Dec 2009 17:51:12 +0100
Message-ID: <1260895872.7209.46.camel@localhost>
References: <4B204334.1000605@shiftmail.org> <4B207620.3060605@sandeen.net>
	 <4B21A34C.9090100@shiftmail.org>  <20091211032610.GH30608@discord.disaster>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091211032610.GH30608@discord.disaster>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Asdo <asdo@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>, Kristleifur =?ISO-8859-1?Q?Da=F0ason?= <kristleifur@gmail.com>, Eric Sandeen <sandeen@sandeen.net>, Gabor Gombas <gombasg@sztaki.hu>, xfs@oss.sgi.com
List-Id: linux-raid.ids

On Fri, 2009-12-11 at 14:26 +1100, Dave Chinner wrote:
> On Fri, Dec 11, 2009 at 02:41:32AM +0100, Asdo wrote:
> > I have checked the other problem I had which I was mentioning, that I  
<snip>
> > Also with noalign and rotorstep at 255 the stripe_cache_size stays  
> > usually in the lower half (below 16000 out of 32000) while with defaults  
> > it's stuck for most of the time at the maximum and processes are stuck  
> > sleeping in MD locks for this reason.
> 
> That really does sound like a misaligned filesystem - the stripe
> cache will grow larger the more RMW cycles that need to be
> performed...
Sorry to interrupt, I would very much like to see if my array/xfs is
properly aligned and all that stuff which has been mentioned inhere,
could any of you please post the things required to check? filesystem is
straight on md raid6, debian lenny.


> 
<snip>

