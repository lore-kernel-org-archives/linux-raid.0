From: Mike Parsons <mike@atalan.co.uk>
Subject: Re: Disks out of sync
Date: Mon, 30 Sep 2002 18:31:42 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.21.0209301818520.9633-100000@macaroni.penguin>
References: <20020930145351.GD2860@smeagol>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20020930145351.GD2860@smeagol>
To: Adam Luter <luterac@bellsouth.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 30 Sep 2002, Adam Luter wrote:

> Apparantly it should happen automatically when you put the drive back
> in.  (And raidstop/start the drive).  If not, while the array is
> started, run 'raidhotadd' on the drive.  It will treat the out of sync
> drive as a new spare.. then once it's done syncing the spare it will
> treat the spare as if it was the drive missing (that is, it will
> upgrade it's status as a spare to a full fledge drive).
> 
> p.s. I'm not an expert, but I did just have to do this on mine (except
> the auto part didn't work, so I had to use the hotadd part).
> 
> -Gryn (Adam Luter)
> 

Thanks for the reply Adam, but the 2 good disks are not being recognised,
as the superblocks are out of sync. I have approx. 40 GB of data that I
would like to recover. 

I had this problem a while ago, and someone on the
list explained how to resync the suberblocks. Unfortunately the e-mail
with the information is on the raid array. Hopefully someone can refresh
my memory.

Cheers

Mike Parsons

