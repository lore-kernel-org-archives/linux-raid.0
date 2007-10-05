From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: raid5 growing question
Date: Fri, 5 Oct 2007 17:23:23 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710051722410.7023@p34.internal.lan>
References: <20071005193159.GA8707@csy.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071005193159.GA8707@csy.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Shane <shane@cm.nu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Fri, 5 Oct 2007, Shane wrote:

> Hello all,
>
> I have a raid5 softraid array using 6x320GB SATA drives.  I
> would like to reconfigure it to be 3x1tb SATA.  Is there a
> way to do this using the grow feature of mdadm.  IE by
> swapping 3 of the 320GB drives out for the 3 1TB drives
> allowing the resyncs to occur between swapping and then
> somehow tell mdadm to take the remaining three 320GB drives
> out of the array or would I need to just create a new array
> somehow, copy the data over and just shut the first array
> right down?
>
> Thanks,
> Shane
>
> -- 
> http://www.cm.nu/~shane/
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

There may be a way but it would be tricky, why not just move the data off 
to another 1-2TB host and then transfer it back via NFS or RSYNC?

Justin.
