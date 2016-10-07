From: walter harms <wharms@bfs.de>
Subject: Re: md-cluster: Delete unnecessary braces in unlock_all_bitmaps()
Date: Fri, 07 Oct 2016 15:21:14 +0200
Message-ID: <57F7A14A.3070207@bfs.de>
References: <566ABCD9.1060404@users.sourceforge.net> <3a03df66-92ce-20fb-17f3-fb79b9d43c8e@users.sourceforge.net> <ba60b210-40c6-b021-780c-33ecea7bee9e@users.sourceforge.net> <20161007074646.GA6039@mwanda> <9e1de37a-d98d-c885-b4ff-5a8b2aa1f7a8@users.sourceforge.net>
Reply-To: wharms@bfs.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9e1de37a-d98d-c885-b4ff-5a8b2aa1f7a8@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: kernel-janitors@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>, Shaohua Li <shli@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids



Am 07.10.2016 10:37, schrieb SF Markus Elfring:
>>> Do not use curly brackets at one source code place
>>> where a single statement should be sufficient.
>>
>> The original style was correct and this is wrong.  I have explained this before.
> 
> Did I change a bit too much in the proposed step according to the following
> update suggestion?
> 
> elfring@Sonne:~/Projekte/Linux/next-patched> git checkout d6385db94196b253ae5eb3678fa95cdf1f839fcc && scripts/checkpatch.pl --types BRACES -f drivers/md/md-cluster.c
> …
> WARNING: braces {} are not necessary for single statement blocks
> #1228: FILE: drivers/md/md-cluster.c:1228:
> +			if (cinfo->other_bitmap_lockres[i]) {
> +				lockres_free(cinfo->other_bitmap_lockres[i]);
> +			}
> …
> 
> 
> How do you think about to adjust this source code place a bit?
> 

perhaps we can agree to delete the if() block ?

static void lockres_free(struct dlm_lock_resource *res)
{
        int ret;

       if (!res)
                return;

....


@marcus: is can not send mail to you sf.net adresse because sf.net
         mark my domain als spam (note: nobody else does)

re,
 wh
