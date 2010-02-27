From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Device role question
Date: Sat, 27 Feb 2010 09:08:45 +0100
Message-ID: <20100227080845.GA2287@lazy.lzy>
References: <20100226142331.GA2328@lazy.lzy>
 <4877c76c1002262156k6675877am79a7da9b63446dc7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4877c76c1002262156k6675877am79a7da9b63446dc7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> Spare should mean that it is not currently a synced member of the
> array; in other words a hot-spare.  As I recall raid10 cannot
> currently be grown (or /may/ only be grown with VERY recent
> tools+kernels); did you maybe create a single device raid10 and try to
> grow it?

uhm, well, not really, but almost.

If I remember correctly, at least one of the arrays
with "spare", was created with missing disk, added
then later.

BTW, I also notice another array, still RAID-10,
where both the disks have "spare" role...

Thanks,

bye,

-- 

piergiorgio
