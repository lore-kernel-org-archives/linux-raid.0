From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: One Large md or Many Smaller md for Better Peformance?
Date: Tue, 22 Jan 2008 16:17:14 +0100
Message-ID: <479608FA.2080904@wpkg.org>
References: <4793AE0E.609@pobox.com> <20080120215734.GD17584@teal.hq.k1024.org> <47940F31.7020907@pobox.com> <18325.21933.337369.104689@fisica.ufpr.br> <4795D4B6.4070908@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4795D4B6.4070908@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: Carlos Carvalho <carlos@fisica.ufpr.br>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Moshe Yudkowsky schrieb:
> Carlos Carvalho wrote:
> 
>> I use reiser3 and xfs. reiser3 is very good with many small files. A
>> simple test shows interactively perceptible results: removing large
>> files is faster with xfs, removing large directories (ex. the kernel
>> tree) is faster with reiser3.
> 
> My current main concern about XFS and reiser3 is writebacks. The default 
> mode for ext3 is "journal," which in case of power failure is more 
> robust than the writeback modes of XFS, reiser3, or JFS -- or so I'm 
> given to understand.

Also, barriers ("barrier=1" option for ext3) are not supported on 
filesystems placed on md/dm, it's a bit of a pain.


-- 
Tomasz Chmielewski
http://wpkg.org
