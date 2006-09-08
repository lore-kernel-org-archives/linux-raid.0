From: Mark Smith <nanog@fa1c52f96c54f7450e1ffb215f29991e.nosense.org>
Subject: Re: Interesting RAID checking observations - I'm getting it too
Date: Fri, 8 Sep 2006 19:00:30 +0930
Message-ID: <20060908190030.2aa781d8.nanog@fa1c52f96c54f7450e1ffb215f29991e.nosense.org>
References: <20060830192410.332db788.nanog@fa1c52f96c54f7450e1ffb215f29991e.nosense.org>
	<44FC578D.5020704@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44FC578D.5020704@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Bill,

On Mon, 04 Sep 2006 12:42:53 -0400
Bill Davidsen <davidsen@tmr.com> wrote:

> 
> 
> 
> Mark Smith wrote:
> 
> >
> Interesting, but do you run other stuff at that time? Several 
> distributions run various things in the middle of the night which really 
> bog the machine.
> 

Doesn't look like it. Shifted the check to 3.00am, 4.00am period is now
"all nothing" :

00:01:01          CPU     %user     %nice   %system   %iowait    %steal     %idle
.
.
03:56:02          all      0.85      0.00      0.38      0.00      0.00     98.77
04:01:01          all      0.75      0.00      0.34      0.00      0.00     98.91
04:06:01          all      0.73      0.00      0.35      0.00      0.00     98.92
04:11:01          all      0.73      0.00      0.38      0.00      0.00     98.89
04:16:01          all      0.84      0.00      0.37      0.00      0.00     98.79
04:21:01          all      0.68      0.00      0.34      0.00      0.00     98.98
04:26:01          all      0.78      0.00      0.39      0.00      0.00     98.83
04:31:01          all      1.18      0.00      0.40      0.00      0.00     98.43
04:36:01          all      0.88      0.00      0.33      0.00      0.00     98.79
04:41:01          all      0.72      0.00      0.38      0.00      0.00     98.90
04:46:01          all      0.80      0.00      0.42      0.00      0.00     98.78
.
.

Regards,
Mark.

-- 

        "Sheep are slow and tasty, and therefore must remain constantly
         alert."
                                   - Bruce Schneier, "Beyond Fear"
