From: Drew <drew.kay@gmail.com>
Subject: Re: Linux MD? Or an H710p?
Date: Wed, 23 Oct 2013 12:05:21 -0700
Message-ID: <CACJz6QvPyKKP4iqeemMD4oMSt6P4xAiV7U6AfrEsJhTJpZaVvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, Steve Bergman <sbergman27@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> As a more general point, I don't know that you can generalise that
> database workloads normally store data in a single big file or a small
> set of files.  I haven't worked with many databases, and none more than
> a few hundred MB, so I am theorising here on things I have read rather
> than personal practice.  But certainly with postgresql the data is split
> into multiple directories - each table has its own directory.  For very
> big tables, the data is split into multiple files - and at some point,
> they will hit the allocation group size and then be split over multiple
> AG's, leading to parallelism (with a bit of luck).  I am guessing other
> databases are somewhat similar.  Of course, like any database tuning,
> this will all be highly load-dependent.

MS SQL Server does tend to store each database in it's own file no
matter the size. Ran into this with a VMware ESXi cluster maintained
by a vCenter instance running SQL Server Express on Windows Server
2008r2.

Both SQL Server Express 2005 & 2008 store the entire DB in one large
file. Know this because I ran up against a file size limitation on
Express '05 when the DB tables storing performance data grew to the
allowed max of '05. Had to upgrade to '08 and clean out old
performance data to make vCenter happy again.


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie

"This started out as a hobby and spun horribly out of control."
-Unknown
