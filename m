From: Richard Jacobsen <richard@unixboxen.net>
Subject: removing faulty drive on 3ware 9xxx card
Date: Thu, 9 Jun 2005 12:08:01 -0700
Message-ID: <20050609120801.Z13710@tictactoe.unixboxen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello everyone,

I have a drive which is constantly putting out:

3w-9xxx: scsi0: AEN: ERROR (0x04:0x0009): Drive timeout detected:port=4,

However the 3ware cli reports it as still a valid member of the array:

//beautemps> info c0

Unit  UnitType  Status         %Cmpl  Stripe  Size(GB)  Cache  AVerify  IgnECC
------------------------------------------------------------------------------
u0    RAID-5    OK             -      64K     2328.2    ON     OFF      OFF      

Port   Status           Unit   Size        Blocks        Serial
---------------------------------------------------------------
p0     OK               u0     232.88 GB   488397168     WD-WMAEP28256 
p1     OK               u0     232.88 GB   488397168     WD-WMAEP28252 
p2     OK               u0     232.88 GB   488397168     WD-WMAEP27015 
p3     OK               u0     232.88 GB   488397168     WD-WMAEP28280 
p4     OK               u0     232.88 GB   488397168     WD-WMAEP28256 
p5     OK               u0     232.88 GB   488397168     WD-WMAEP28257 
p6     OK               u0     232.88 GB   488397168     WD-WMAEP28253 
p7     OK               u0     232.88 GB   488397168     WD-WMAEP28252 
p8     OK               u0     232.88 GB   488397168     WD-WMAEP28566 
p9     OK               u0     232.88 GB   488397168     WD-WMAEP25657 
p10    OK               u0     232.88 GB   488397168     WD-WMAEP28584 
p11    OK               -      232.88 GB   488397168     WD-WMAEP28250 

Since I'm assuming that this constant drive timeout is what is making my array
show to a crawl, I'd like to remove p4 from the array, have the hotswap on 
p11 take over, then replace p4.

I'm thinking that:

maint remove c0 p4

Is the command I'm looking for.  Any caveats before I try? 

Thanks,
Richard

-- 
"a professional is simply one who gets paid for doing what an amateur does for
love."
																	-- Ursula K. Le Guin
