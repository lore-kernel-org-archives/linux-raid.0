From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: recovering failed raid5
Date: Sat, 29 Oct 2016 10:46:48 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1610291040570.12036@uplift.swm.pp.se>
References: <CAM97BgQLPUN=t7VKHaVG-=SrJmS_tvaxGDbo3yqMwHm8B-do_Q@mail.gmail.com> <20161027160400.GA21042@metamorpher.de> <715b259f-1e56-9606-edc4-3e5c4d57744b@shenkin.org> <20161028133304.GA11564@metamorpher.de> <b878efa4-2581-9284-90ca-170ece7219b5@turmel.org>
 <20161028234529.GA3909@metamorpher.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161028234529.GA3909@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 29 Oct 2016, Andreas Klauer wrote:

> You'd think timeouts would solve all problems. They probably don't. In 
> some exceedingly rare cases, they might not even matter at all.

My reasoning regarding timeouts, especially for home arrays is the 
following:

Turning up the timeouts to 180 means your worst case scenario is that your 
array will have a 180 second long "hiccup" in delivering data.

This can be really bad in an enterprise environment, but in a home 
environment it's merely in an inconvenience. It happens at very few times, 
and it stops your drive from being spuriously kicked out when there is a 
read error, where it being kicked out can lead to lots worse things 
happening.

So for regular use there is very little downside to set the timeouts to 
180 seconds, there are substantial upsides, and I recommend everybody with 
non-enterprise drives to do that.

I wish the kernel defaults would be changed to 180, because I see these 
default timeout settings to cause people more problems than they help.

This is of course just one piece of a larger puzzle, but it's one that 
it's important to get right.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
