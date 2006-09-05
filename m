From: "Rev. Jeffrey Paul" <sneak@datavibe.net>
Subject: Re: Care and feeding of RAID?
Date: Tue, 5 Sep 2006 13:57:24 -0400
Message-ID: <20060905175724.GK11132@datavibe.net>
References: <44FD722C.7050608@waldoware.com> <Pine.LNX.4.56.0609051414310.17570@lion.drogon.net> <44FD91D1.7090501@maine.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <44FD91D1.7090501@maine.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Cousins <steve.cousins@maine.edu>
Cc: Gordon Henderson <gordon@drogon.net>, Paul Waldo <pwaldo@waldoware.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Sep 05, 2006 at 11:03:45AM -0400, Steve Cousins wrote:
> 
> These are SATA drives and except for the one machine that has a 3Ware 
> 8506 card in it I haven't been able to get SMART programs to do anything 
> with these drives.  How do others deal with this? 
> 

I use the tw_cli program to check up on my 3ware stuff.

It took me quite a bit of time to figure that one out.  I don't
have any automated monitoring set up, but it'd be simple enough to
script.  I check on the array every so often and run a verify every few
months to see if it kicks a disk out (it hasn't yet).

0 root@datavibe:~# tw_cli 
//datavibe> info

Ctl   Model        Ports   Drives   Units   NotOpt   RRate   VRate   BBU
------------------------------------------------------------------------
c0    8006-2LP     2       2        1       0        2       -       -        

//datavibe> info c0

Unit  UnitType  Status         %Cmpl  Stripe  Size(GB)  Cache  AVerify  IgnECC
------------------------------------------------------------------------------
u0    RAID-1    OK             -      -       232.885   ON     -        -     

Port   Status           Unit   Size        Blocks        Serial
---------------------------------------------------------------
p0     OK               u0     232.88 GB   488397168     WD-WMAL718611 
p1     OK               u0     232.88 GB   488397168     WD-WMAL718619
//datavibe>

-j

-- 
--------------------------------------------------------
 Rev. Jeffrey Paul    -datavibe-     sneak@datavibe.net
  aim:x736e65616b   pgp:0xD9B3C17D   phone:877-748-3467
   9440 0C7F C598 01CA 2F17  D098 0A3A 4B8F D9B3 C17D
--------------------------------------------------------
