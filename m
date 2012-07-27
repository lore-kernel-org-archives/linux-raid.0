From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID10 Performance
Date: Fri, 27 Jul 2012 08:05:22 -0400
Message-ID: <50128402.5040004@turmel.org>
References: <50115123.1020900@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50115123.1020900@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Adam,

On 07/26/2012 10:16 AM, Adam Goryachev wrote:
> Hi all,
> 
> I've got a system with the following config that I am trying to improve
> performance on. Hopefully you can help guide me in the best direction
> please.
> 
> 1 x SSD (OS drive only)
> 3 x 2TB WDC WD2003FYYS-02W0B1
> 
> The three HDD's are configured in a single RAID10 (I configured as
> RAID10 to easily support adding additional drives later, I realise/hope
> it is currently equivalent to RAID1)
> md0 : active raid10 sdb1[0] sdd1[2](S) sdc1[1]
>       1953511936 blocks super 1.2 2 near-copies [2/2] [UU]

In addition to Stan's comments, you should know that MD raid10 is not
reshapeable yet.  You cannot use --grow to increase that array's
capacity.

That feature is in the roadmap, so you can expect it eventually.

HTH,

Phil

