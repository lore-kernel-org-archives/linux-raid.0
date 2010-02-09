From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Disk I/O error while rebuilding an md raid-5 array
Date: Tue, 9 Feb 2010 09:05:31 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1002090902320.31777@uplift.swm.pp.se>
References: <adf93d751002081523y1b9de656kdbba276b3dbc6af4@mail.gmail.com>  <adf93d751002082020t642cb1d3ne3d3f5fe5d57e7b5@mail.gmail.com>  <4B710745.7020200@stud.tu-ilmenau.de> <adf93d751002082339m4493166fo3f9d0ffe6a2c1eb4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <adf93d751002082339m4493166fo3f9d0ffe6a2c1eb4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dawning Sky <the.dawning.sky@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 8 Feb 2010, Dawning Sky wrote:

> Thanks for the good advice.  ddrescue on sdb returned an error of 4kB.
> I do still have my old sde.  But one thing I did, which was stupid,
> was trying to rebuild the raid-5 when it was mounted.  So I don't know
> the old sde is still consistent with the rest 3 disks, since some
> files would have been modified between the times when I took the old
> sde offline and when the rebuild failed.

Please see the threads I have initiated the past 2-3 weeks, I had the 
exact same problem.

What you should do is just put in your new cloned drive, make sure it runs 
fine with 3 drives, and then start the rebuild with the drive that you 
were resyncing to. I've done this numerous times, and my experience says 
you will only have lost those 4 kilobytes of data that ddrescue couldn't 
read.

I'm now happily at RAID6 after doing a re-shape from 6 drive raid5-> 8 
drive raid6, change of SATA cables and a new marvell 8channel 
controller... No more read timeouts anyway, and I should be better 
protected from single read errors like you are having.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
