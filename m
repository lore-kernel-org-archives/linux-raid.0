From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: recovery from multiple failures
Date: Mon, 9 Jan 2012 02:08:21 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1201090204370.30451@uplift.swm.pp.se>
References: <eu9pt8xa4l.ln2@goaway.wombat.san-francisco.ca.us> <4F0A30CD.60904@turmel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F0A30CD.60904@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Keith Keller <kkeller@wombat.san-francisco.ca.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 8 Jan 2012, Phil Turmel wrote:

> - From what I can see, you should use "--assemble --force".  The wiki does
> not recommend this, but is wrong.  There is no advantage to "--create
> - --assume-clean" in this situation, and opportunities for catastrophic
> destruction.  Only if "--assemble --force" fails, and not from "device in use"
> reports, should you move to "--create".

I totally agree here. People generally go to --create way too early in the 
recovery process, partly due to several recommendations out there on wikis 
and other guides. I've seen numerous people wreck their data due to 
getting this wrong (order or offset wrong, or forgetting --assume-clean 
and forgetting to go read-only on fsck, etc).

Does someone have some history on the reason for this recommendation, and 
do we have consensus on the recommendation that --assemble --force is 
*always* better to try before going to --create --assume-clean?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
