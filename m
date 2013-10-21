From: "John Stoffel" <john@stoffel.org>
Subject: Re: Linux MD? Or an H710p?
Date: Mon, 21 Oct 2013 10:18:33 -0400
Message-ID: <21093.14265.261728.755087@quad.stoffel.home>
References: <526328AE.2020908@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <526328AE.2020908@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Bergman <sbergman27@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Steve> I'm configuring a PowerEdge R520 that I'll be installing RHEL
Steve> 6.4 on next month. (Actually, Scientific Linux 6.4) I'll be
Steve> upgrading to RHEL (SL) 7 when it's available, which is looking
Steve> like it might default to XFS.

Steve> This will be a 6 drive RAID10 set up for ~100 Gnome (freenx)
Steve> desktop users and a virtual Windows 2008 Server guest running
Steve> MS-SQL, so there is plenty of opportunity for i/o
Steve> parallelism. This seems a good fit for XFS.

So are you keeping home directories on here as well?  And how busy
will the MS-SQL server be?  That's probably where most of your IO will
come from I suspect.  Also, make sure you get lots of memory.  The
more your freenx server can cache in memory, the better things will
be.  

I also note that under Centos 6.4 firefox 22 has a tendency to grow
without bound, sucking up all the memory and causing the system to bog
down.  I admit I'm reading email via OWA, using Service Now, and lots
of tabs, but basically memory usage sucks.  And I'm using freenx as
well to access my desktop.  

I do admit I'm using a 3rd party repo, so I'm running:

  firefox-22.0-1.el6.remi.x86_64

Steve> My preference would be to use Linux MD RAID10. But the Dell
Steve> configurator seems strongly inclined to force me towards
Steve> hardware RAID.

Skip the configurator and just buy a controller 3rd hand.  

Steve> My choices would be to get a PERC H310 controller that I don't need, 
Steve> plus a SAS controller that the drives would actually connect to, and use 
Steve> Linux md. Or I can go with a PERC H710p w/1GB NV cache running hardware 
Steve> RAID10. (Dell says their RAID cards have to function as RAID 
Steve> controllers, and cannot act as simple SAS controllers.)

Steve> I also have a choice between 600GB 15k drives and 600GB 10k "HYB CARR" 
Steve> drives, which I take to be 2.5" hybrid SSD/Rotational drives in a 3.5" 
Steve> mounting adapter.

Is your key metric latency, or throughput?

John
