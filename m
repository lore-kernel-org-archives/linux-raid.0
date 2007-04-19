From: Gavin McCullagh <gmccullagh@gmail.com>
Subject: Re: FW: [slightly OT] expanding lvm volume group after growing raid5 array
Date: Thu, 19 Apr 2007 16:51:12 +0100
Message-ID: <20070419155112.GL30056@gmail.com>
References: <20070419113521.GF23564@gmail.com> <1391903588.1176996087946.JavaMail.root@gateway.korstad.net>
Reply-To: Gavin McCullagh <gmccullagh@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1391903588.1176996087946.JavaMail.root@gateway.korstad.net>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Korstad <dan@korstad.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

On Thu, 19 Apr 2007, Daniel Korstad wrote:

> I have used lv with my past raid sets and it is very nice, adds some
> flexibility.  
> 
> I have also done a RAID5 reshape that was in an lv.  Unfortunately, at
> the time I had an older LVM version that did not support pvresize.  So I
> was stuck with a larger RAID set and my lv would not take advantage of
> it.

Thanks.  A guy in my local LUG pointed out that I had to do a pvresize
before I could do a vgresize.

I seem to be on my way now,

Gavin

