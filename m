From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: read-balancing not working in 2.6?
Date: Tue, 30 Nov 2004 07:20:00 +0000 (GMT)
Message-ID: <Pine.LNX.4.58.0411300716430.15173@diagnostix.dwd.de>
References: <PERBUMSGID-ul6wtw4pevx.fsf@nfsd.linpro.no>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <PERBUMSGID-ul6wtw4pevx.fsf@nfsd.linpro.no>
Sender: linux-raid-owner@vger.kernel.org
To: Per Andreas Buer <perbu@linpro.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 29 Nov 2004, Per Andreas Buer wrote:

> 
> Hi.
> 
> We have a busy mailserver with the mail-spool on MD (raid1, consisting
> of sda and sdb, ext3 w/data=journal noatime nodiratime, 2.6.6,
> Debian Woody). The read-balancing does not seem to work properly.
> 
I had a quick look on one of my systemes, it does work there:

avg-cpu:  %user   %nice    %sys %iowait   %idle
           1.45    0.00    8.65   14.25   75.65

Device:    rrqm/s wrqm/s   r/s   w/s  rsec/s  wsec/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda          0.00 1010.18 41.92 14.97  335.33 8207.58   167.66  4103.79   150.18     1.93   33.94   3.10  17.62
sdd          0.00 1006.39 42.91 18.96  343.31 8207.58   171.66  4103.79   138.19     2.46   39.73   2.92  18.04

avg-cpu:  %user   %nice    %sys %iowait   %idle
           0.90    0.00    4.45   23.86   70.79

Device:    rrqm/s wrqm/s   r/s   w/s  rsec/s  wsec/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda          0.00 554.09 94.21 11.58  753.69 4526.95   376.85  2263.47    49.92     1.29   12.18   1.80  19.02
sdd          0.00 547.50 96.01 18.16  768.06 4526.95   384.03  2263.47    46.38     2.11   18.46   1.79  20.48

avg-cpu:  %user   %nice    %sys %iowait   %idle
           0.85    0.00    3.45    4.25   91.45

Device:    rrqm/s wrqm/s   r/s   w/s  rsec/s  wsec/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda          0.00  34.80 15.40  2.60  123.20  299.20    61.60   149.60    23.47     0.04    2.06   1.91   3.44
sdd          0.00  34.60 16.20  2.80  129.60  299.20    64.80   149.60    22.57     0.05    2.56   1.98   3.76

This is with 2.6.10-rc2-bk12.

Holger
