From: Mitchell Laks <mlaks@verizon.net>
Subject: Re: Need to upgrade to latest stable mdadm version?
Date: Mon, 23 Jan 2006 09:02:43 -0500
Message-ID: <200601230902.45171.mlaks@verizon.net>
References: <200601221241.54689.mlaks@verizon.net>
 <43D3C5A8.3070200@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <43D3C5A8.3070200@dgreaves.com>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday 22 January 2006 12:49 pm, David Greaves wrote:

> Just FYI
> I am running the *stock* 2.6.15 and get the same problems (ata timeouts
> etc)
>
> I recently wrote to the lkml and ide lists following up an old post.
> No replies yet.
>
> I run sata_via and sata_sil
> (I've seen just a few people with these problems - various kernels -
> all, to my recollection, seem to have two sets of sata controller
> chips.... I wonder....)
>
> I note you say the *sid* kernel doesn't have these problems so I'll try
> that. I just wanted to mention that the problem may exist on stock
> kernels 'cos you talk about rolling your own...
David! you are right!

It does not work with the debian sid 2.6.15 kernel. You were far more 
observant than I. I thought that my 2 raids were working with the debian 
2.6.15 but in fact it one of the drives had failed out of the  array (thats 
why it seemed to work, I hadn't slept enough...).

In fact your diagnosis is completely correct. I cannot get both sata_via and 
sata_promise up at the same time, without timeout problems. 

I am hereby switching exclusively to sata_promise as I can install multiple 
cards on the same machine.

Mitchell


>
> David
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
