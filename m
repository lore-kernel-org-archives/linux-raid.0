From: Neil Brown <neilb@suse.de>
Subject: Re: How mdadm can support > 2T
Date: Thu, 16 Nov 2006 08:49:43 +1100
Message-ID: <17755.35703.792848.681255@cse.unsw.edu.au>
References: <200611151236376090234@dahuatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from  =?ISO-8859-1?Q?=20=1B$(ASaOHS!=1B(B?= on Wednesday November 15
Sender: linux-raid-owner@vger.kernel.org
To: =?gb2312?B?0+HPyNOh?= <yu_xianyin@dahuatech.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday November 15, yu_xianyin@dahuatech.com wrote:

> Ilinux-raid want to create raid0 use mdadm 2.5.6, kernel 2.6.18-iop3
> on the intel iop80331(32bit). use 5 disks, and every hard disk is
> 500G. But it can't beyond > 2T.  How can support >2T on the 32bit
> cpu ?   

Make sure you have 
   CONFIG_LBD=y
in .config.  It works just fine.

NeilBrown
