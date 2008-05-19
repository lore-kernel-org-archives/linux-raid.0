From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm 2.6.5 compile issue
Date: Mon, 19 May 2008 12:09:45 +1000
Message-ID: <18480.57705.875663.14438@notabene.brown>
References: <482E0307.9020302@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Maurice Hilarius on Friday May 16
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday May 16, maurice@harddata.com wrote:
> Having grabbed sources for mdadm 2.6.5, we tried 'mdassemble.static'
> This does not really compile "as is" so it made for some head scratching moments.
> 
> If I use MDASSEMBLE_AUTO=1 with make, then mdassemble,  
> or mdassemble.static - which is now the same thing,
> does not link because sysfs.c is not on the list of mdassemble sources.
> 
> It apparently needs to be.  
> 
> This was not the case in the past.

I was looking for an excuse to release 2.6.6 quickly as there was
something I forgot to include in 2.6.5.

This was the excuse.  Try 2.6.6 :-)

Thanks,
NeilBrown
