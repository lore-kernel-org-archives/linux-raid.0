From: "Francois Barre" <francois.barre@gmail.com>
Subject: Re: RAID over Firewire
Date: Thu, 24 Aug 2006 12:27:06 +0200
Message-ID: <fd8d0180608240327tbad7bf3v6c8a8c7514f7d29c@mail.gmail.com>
References: <44EB94BE.8080907@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44EB94BE.8080907@sauce.co.nz>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2006/8/23, Richard Scobie <richard@sauce.co.nz>:
> Has anyone had any experience or comment regarding linux RAID over ieee1394?
>
I've been successfully running a 4x250Gb Raid5 over ieee1394 with XFS on top.
The 4 drives are sharing the same ieee1394 bus, so the bandwidth is
awfull, because they have to share 20Mb/s.
It happens from time to time that one drive is temporary lost, so I
must re-add it and resync... (I would have liked to put a bitmap on
it, but I get an oops... I did not have time to give it a closer look
yet).

> As a budget backup solution, I am considering using a pair of 500GB
> drives, each connected to a firewire 400 port, configured as a linear
> array, to which the contents of an onboard array will be rsynced weekly.

I would really suggest you to study a 3-drive raid5 scenario, because
the risk of temporary loosing a disk is not neglectible... Regarding
to the cost of an extra disk.

That was my 2cents..
