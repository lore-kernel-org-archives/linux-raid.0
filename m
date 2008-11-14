From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: OT: Tips for good hard drives for a home server
Date: Fri, 14 Nov 2008 16:41:28 +0100 (CET)
Message-ID: <alpine.DEB.1.10.0811141640140.10993@uplift.swm.pp.se>
References: <3ECBDC05781B3D48ABD520A01ABF2F9B299C974A5A@SE-EX008.groupinfra.com>  <7d86ddb90811120619vca13676tb0192676ece0cb93@mail.gmail.com>  <491CA255.4070402@tmr.com>  <alpine.DEB.1.10.0811132357390.10993@uplift.swm.pp.se>
 <a43edf1b0811140528h5f8446b7i62ae9b2496fb1632@mail.gmail.com>  <alpine.DEB.1.10.0811141437100.10993@uplift.swm.pp.se> <87f94c370811140722kf90ed6av9a3b43a8f9af82e7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370811140722kf90ed6av9a3b43a8f9af82e7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 14 Nov 2008, Greg Freemyer wrote:

> Does it also do background scans looking for unreadable sectors, or does 
> it just wait for it to occur naturally?

As far as I know, you have to issue/schedule a full scan for it to find 
the errors, it won't do continous background scanning like some hw 
controllers out there.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
