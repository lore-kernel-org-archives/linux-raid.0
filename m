From: danci@agenda.si
Subject: Re: Fast RAID rebuild?
Date: Fri, 25 Jul 2003 08:09:50 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0307250809000.21461@duplo.agenda.si>
References: <Pine.LNX.4.53.0307221333120.21063@duplo.agenda.si>
 <3F2051C4.8020001@etr-usa.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3F2051C4.8020001@etr-usa.com>
To: Warren Young <warren@etr-usa.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 24 Jul 2003, Warren Young wrote:

> danci@agenda.si wrote:
> >
> > Is there a way to quickly add the disk back to array without resyncing
> > - something like 'mdadm --unfail'? :)
>
> md is right not to trust the state of the replaced disk.  Just in order
> to get to the mdadm point, you have to boot up, which means files have
> changed on the live disks relative to the one that was temporarily
> missing.  You'd risk massive corruption by forcing it to accept the new
> disk without rebuilding the array.

I thought it shouldn't work and I said so to the guy asking me... But I
just asked to see if *maybe* it is possible somehow.

Thanks for the answer,

   D.

