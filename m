From: Adam Luter <luterac@bellsouth.net>
Subject: Re: Disks out of sync
Date: Mon, 30 Sep 2002 09:53:51 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020930145351.GD2860@smeagol>
References: <Pine.LNX.4.21.0209301407430.9633-100000@macaroni.penguin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.21.0209301407430.9633-100000@macaroni.penguin>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Apparantly it should happen automatically when you put the drive back
in.  (And raidstop/start the drive).  If not, while the array is
started, run 'raidhotadd' on the drive.  It will treat the out of sync
drive as a new spare.. then once it's done syncing the spare it will
treat the spare as if it was the drive missing (that is, it will
upgrade it's status as a spare to a full fledge drive).

p.s. I'm not an expert, but I did just have to do this on mine (except
the auto part didn't work, so I had to use the hotadd part).

-Gryn (Adam Luter)

On Mon, Sep 30, 2002 at 02:56:49PM +0100, Mike Parsons wrote:
> Hi all
> 
> I have a 3 disk soft raid5 array. One disk has failed. Due to a
> faulty removable drive tray the other disks are out of sync. The data on
> the remaining disks should be identical.
> 
> Can someone please refresh my memory, on how to re-sync the disks. 
> 
> Thank You.
> 
> Mike Parsons 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
