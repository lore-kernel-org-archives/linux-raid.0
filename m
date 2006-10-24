From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Raid5 or 6 here... ?
Date: Tue, 24 Oct 2006 15:45:18 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0610241541351.24361@lion.drogon.net>
References: <4535F660.90901@cgv.tugraz.at> <Pine.LNX.4.56.0610241125580.24361@lion.drogon.net>
 <453E2472.8090207@dgreaves.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <453E2472.8090207@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 24 Oct 2006, David Greaves wrote:

> Gordon Henderson wrote:
> >    1747 ?        S<   724:25 [md9_raid5]
> >
> > It's kernel 2.6.18 and
>
> Wasn't the module merged to raid456 in 2.6.18?

Ah, was it? I might have missed that...

> Are your mdx_raid6's earlier kernels. My raid 6 is on 2.7.17 and says _raid6

Yes - earlier ones are < 2.6.18.

> Could it be that the combined kernel thread is called mdX_raid5

If this is the case, then yes! It just seemed a bit odd to me ...

Cheers,

Gordon
