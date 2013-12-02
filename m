From: Brett Russ <brett@linux.vnet.ibm.com>
Subject: Re: [BUG,PATCH] raid1 behind write ordering (barrier) protection
Date: Mon, 02 Dec 2013 18:35:29 -0500
Message-ID: <529D1941.6000507@linux.vnet.ibm.com>
References: <528E72C8.7050909@linux.vnet.ibm.com> <529CBFBD.9070009@linux.vnet.ibm.com> <20131203100813.67814984@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131203100813.67814984@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/02/2013 06:08 PM, NeilBrown wrote:
> How about just keeping a record of whether there is a BIO_FLUSH request
> outstanding on each "behind" leg.  While there is we don't submit new
> requests.
> So we have a queue of bios for each leg which are waiting for a BIO_FLUSH to
> complete, and we send them on down as soon as it does.

In these circumstances, it's MD who's created the situation, not an upper 
layer's BIO_FLUSH.  So, we can't key off of that.  Additionally, the patch below 
also fixes another issue related to BIO_FLUSH:

 >>> +    /* If this is a flush/fua request don't
 >>> +     * ever let it go "behind".  Keep all the
 >>> +     * mirrors in sync.
 >>> +     */
 >>> +    if (bio_rw_flagged(bio, BIO_FLUSH | BIO_FUA)) {
 >>> +        set_bit(R1BIO_BehindIO, &r1_bio->state);
 >>> +        do_flush_fua =  bio->bi_rw & (BIO_FLUSH | BIO_FUA);
 >>> +    }

so we avoid the BIO_FLUSH "behind" issue that way.  This probably should be a 
separate patch...

We could divide the behind write ordering problem into two:
1) detecting the condition to protect
2) protecting against that condition

Solutions for (1) include:
a) keeping a list of behind writes
b) keeping a count of behind writes
c) ?

Solutions for (2) include:
i) blocking the I/O
j) ?

The advantages to solution (a) are:
-nothing gets blocked unless it overlaps (previously all reads would)
-list depth limited to max behind writes allowed (typically small)

I wish there were alternatives to solution (i) but recognize that since barriers 
were removed in favor of the filesystem owning the ordering problem, MD is 
effectively assuming the role of the filesystem in this case.

Thanks,
BR

