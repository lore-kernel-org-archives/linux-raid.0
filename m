From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: Riad scrub generated errors, should I worry?
Date: Mon, 02 Mar 2015 10:43:34 -0700
Message-ID: <1786620.4mivBfObx3@balsa>
References: <BLU436-SMTP203777F3704141DF5C096B898100@phx.gbl> <alpine.DEB.2.02.1503021618580.20507@uplift.swm.pp.se>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1503021618580.20507@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: "Wilson, Jonathan" <piercing_male@hotmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon 02 Mar 2015 04:22:00 PM Mikael Abrahamsson wrote:
> On Mon, 2 Mar 2015, Wilson, Jonathan wrote:
> > While the monthly scrub was running the following errors (at the bottom
> > of the post, copied from syslog) were issued.
> 
> As soon as you get UNC, it's the drive reporting that it can't
> successfully read a sector. Usually this sector is then reported as
> "pending" in your SMART output.
> 
> Since the log you provided shows a lot of sectors being corrected and you
> after that have 0 pending sectors on the drive, I'd say you are now fine.
> I would run a new scrub manually in a few days just to check, but you
> might be fine going forward. There is no really good way to know, but
> generally, a drive that throws a bunch of UNC should be monitored so this
> isn't becoming a common problem. I tend to replace drives that have thrown
> these kinds of errors if it happens on any kind of regular basis.

Dumb question, but after pending, I assume they go into the reallocated 
column? I think after a certain number of those, you should start thinking 
about a replacement. Like with my recent issues, I had two drives with a few 
too many reallocated sectors. One was over 16k and the other was over 32k. 
They still "work", but I replaced them with WD Reds anyhow. Another drive 
seemed to max out the start-stop count field at 65536. Hah. No more cheap 
desktop seagates in raid for this fellow.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
