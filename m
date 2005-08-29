From: Patrick Hoover <phoover.eml@gmail.com>
Subject: Re: RAID-5 Expansion
Date: Mon, 29 Aug 2005 16:32:58 -0400
Message-ID: <b53b67d205082913321114b4be@mail.gmail.com>
References: <b53b67d205082913057e3bacd3@mail.gmail.com>
	 <005901c5acd5$fff03130$bd00a8c0@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <005901c5acd5$fff03130$bd00a8c0@NCNF5131FTH>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I had come across EVMS. It seems like overkill for me to go that route
when I am just looking for a one-time resize. A few years back I had
used "raidreconf" to successfully resize an array. Given its age and
the reports I have seen, I can't use that. If we are being forced down
the EVMS path, I'll consider it. However, it would be much more
convenient to have a utility that works directly with the RAID-5
array.


-Pat

On 8/29/05, David M. Strang <dstrang@shellpower.net> wrote:
> EMVS supports this --
> 
> http://evms.sourceforge.net
> 
> However, in my experience -- it's really slow; and it was faster for me to
> backup the data to tape; recreate the raid and restore.
> 
> It may be faster now; that was under release v2.5.1
> 
> David M. Strang
> 
> 
> ----- Original Message -----
> From: Patrick Hoover
> To: linux-raid
> Sent: Monday, August 29, 2005 4:05 PM
> Subject: RAID-5 Expansion
> 
> 
> Is the only way to increase the size of a RAID-5 array to push the
> data somewhere else and create a new array including the new device?
> This is the only solution I have come across so far.
> 
> 
> -Pat
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
>
