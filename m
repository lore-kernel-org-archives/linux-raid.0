From: Luca Berra <bluca@comedia.it>
Subject: Re: Implementing Encryption and Decryption in Raid Device Driver.
Date: Wed, 14 Sep 2005 10:04:26 +0200
Message-ID: <20050914080425.GA11729@percy.comedia.it>
References: <20050914051447.13030.qmail@web54703.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050914051447.13030.qmail@web54703.mail.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Sep 13, 2005 at 10:14:47PM -0700, vinnakota chaitanya wrote:
>Hello Friends,
> 
>I'am working on a "RAID 5 Controller" device to which
>4 SATA hard drives are connected each of size 80GB.
> 
>My requirement is implementing encryption &
>decrpyption for the device. As we don't have any
>filesystem on the target, we are falling on raid
>device driver . The first thing I want to ask is 
> 
> 1. Whether this approach is recommendable or not.

why do you want to implement encryption in the raid engine,
we already have more than one implementation that plugs nicely over the
raid (dm-crypt or loop-AES), imho we don't need anither one, and it does
not belong in the raid driver anyway, it is better to stack multiple
components that do their job well, instead 

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
