From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Change Chunk Size on Array?
Date: Thu, 20 Mar 2008 04:16:02 -0400 (EDT)
Message-ID: <alpine.DEB.1.00.0803200415560.16116@p34.internal.lan>
References: <16137381.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16137381.post@talk.nabble.com>
Sender: linux-raid-owner@vger.kernel.org
To: crshman <crshman@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Wed, 19 Mar 2008, crshman wrote:

>
> Hello All,
>
> I wanted to know if it were possible to change the chunk size on an array
> after it has been created. I have a software raid 5 comprised of 7 drives
> with a chunk size of 64k. I wanted to up that to 1024k, would this be
> possible without losing any data? This isn't mission critical so it is ok if
> i need to stop the array first, however I'd rather not lose any data.
> --
> View this message in context: http://www.nabble.com/Change-Chunk-Size-on-Array--tp16137381p16137381.html
> Sent from the linux-raid mailing list archive at Nabble.com.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

You need to re-create the array.

Justin.
