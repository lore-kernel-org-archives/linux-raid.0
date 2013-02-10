From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: help please, can't mount/recover raid 5 array
Date: Sun, 10 Feb 2013 07:29:26 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1302100728130.32644@uplift.swm.pp.se>
References: <CAHscji2-8KaKOA041VykHeA+jCEka5afgEoH=EHVGDak-D4UFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHscji2-8KaKOA041VykHeA+jCEka5afgEoH=EHVGDak-D4UFg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 9 Feb 2013, Daniel Sanabria wrote:

> After the upgrade I had to assemble the array manually and didn't get 
> any errors but I was still getting the mount problem. I went ahead and 
> recreated it with mdadm --create --assume-clean and still the smae 
> result.

Did you save mdadm --examine from the drives *before* you did this?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
