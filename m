From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Assembly failure
Date: Wed, 11 Jul 2012 11:47:41 +0100
Message-ID: <20120711104741.GA31077@nsrc.org>
References: <20120710163345.GB29855@nsrc.org>
 <4FFC5CC0.8050808@profitbricks.com> <20120710170646.GA29962@nsrc.org>
 <4FFC68AB.4010801@profitbricks.com> <20120710185927.GA30164@nsrc.org>
 <20120711124316.206ab3d9@notabene.brown> <20120711075818.GA30527@nsrc.org>
 <20120711172742.2b8e13e9@batzmaru.gol.ad.jp>
 <20120711090935.GD30723@nsrc.org>
 <alpine.DEB.2.00.1207111229190.27169@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1207111229190.27169@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Christian Balzer <chibi@gol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 11, 2012 at 12:32:28PM +0200, Mikael Abrahamsson wrote:
> That is really low:
> 
> $ sudo smartctl -a /dev/sdd | grep -i load
> 193 Load_Cycle_Count        0x0032   052   052   000    Old_age   Always       -       444425

The drives had -B 254 before I changed them to -B 255. According to
hdparm(8) that should be the least aggressive power management.
