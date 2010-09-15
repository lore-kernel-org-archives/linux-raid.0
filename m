From: "Pol Hallen" <polhallen@fuckaround.org>
Subject: Re: advice to low cost hardware raid (with mdadm)
Date: Thu, 16 Sep 2010 00:03:11 +0200 (CEST)
Message-ID: <b6947b76728ca8c5d78d4d05fbd7894c.squirrel@fuckaround.org>
References: <00c6ed0254381567aff38d7a95d200c5.squirrel@fuckaround.org>
    <4C912F5D.5040305@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C912F5D.5040305@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

First all: sorry for my english :-P

>With four SATA drives on a new mobo
> with an AHCI chip you'd see over 400 MB/s, about 4 times that of the PCI
> 6 drive solution.  You'd have one drive less worth of capacity.

400Mb/s is because the integrated controller of mobo reach that speed?
So is it a raid hardware (no need mdadm)? What happen if the controller
goes break?

>additionally, in the event
> of a disk failure, rebuilding a 6x1TB RAID5/6 array will take forever
> and a day.

a nightmare...

very thanks for your reasoning.. I don't have enought experience about
raid and friends!

Pol

