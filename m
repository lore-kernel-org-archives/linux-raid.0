From: Marc Bevand <bevand_m@epita.fr>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Fri, 30 Jul 2004 17:00:51 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <cedoda$qn4$1@sea.gmane.org>
References: <b476569a04072920533b757574@mail.gmail.com> <200407300815.18296.mrwatts@fast24.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200407300815.18296.mrwatts@fast24.co.uk>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Watts wrote:
> With the performance issues I'm seeing with the 8506-4LP's I have, I wouldn't 
> recommend them to anyone currently...
> 
> The thread on LKML from a few days ago about mke2fs -j and 8506-4LP says it 
> all, but basically and reasonable amount of I/O brings a Dual Opteron system 
> to its knees.
> And by reasonable I mean copying ISO images from a usb2 drive to a raid 5 (4 x 
> 250GB maxtor) or even just formatting a 600MB partition.

I would be interested to see the output of 'vmstat 1' while your system is
so slow.

IMHO you shouldn't draw such conclusion ("reasonable amount of I/O brings a
Dual Opteron system to its knees") from your particular case. The 3 HT links
of the Opteron make this CPU particularly adapted to I/O operations.

Personnaly, on a dual Opteron, I am able to read datas from 4 SATA disks at
about 225 MB/s, with CPU time used at about 32%, awd with a system still
reasonably responsive.

-- 
Marc Bevand                          http://www.epita.fr/~bevand_m
Computer Science School EPITA - System, Network and Security Dept.

