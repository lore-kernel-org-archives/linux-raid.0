From: Martin Hermanowski <martin@martin.mh57.net>
Subject: Re: raid1 over lvm and nbd => recovery thread fails
Date: Tue, 9 Jul 2002 19:25:55 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020709172555.GJ15958@martin.mh57.net>
References: <20020705105215.GK26595@martin.mh57.net> <Pine.LNX.4.10.10207071427540.7165-100000@clements.sc.steeleye.com> <20020707210745.GF15958@martin.mh57.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020707210745.GF15958@martin.mh57.net>
To: Paul Clements <clemep@steeleye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jul 07, 2002 at 11:07:45PM +0200, Martin Hermanowski wrote:
[...]
>> I can give you some patches that will most likely fix these problems, if
>> you are willing/able to patch your kernel. Or, as I said, you can wait until
>> 2.4.19 is available.
> 
> I surely would like to try this.
> 
> Thanks for your explanation.
> I will post the results with your patches/with 2.4.19 when available.

I installed the patch for md, and now it seems to work stable. Thanks!
