From: Piotr Klimek <piotr@klimek.net.pl>
Subject: Re: RAID6 reshape integer problem
Date: Fri, 3 Jan 2014 14:43:01 +0100
Message-ID: <CAM8eUy2g1p5yW6fifvwn4n40Q9=ehgDU671EOmtAc+aKQuateQ@mail.gmail.com>
References: <loom.20140103T101338-556@post.gmane.org> <52C6B38E.8050804@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C6B38E.8050804@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2014/1/3 Phil Turmel <philip@turmel.org>

> > After couple of days reshape stalled on 2147483648 block. I have found that
> > this is a bug in mdadm. 2147483648 is max integer on 32 bit system. For now
> > situation looks like this:
>
> You'll certainly have to take production down long enough to let a newer
> kernel finish the reshape.  Or you could be brave and replace the kernel
> and let production continue through the balance of the reshape.
>

Is it safe to reboot during reshape and boot up with new kernel? I can
easly upgrade kernel to 3.2.0.

-- 
Regards
Piotr Klimek
