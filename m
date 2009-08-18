From: Drew <drew.kay@gmail.com>
Subject: Re: Hot-swapping: what's that? (and 3ware 9650SE)
Date: Tue, 18 Aug 2009 15:49:42 -0700
Message-ID: <c268e4660908181549k4ce5082bm33862349f220e848@mail.gmail.com>
References: <4A8AFC5F.3070108@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A8AFC5F.3070108@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: kwick <kwick@shiftmail.org>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> One question remains: ok but what is hot-swap anyway?

A "Hot Swappable Component" refers to any system component which can
be replaced without shutting down the machine. My servers at work have
hot swappable PCI slots, for example. Most often though you have to
tell the OS the device is about to vanish otherwise things break.

It can refer to non-raid controllers that allow you to remove drives
without hanging the bus they attach to. If it's in use you still have
tell the OS it's about to vanish, unmount file systems, etc. I have an
SAS/SATA controller at home that does this.

In the context of RAID, "hot swap" typically refers to any system
which allows drives to be changed out on a live system without having
to interact with the operating system beforehand. IBM's ServeRAID
controllers are a good example. Replacing a failed drive is as simple
as walking over to the server, pulling out the drive identified as
defective, and inserting a replacement. The raid controller recognizes
the replacement and begins to integrate it back into the array within
30secs.

Hope that helps.

-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
