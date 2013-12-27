From: keld@keldix.com
Subject: Re: RAID 10 far and offset on-disk layouts
Date: Fri, 27 Dec 2013 16:19:27 +0100
Message-ID: <20131227151927.GA4003@www5.open-std.org>
References: <52BD8EDD.10809@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52BD8EDD.10809@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 27, 2013 at 03:29:49PM +0100, Gionatan Danti wrote:
> Hi all,
> I (think of) quite well understand how far and offset work, but I can 
> not find any data on the precise on-disk layout.
> 
> FAR LAYOUT
> md(4) states:
> "The first copy of all data blocks will be striped across the early part 
> of all drives in RAID0 fashion, and then the next copy of all blocks 
> will be striped across a later section of all drives, always ensuring 
> that all copies of any given block are on different drives"
> 
> The "on different drives" part let me wonder _how_ are chunks 
> distributed. On a 4-disk array, I can imagine some different schemas:
> 
> 1)	A1 A2 A3 A4
> 	.. .. .. ..
> 	A4 A1 A2 A3
> 
> 2)	A1 A2 A3 A4
> 	.. .. .. ..
> 	A2 A1 A4 A3
> 
> The first schema is the one depicted by SuSe documentation [1], while 
> the second is the one described by Wikipedia [2].
> 
> Question 1: as the two schema have different reliability 
> characteristics, which is really used?

The wikipedia description is what you get for new arrays with newer
kernels, while the suse documentation is what you will get with older kernels.
The wikipedia layout was made because there are better chances of recovery,
Chances went from 1/3 to 2/3 with eg 4 drives, when 2 drives were failing.

I would say that the Suse description is just not updated.

Best regards
Keld
