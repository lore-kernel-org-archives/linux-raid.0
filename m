From: Francois Barre <francois.barre@gmail.com>
Subject: Re: Raid on USB2 ?
Date: Fri, 17 Feb 2006 12:03:42 +0100
Message-ID: <fd8d0180602170303m395d7ffdk@mail.gmail.com>
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

2006/2/17, Ken Walker <ken.walker@manchester.ac.uk>:
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

Well... Let's say... Good luck.
I am experimenting raid1 and raid5 over firewire, which is by far much
more stable (in terms of bandwidth) than usb2. According to the tests
I made, benchmarking usb2 and firewire makes usb2 dangerous to use :
connection hangs, bus collision is somewhat hasardous, bandwidth is
not really granted.
Technically, it is really possible : you will have your usb2 drives
accessible as scsi drives, put your raid on them, test them. But
sincerely, good luck.

Regards,
