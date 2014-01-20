From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: [PATCH] raid6check.c add page size check and repair
Date: Mon, 20 Jan 2014 20:21:59 +0100
Message-ID: <52DD7757.5090008@itwm.fraunhofer.de>
References: <20140118181823.GA15757@lazy.lzy> <52DD4ABD.5060605@itwm.fraunhofer.de> <20140120182223.GA4871@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140120182223.GA4871@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Piergiorgio,

On 01/20/2014 07:22 PM, Piergiorgio Sartor wrote:
> Hi Bernd,
>
> good catch, I'm pretty sure there are even more :-)
>
> Here the re-patch, i.e. the same patch, with the free().
> This was done, with "diff -uNpr", I hope it fits your needs.

Thanks! Much better :)

> BTW, could you point me to some instruction on how to get
> the git tree of mdadm?

git clone git://git.neil.brown.name/mdadm.git

For patch management I then use 'stg' (stacked-git). But without stg, so 
directly with git and patch rebasing/stacking also works.


Hope it helps,
Bernd

