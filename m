From: Thomas Grawert <thomasgrawert0282@gmail.com>
Subject: Re: help requested for mdadm grow error
Date: Mon, 25 May 2020 21:05:20 +0200
Message-ID: <4891e1e8-aaee-b36b-4131-ca7deb34defd@gmail.com>
References: <7d95da49-33d8-cd4d-fa3f-0f3d3074cb30@gmail.com>
 <5ECC09D6.1010300@youngman.org.uk>
 <ff4ea9cd-ab35-0990-5946-4a72d4021658@gmail.com>
 <5ECC1488.3010804@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5ECC1488.3010804@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The EFAX had me worried a moment, but these are 12TB Reds? That's fine.
> A lot of the smaller drives are now shingled, ie not fit for purpose!
>
> Debian 10 - I don't know my Debians - how up to date is that? Is it a
> new kernel with not much backports, or an old kernel full of backports?
>
> What version of mdadm?
>
>
> That said, everything looks good. There are known problems - WITH FIXES
> - growing a raid 5 so I suspect you've fallen foul of one. I'd sort out
> a rescue disk that you can boot off as you might need it. Once we know a
> bit more the fix is almost certainly a rescue disk and resume the
> reshape, or a revert-reshape and then reshaping from a rescue disk. At
> which point, you'll get your array back with everything intact.

yes, that´s the 12TB WD-Red - I´m using five pieces of it.

The Debian 10 is the most recent one. Kernel version is 4.9.0-12-amd64. 
mdadm-version is v3.4 from 28th Jan 2016 - seems to be the latest, 
because I can´t upgrade to any newer one using apt upgrade.

I don´t think I need a rescue disk, because the raid isn´t bootable. 
It´s simply a big storage.

Thanks a lot for your support.
