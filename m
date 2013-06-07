From: Alexander Zvyagin <zvyagin.alexander@gmail.com>
Subject: Re: Is this expected RAID10 performance?
Date: Fri, 7 Jun 2013 10:07:59 +0200
Message-ID: <CAGqvA+svdBvWTbwnzQjoHWQz6n0iEaAZzmu-EqKqdPx-AK0Zkg@mail.gmail.com>
References: <CAO9HMNH4eFyshhhohw0wQ13j98BTRELTiWF9uDLp3vmFsOEfwQ@mail.gmail.com>
 <CAAMCDefb7TFXDOD7=aK-FjHVCQXMdiQKdz=CFJT4+q9rKR3KGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAMCDefb7TFXDOD7=aK-FjHVCQXMdiQKdz=CFJT4+q9rKR3KGA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: Steve Bergman <sbergman27@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> And it is also possible that running more disks at the same time
> cannot be sustained by the on-board chipset.

to check this, start "dd" or "badblocks" or something similar (which
will put disk to 100% load) on all your drives one-by-one and monitor
throughput with "iostat" (or similar). Yam may face the following
'problem':
1. start badblocks on /dev/sda, throughput is 140 MB/s
2. start badblocks on /dev/sdb, throughput is 140 MB/s on /dev/sda and /dev/sdb
3. start badblocks on /dev/sdc, throughput is 140 MB/s on /dev/sda and
70 MB/s on /dev/sdb,/dev/sdc

Alexander
