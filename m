From: Luca Berra <bluca@comedia.it>
Subject: Re: a couple of mdadm questions
Date: Mon, 8 Sep 2003 22:09:04 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030908200903.GB15482@percy.comedia.it>
References: <1062879895.8172.20.camel@opus> <16220.10893.339884.282892@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16220.10893.339884.282892@gargle.gargle.HOWL>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Sep 08, 2003 at 05:06:53PM +1000, Neil Brown wrote:
>You could get mdadm 1.3.0, add some patches from
>    http://cgi.cse.unsw.edu.au/~neilb/source/mdadm/patch/applied/

just a silly question:

003MdSuperFix
Status: ok
Make sure unused superblock descriptor entries aren't failed.
This confuses 2.4 kernel code. 

do you mean that without this patch 2.4 kernel gets confused

or do you mean that this patch is harmful for 2.4

regards,
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
