From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Spares and partitioning huge disks
Date: Sat, 15 Jan 2005 12:07:38 +0100 (CET)
Message-ID: <Pine.LNX.4.44.0501151202530.3584-100000@uplift.swm.pp.se>
References: <m58nb2-idr.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <m58nb2-idr.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 15 Jan 2005, Peter T. Breuer wrote:

> In particular you seem to be trying to do things synchronusly, when
> that's not at all necessary, or perhaps desirable. The user will get a

Well, no, I only tried to summarize what needed to be done, not the way to
accomplish it in the best way. 

Your summary reflecting my own attempt at a summary seems better, but it
seems we both agree on the merit of the concept of trying to write to a
sector that has given a read error, if we can recreate the data from other
sources such as mirror or parity. If this fails, fail the disk. Anyhow,
log what happened. 

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

