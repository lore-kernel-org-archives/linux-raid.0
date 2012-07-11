From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Assembly failure
Date: Wed, 11 Jul 2012 10:09:35 +0100
Message-ID: <20120711090935.GD30723@nsrc.org>
References: <20120710163345.GB29855@nsrc.org>
 <4FFC5CC0.8050808@profitbricks.com> <20120710170646.GA29962@nsrc.org>
 <4FFC68AB.4010801@profitbricks.com> <20120710185927.GA30164@nsrc.org>
 <20120711124316.206ab3d9@notabene.brown> <20120711075818.GA30527@nsrc.org>
 <20120711172742.2b8e13e9@batzmaru.gol.ad.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120711172742.2b8e13e9@batzmaru.gol.ad.jp>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Balzer <chibi@gol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 11, 2012 at 05:27:42PM +0900, Christian Balzer wrote:
> > BTW these are all Seagate ST3000DM001. Yes, I know :-(
> > 
> Indeed, there is your problem. And on a LSI controller (which one?) to
> boot. ^o^ 
> Though the later part should be fine with a kernel as new as yours.

The drives were only bought because the supplier was out of Hitachis, and we
didn't realise the Seagates don't have ERC.  This is why the Hitachis have
moved to production, and I'm stuck with the Seagates on the dev systems :-(

> (look at the Load_Cycle_Count in SMART)

193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       490
193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       549
193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       516
193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       505
193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       76
193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       77
193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       502
193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       495
193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       550
193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       562
193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       532
193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       556

Ugh. (Two have a lower count, but maybe those are bad...)

> With direct attached drives that you can issue hdparm commands to, you can
> "fix" this deadly behavior by issuing an "apm = 255" command to them (in
> hdparm.conf, needs to be done on each boot...).

Thanks, rc.local now has:

# Set Error Recovery Control if drive supports it
for i in /dev/sd*; do /usr/sbin/smartctl -l scterc,70,70 $i >/dev/null; done
# Stop drives from spinning down
for i in /dev/sd*; do hdparm -q -B255 $i; done

Cheers,

Brian.
