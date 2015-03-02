From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Riad scrub generated errors, should I worry?
Date: Mon, 2 Mar 2015 16:22:00 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1503021618580.20507@uplift.swm.pp.se>
References: <BLU436-SMTP203777F3704141DF5C096B898100@phx.gbl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU436-SMTP203777F3704141DF5C096B898100@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: "Wilson, Jonathan" <piercing_male@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2 Mar 2015, Wilson, Jonathan wrote:

> While the monthly scrub was running the following errors (at the bottom
> of the post, copied from syslog) were issued.

As soon as you get UNC, it's the drive reporting that it can't 
successfully read a sector. Usually this sector is then reported as 
"pending" in your SMART output.

Since the log you provided shows a lot of sectors being corrected and you 
after that have 0 pending sectors on the drive, I'd say you are now fine. 
I would run a new scrub manually in a few days just to check, but you 
might be fine going forward. There is no really good way to know, but 
generally, a drive that throws a bunch of UNC should be monitored so this 
isn't becoming a common problem. I tend to replace drives that have thrown 
these kinds of errors if it happens on any kind of regular basis.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
