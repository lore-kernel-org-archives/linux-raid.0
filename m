From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: a couple of mdadm questions
Date: Tue, 9 Sep 2003 08:35:58 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16221.1102.595382.211237@gargle.gargle.HOWL>
References: <1062879895.8172.20.camel@opus>
	<16220.10893.339884.282892@gargle.gargle.HOWL>
	<20030908200903.GB15482@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Luca Berra on Monday September 8
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday September 8, bluca@comedia.it wrote:
> On Mon, Sep 08, 2003 at 05:06:53PM +1000, Neil Brown wrote:
> >You could get mdadm 1.3.0, add some patches from
> >    http://cgi.cse.unsw.edu.au/~neilb/source/mdadm/patch/applied/
> 
> just a silly question:
> 
> 003MdSuperFix
> Status: ok
> Make sure unused superblock descriptor entries aren't failed.
> This confuses 2.4 kernel code. 
> 
> do you mean that without this patch 2.4 kernel gets confused
> 
> or do you mean that this patch is harmful for 2.4
> 

The patch modifies --update=summaries to make some further
normalisations of the superblock.  At least one superblock has been
seen in the wild that was not correct (i.e. had unused descriptors
that were marked 'failed') and this superblock confused 2.4 badly.

i.e. with this patch it is possible to fix a rare condition that
confused 2.4

I hope that makes it reasonably clear :-)

NeilBrown


> regards,
> L.
> 
> -- 
> Luca Berra -- bluca@comedia.it
>         Communication Media & Services S.r.l.
>  /"\
>  \ /     ASCII RIBBON CAMPAIGN
>   X        AGAINST HTML MAIL
>  / \
