From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: RAID1: Disks alternating on reads
Date: Tue, 23 Sep 2003 13:09:28 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030923110928.GK8670@marowsky-bree.de>
References: <014b01c38053$0358ad90$0180a8c0@what> <news2mail-bkmfvp$a7u$1@cartman.spoiled.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <news2mail-bkmfvp$a7u$1@cartman.spoiled.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-09-22T09:39:05,
   Juri Haberland <list-linux.raid@spoiled.org> said:

> As far as I could observe, the RAID1 code reads one file from one dis=
k
> and never changes disks during this read - so you get the performance
> of one disk.
> *But* the code distributes different writes to different disks.

Reads of course, not writes ;-)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering		ever tried. ever failed. no matter.
SuSE Labs				try again. fail again. fail better.
Research & Development, SUSE LINUX AG		-- Samuel Beckett

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
