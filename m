From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-6: help wanted
Date: Fri, 29 Oct 2004 19:33:46 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41829B1A.2000900@zytor.com>
References: <20041029114823.GA6431@jim.sh> <200410291256.i9TCuIN13270@www.watkins-home.com> <20041029181514.GA8346@jim.sh> <41829423.2080201@zytor.com> <20041029192132.GA10079@jim.sh>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041029192132.GA10079@jim.sh>
To: Jim Paris <jim@jtan.com>
Cc: Guy <bugzilla@watkins-home.com>, 'Neil Brown' <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jim Paris wrote:
> 
> Why dynamic?  Are there problems with just pregenerating all 256
> optimized codepaths?
> 

Right, you could do that, of course, but it still amounts to 256 code 
paths that have to be generated, a framework to do them with (since gcc 
doesn't generate SSE-2 code properly, for example), and then figure out 
if it was all worth it at the end.

Given that the RAID-6 module is already quite large, I'm not so sure 
it's a win.

	-hpa

