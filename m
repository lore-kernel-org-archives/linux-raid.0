From: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Subject: Re: [RFC PATCH 0/4] md/mdadm: introduce request function mode support
Date: Tue, 17 Jun 2014 15:20:53 +0200
Message-ID: <53A040B5.5050008@profitbricks.com>
References: <20140602202050.14903534@notabene.brown> <1401901802-16296-1-git-send-email-sebastian.riemer@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1401901802-16296-1-git-send-email-sebastian.riemer@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Sebastian Parschauer <sebastian.riemer@profitbricks.com>
List-Id: linux-raid.ids

Hi Neil,

have you already had the time to look at these patches?

We have this in production with cfq scheduler already on two storage
servers and customers noticed a huge performance boost. Also our
monitoring shows higher and smoother iop numbers.

Cheers,
Sebastian


On 04.06.2014 19:09, Sebastian Parschauer wrote:
> Patches apply to linux v3.15-rc8 and mdadm master commit 8a3544f895.
> 
> Florian-Ewald Mueller (3):
>       md: complete bio accounting and add io_latency extension
>       md: introduce request function mode support
>       md: handle IO latency accounting in rqfn mode
> 
> Sebastian Parschauer (1):
>       mdadm: introduce '--use-requestfn' create/assembly option
> 

