From: "John Stoffel" <john@stoffel.org>
Subject: Re: Mixed controllers on JBOD Raid 6?
Date: Thu, 2 Jul 2015 15:41:42 -0400
Message-ID: <21909.37878.786629.199118@quad.stoffel.home>
References: <CAOS+5GFJQ10z-VV=06ncxh+wb=ycq9HrHJfJD++y8z8qGnoOrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOS+5GFJQ10z-VV=06ncxh+wb=ycq9HrHJfJD++y8z8qGnoOrw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Another Sillyname <anothersname@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Another> I'm looking at an Asus Maximus Vii Gene motherboard which has
Another> 8 SATA controller connectors.....6 Intel and 2 other (can't
Another> remember at the moment).

Another> Are there any projected issues or concerns about making a 8
Another> Drive RAID6 array where I'm using mixed controllers?

I tried using this for a while, but once I ran out of ports as I added
drives, I ended up getting:

02:00.0 Serial Attached SCSI controller: LSI Logic / Symbios Logic SAS2008 PCI-Express Fusion-MPT SAS-2 [Falcon] (rev 03)

And putting that into my system and hanging most, if not all of my
data drives off that sucker.  I did this so that my RAID1 boot volumes
wouldn't move around and get mixed up, and also so that I got more
channels and stayed away from semi-crappy (maybe all crappy) dual/quad
port SATA SIL chips.  I forget the exact brands.

But in any case, if you can, I'd recommended that dedicated card, or a
pair of them, so that you get nice fast speed, and the warm fuzzy
feeling that your boot drives won't wander around in boot order
detection much.

John
