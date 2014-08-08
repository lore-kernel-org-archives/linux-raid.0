From: mdraid.pkoch@dfgh.net (Peter Koch)
Subject: RAID10-reshape crashed due to memory allocation problem
Date: Fri, 8 Aug 2014 18:10:13 +0200
Message-ID: <201408081610.s78GADus017788@portal.naev.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: 
References: 
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Neil,

thanks for your answers and the great job you are doing for all of us
mdraid-users.

> > Dear readers,
> >=20
> > seems like memory is leaking when a RAID10-array is reshaped.
>
> Only in Linux 3.14.
> You need commit cc13b1d1500656a20e41960668f3392dda9fa6e2
> which is in v3.14.16
>
> So even though you didn't tell me what kernel version you were using, I
> knew:-)
>
> (always report mdadm version and kernel version).

And of course you are right. In order to reshape our raid10-array
I upgraded to mdadm 3.3 and the newest longterm kernel that was
available. That was a couple of weeks ago and the newest 3.14.x
kernel was 3.14.12 :-(

Kind regards

Peter Koch
