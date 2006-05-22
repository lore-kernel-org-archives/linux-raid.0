From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: 4 disks in raid 5: 33MB/s read performance?
Date: Mon, 22 May 2006 12:33:24 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0605221231560.20391-100000@coffee.psychology.mcmaster.ca>
References: <200605221746.38122.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200605221746.38122.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> I just dd'ed a 700MB iso to /dev/null, dd returned 33MB/s.
> Isn't that a little slow?

what bs parameter did you give to dd?  it should be at least 3*chunk
(probably 3*64k if you used defaults.)

