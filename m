From: Joe Pruett <joey@q7.com>
Subject: Re: large await discrepancies
Date: Tue, 10 Dec 2002 07:59:54 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0212100758160.29301-100000@q7.q7.com>
References: <Pine.LNX.4.44.0212091539330.1479-100000@q7.q7.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0212091539330.1479-100000@q7.q7.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

and here is the global iostat info after 3 days of uptime.  notice how the 
hde drive has await and svctm values that are 10x of hda.  is iostat bogus
and just leading me down a wild goose chase?

Linux 2.4.18-18.7.x.spirebigmem (atlas.spiretech.com)   12/10/2002

avg-cpu:  %user   %nice    %sys   %idle
           2.96    0.01    2.21   94.82

Device:  rrqm/s wrqm/s   r/s   w/s  rsec/s  wsec/s avgrq-sz avgqu-sz   await  svctm  %util
hde       29.13  16.34  8.04 29.97  296.93  373.03    17.63     0.04    4.24   3.05   1.16
hde1       0.08   0.00  0.00  0.00    0.17    0.00    55.79     0.00 1106.35 509.88   0.02
hde2       4.32   4.86  2.10 16.94   51.30  175.10    11.89     0.18    9.11   6.84   1.30
hde3       0.00   0.01  0.01  0.00    0.04    0.07    19.02     0.02 3027.18 2023.47   0.12
hde5      24.73  11.48  5.94 13.02  245.42  197.86    23.38     0.10   12.50  11.55   2.19
hda       32.67  15.74  8.53 30.66  329.11  373.03    17.92     0.08    6.69   4.26   1.67
hda1       0.09   0.00  0.00  0.00    0.18    0.00    59.04     0.00  135.04  68.32   0.00
hda2       4.98   4.64  2.31 17.17   58.34  175.10    11.98     0.12   19.81   6.10   1.19
hda3       0.00   0.01  0.00  0.00    0.04    0.07    19.44     0.00  210.14 147.84   0.01
hda5      27.60  11.09  6.22 13.49  270.56  197.86    23.78     0.22    7.38   2.45   0.48

