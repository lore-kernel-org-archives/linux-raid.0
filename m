From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: background scanning for media defects (was Re: RAID-6 support in
 kernel?)
Date: Wed, 05 Jun 2002 23:25:59 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3CFE81E7.3010301@fl.priv.at>
References: <Pine.GSO.4.21.0206030213510.23709-100000@gecko.roadtoad.net> <1023125615.1051.1283.camel@peecee> <20020604222053.C31741@unthought.net> <20020605075701.GD2541@colombina.comedia.it> <20020605125341.E31741@unthought.net> <20020605194239.GB6516@colombina.comedia.it>
Reply-To: Linux RAID Mailing Liste <linux-raid@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linux RAID Mailing Liste <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Luca Berra wrote:
> well, yes and no
> a kernel thread could do compare and check parity and also
> when we have the support for this in md try to do a write and
> see if the disk error correction code can relocate the bad sector.
> also a 'dd if=/dev/hda of=/dev/null' would just sit a production
> machine, while we could give it a minumum and maximum bandwidth
> to use like we do in reconstruction.

The 3Ware IDE-Raid controllers have that kind of background scanning
functionality if their diskmanager daemon is running. I guess it
just sends the controller chip the start scanning command, which then
does its job.

Would be good if linux md had that too.

-- 
MfG / Regards
Friedrich Lobenstock


