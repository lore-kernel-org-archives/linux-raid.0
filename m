From: Steve Cousins <steve.cousins@maine.edu>
Subject: Re: Care and feeding of RAID?
Date: Tue, 05 Sep 2006 14:35:06 -0400
Message-ID: <44FDC35A.9060000@maine.edu>
References: <44FD722C.7050608@waldoware.com> <Pine.LNX.4.56.0609051414310.17570@lion.drogon.net> <44FD91D1.7090501@maine.edu> <20060905175724.GK11132@datavibe.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060905175724.GK11132@datavibe.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Rev. Jeffrey Paul" <sneak@datavibe.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Rev. Jeffrey Paul wrote:
> On Tue, Sep 05, 2006 at 11:03:45AM -0400, Steve Cousins wrote:
> 
>>These are SATA drives and except for the one machine that has a 3Ware 
>>8506 card in it I haven't been able to get SMART programs to do anything 
>>with these drives.  How do others deal with this? 
>>
> 
> 
> I use the tw_cli program to check up on my 3ware stuff.

Hi Jeffrey,

Thanks.  I use tw_cli too and I have scripted a check to see if it 
degrades but this doesn't help with checking for disk problems before 
they happen which SMART should help with.  As it happens, smartctl works 
with 3Ware SATA drives.  It is my other SATA drives that I'm unable to 
monitor.

Steve



> It took me quite a bit of time to figure that one out.  I don't
> have any automated monitoring set up, but it'd be simple enough to
> script.  I check on the array every so often and run a verify every few
> months to see if it kicks a disk out (it hasn't yet).
> 
> 0 root@datavibe:~# tw_cli 
> //datavibe> info
> 
> Ctl   Model        Ports   Drives   Units   NotOpt   RRate   VRate   BBU
> ------------------------------------------------------------------------
> c0    8006-2LP     2       2        1       0        2       -       -        
> 
> //datavibe> info c0
> 
> Unit  UnitType  Status         %Cmpl  Stripe  Size(GB)  Cache  AVerify  IgnECC
> ------------------------------------------------------------------------------
> u0    RAID-1    OK             -      -       232.885   ON     -        -     
> 
> Port   Status           Unit   Size        Blocks        Serial
> ---------------------------------------------------------------
> p0     OK               u0     232.88 GB   488397168     WD-WMAL718611 
> p1     OK               u0     232.88 GB   488397168     WD-WMAL718619
> //datavibe>
> 
> -j
> 

-- 
______________________________________________________________________
  Steve Cousins, Ocean Modeling Group    Email: cousins@umit.maine.edu
  Marine Sciences, 452 Aubert Hall       http://rocky.umeoce.maine.edu
  Univ. of Maine, Orono, ME 04469        Phone: (207) 581-4302


