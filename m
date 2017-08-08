From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: RecovData Handshk error
Date: Tue, 8 Aug 2017 15:08:27 -0500
Message-ID: <0d9494df-383e-20d9-28c5-fdebc481642b@suddenlinkmail.com>
References: <CAB1R3shnsVV2bnkiF2q-X+9iHD0eUrS0Xq0hqWgWM+EQAUwFXA@mail.gmail.com>
 <CAB1R3shMZX7Dg0G3iVa-oMrM77DFSJzDTt64VqGr4OF1Ys8RwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB1R3shMZX7Dg0G3iVa-oMrM77DFSJzDTt64VqGr4OF1Ys8RwA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex <mysqlstudent@gmail.com>
Cc: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/05/2017 02:43 PM, Alex wrote:
> Hi all, I sent the message below last week and haven't received any
> response. Is there a place that might be more appropriate for help
> with my MegaRAID and possible disk failure?

Alex,

  Sorry, the reason you got no response is because the LSI (or whatever
vendor) MegaRAID software is a for a proprietary HARDWARE raid implementation.
This list is for opensource Linux SOFTWARE raid. The MegaRAID software used to
manage the proprietary hardware RAID card and drives (while opensourced a
while back) has nothing at all to do with Linux software RAID discussed here.

  Once you get your problem sorted out, (or if you can't), you might consider
just using your raid card as a simple disk controller and creating a Linux
software RAID array on that -- then your questions would be relevant here.

(and unless you are saturating your hardware raid setup relying on a
battery-powered write-back cache, then good old free software raid here will
likely match or exceed the I/O performance of your current hardware card :)

-- 
David C. Rankin, J.D.,P.E.
