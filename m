From: Janusz Zamecki <janusz@pipi.ma.cx>
Subject: RE: RAID1 & 2.6.9 performance problem
Date: Tue, 18 Jan 2005 20:12:06 +0100
Message-ID: <1106075525.14134.277.camel@pipi.ma.cx>
References: <OMEKLMBKKEOEENCKLEIDAEFGCAAA.ryan@dynaconnections.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <OMEKLMBKKEOEENCKLEIDAEFGCAAA.ryan@dynaconnections.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> Think about it and it should make sense.  You have two discs with identical
> layouts.  How could you possibly increase the speed of a single sequential
> read?  You can't just read half from one drive, half from the other, you'd
> always have heads seeking and it would no longer be a sequential read.
> 

I'm thinking about something like this (of course this is
simplification):

1. Application reads big chunk of data. 
2. File system layer splits this requests into fs block size requests
(let say 4k each).
3. Each block read request is divided into sector size requests. As far
as I understand modern drives can do read ahead up to 16 (32??) sectors.

Now, the first read request for sector X should go to the first disk,
while the next request for the sector (X+disk_read_ahead) should go to
the second disk, third request for the (X+2*disk_read_ahead) sector to
the first disk, and so on.

If we use whole disks for RAID1, the heads should always be in similar
position, so latency should be similar to 1 disk, because the drives
should seek in track to track manner (in ideal world).

I agree that it is not pure sequential operation, but I think it is
close enough to get some performance boost at virtually no cost.

Do you agree?

Janusz
