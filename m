From: Ewan Grantham <ewan.grantham@gmail.com>
Subject: Re: Raid on USB2 ?
Date: Fri, 17 Feb 2006 08:30:36 -0600
Message-ID: <6d5bedd80602170630n5c2e3cd8s221a8def0c9f8a1@mail.gmail.com>
References: <60F5F1E2B94AD4119F0B00B0D0215FFF01A6A25B@TEXTILES.BSC>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <60F5F1E2B94AD4119F0B00B0D0215FFF01A6A25B@TEXTILES.BSC>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Ken Walker <ken.walker@manchester.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a six disk RAID-5 array that I run using embedded Linux
(coLinux) to serve the array up using Samba to my Windows XP OS.

I've been doing this for a number of months (the dark tale is explained at:
http://a1.blogspot.com/2005/08/step-by-step-to-windows-raid-using.html),
and have had no data corruption - even when the machine has crashed
due to Windows or Power issues.

Array runs fast enough to serve video files and watch them - though
more commonly I am just copying files around. Write times are nothing
to brag about, but they aren't horrible.

Hope this helps,
Ewan

On 2/17/06, Ken Walker <ken.walker@manchester.ac.uk> wrote:
> Anybody tried a Raid1 or Raid5 on USB2.
>
> If so did it crawl or was it usable ?
>
> Many thanks
>
> Ken :o)
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
