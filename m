From: vinnakota chaitanya <chaitanyaa_v@yahoo.com>
Subject: Re: Implementing Encryption and Decryption in Raid Device Driver.
Date: Wed, 14 Sep 2005 03:16:40 -0700 (PDT)
Message-ID: <20050914101640.46658.qmail@web54713.mail.yahoo.com>
References: <20050914080425.GA11729@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050914080425.GA11729@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Everybody,

Actually I forgot to mention the kernel I'am working
on, it is Montavista Kernel 2.4.19. In 2.4.19 there is
not support for dm_crypt i.e CONFIG_DM_CRYPT.

Hence for encryption/decryption , the hooks
raid5_make_request and raid5_end_read_request are
suggestable or not.

Please  suggest an approach.

Thanks & Regards
Chaitanya.

--- Luca Berra <bluca@comedia.it> wrote:

> On Tue, Sep 13, 2005 at 10:14:47PM -0700, vinnakota
> chaitanya wrote:
> >Hello Friends,
> > 
> >I'am working on a "RAID 5 Controller" device to
> which
> >4 SATA hard drives are connected each of size 80GB.
> > 
> >My requirement is implementing encryption &
> >decrpyption for the device. As we don't have any
> >filesystem on the target, we are falling on raid
> >device driver . The first thing I want to ask is 
> > 
> > 1. Whether this approach is recommendable or not.
> 
> why do you want to implement encryption in the raid
> engine,
> we already have more than one implementation that
> plugs nicely over the
> raid (dm-crypt or loop-AES), imho we don't need
> anither one, and it does
> not belong in the raid driver anyway, it is better
> to stack multiple
> components that do their job well, instead 
> 
> -- 
> Luca Berra -- bluca@comedia.it
>         Communication Media & Services S.r.l.
>  /"\
>  \ /     ASCII RIBBON CAMPAIGN
>   X        AGAINST HTML MAIL
>  / \
> -
> To unsubscribe from this list: send the line
> "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
> 


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
