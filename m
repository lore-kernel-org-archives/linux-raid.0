From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Assembly failure
Date: Wed, 11 Jul 2012 12:32:28 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207111229190.27169@uplift.swm.pp.se>
References: <20120710163345.GB29855@nsrc.org> <4FFC5CC0.8050808@profitbricks.com> <20120710170646.GA29962@nsrc.org> <4FFC68AB.4010801@profitbricks.com> <20120710185927.GA30164@nsrc.org> <20120711124316.206ab3d9@notabene.brown> <20120711075818.GA30527@nsrc.org>
 <20120711172742.2b8e13e9@batzmaru.gol.ad.jp> <20120711090935.GD30723@nsrc.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120711090935.GD30723@nsrc.org>
Sender: linux-raid-owner@vger.kernel.org
To: Brian Candler <B.Candler@pobox.com>
Cc: Christian Balzer <chibi@gol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 11 Jul 2012, Brian Candler wrote:

>> (look at the Load_Cycle_Count in SMART)
>
> 193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       490

That is really low:

$ sudo smartctl -a /dev/sdd | grep -i load
193 Load_Cycle_Count        0x0032   052   052   000    Old_age   Always       -       444425

Most drives are rated for a load cycle count of 200-600k. All mine with 
high load-cycle-count are WD20EARS. WD20EADS doesn't do this.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
