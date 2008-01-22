From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Re: One Large md or Many Smaller md for Better Peformance?
Date: Tue, 22 Jan 2008 05:34:14 -0600
Message-ID: <4795D4B6.4070908@pobox.com>
References: <4793AE0E.609@pobox.com> <20080120215734.GD17584@teal.hq.k1024.org> <47940F31.7020907@pobox.com> <18325.21933.337369.104689@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18325.21933.337369.104689@fisica.ufpr.br>
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Carlos Carvalho wrote:

> I use reiser3 and xfs. reiser3 is very good with many small files. A
> simple test shows interactively perceptible results: removing large
> files is faster with xfs, removing large directories (ex. the kernel
> tree) is faster with reiser3.

My current main concern about XFS and reiser3 is writebacks. The default 
mode for ext3 is "journal," which in case of power failure is more 
robust than the writeback modes of XFS, reiser3, or JFS -- or so I'm 
given to understand.

On the other hand, I have a UPS and it should shut down gracefully 
regardless if there's a power failure. I wonder if I'm being too cautious?


-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
  "Keep some secrets/Never tell,
   And they will keep you very well."
    					-- Michelle Shocked
