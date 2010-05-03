From: Luca Berra <bluca@comedia.it>
Subject: Re: Questions about 4k sector drives
Date: Mon, 3 May 2010 07:54:47 +0200
Message-ID: <20100503055447.GC25863@maude.comedia.it>
References: <4BD42B57.9000703@kusche.de> <1272206601.7734.4.camel@faldara> <4BDE0512.8070502@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4BDE0512.8070502@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 02, 2010 at 07:04:50PM -0400, Bill Davidsen wrote:
> Is there any reason not to just align partitions for all drives on 32kB 
> sectors and expect that to work on 512b 4kB and SSD? Cautious testing here 
> says it works fine, no anomalies, no exciting performance data, just works.

No reason at all, consider that even microsoft decided to align
partition at 1M boundary with W2008.

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
