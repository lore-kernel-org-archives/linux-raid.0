From: dean gaudet <dean@arctic.org>
Subject: Re: why partition arrays?
Date: Tue, 24 Oct 2006 17:10:59 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0610241701260.20293@twinlark.arctic.org>
References: <C59E07CE09883545BC9EC6B87E2D3C83523DBF@kdtc.tt.umist.ac.uk>
 <20061021062648.23c0bd7a@30_bodo.rupinet> <453A232E.8050401@idgmail.se>
 <453EA240.7000407@tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <453EA240.7000407@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Henrik Holst <henrik.holst@idgmail.se>, Bodo Thiesen <bothie@gmx.de>, linux-raid mailing list <linux-raid@vger.kernel.org>, Ken Walker <ken.walker@manchester.ac.uk>
List-Id: linux-raid.ids

On Tue, 24 Oct 2006, Bill Davidsen wrote:

> My read on LVM is that (a) it's one more thing for the admin to learn, (b)
> because it's seldom used the admin will be working from documentation if it
> has a problem, and (c) there is no bug-free software, therefore the use of LVM
> on top of RAID will be less reliable than a RAID-only solution. I can't
> quantify that, the net effect may be too small to measure. However, the cost
> and chance of a finger check from (a) and (b) are significant.

this is essentially why i gave up on LVM as well.

add in the following tidbits:

- snapshots stopped working in 2.6.  may be fixed by now, but i gave up 
hope and this was the biggest feature i desired from LVM.

- it's way better for performance to have only one active filesystem on a 
group of spindles

- you can emulate pvmove with md superblockless raid1 sufficiently well 
for most purposes (although as we've discussed here it would be nice if md 
directly supported "proactive replacement")

and more i'm forgetting.

-dean
