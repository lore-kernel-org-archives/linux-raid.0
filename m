From: Harry Mangalam <hjm@tacgi.com>
Subject: Re: removing faulty drive on 3ware 9xxx card
Date: Thu, 9 Jun 2005 13:08:36 -0700
Message-ID: <200506091308.37033.hjm@tacgi.com>
References: <20050609120801.Z13710@tictactoe.unixboxen.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050609120801.Z13710@tictactoe.unixboxen.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Richard Jacobsen <richard@unixboxen.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



That looks right, tho you haven't mentioned what version of the SW you're 
using. ANd you DO have the docs, right? ;)

If not, go here to get them:
http://www.3ware.com/support/downloadpageeng.asp?SNO=7

Or you could test the robustness of the system and just yank it.  I'd be 
interested in the results.. :)

After the bad disk is pulled, the rebuild should start immediately on your hot 
spare AFAIK, and when you replace the bad disk, you should then be able to 
specify it as the hot spare.

The web version of their SW (3dm2) works for me and is considerably more 
intuitive than the tw_cli (tho that's no saying a lot).

You might also try to get the SMART info from the disk (the 3ware SW can 
extract the raw numbers but will not interpret it).  

also:

Konstantin Olchanski <olchansk@sam.triumf.ca> recently wrote that:
I use the 3ware driver that comes with the Red Hat kernels, the
additional monitoring tools from 3ware do not work. SMART monitoring
works via "smartctl -a -d 3ware,0 /dev/twe0".
and added offline:
 BTW, I had to mknod /dev/twe0 manually, this
is how it looks like:

[root@tw00 ~]# ls -l /dev/twe0
crw-------  1 root root 254, 0 Jun  8 15:03 /dev/twe0



here's the section of man page for my version of tw_cli (2.00.00.042)

[maint] rebuild cid uid pid [ignoreECC]
    This command allows you to rebuild a DEGRADED unit by using the specified 
port. Rebuild only applies to redundant arrays such as RAID-1, RAID-5, 
RAID-10 and RAID-50. During rebuild, bad sectors on the source disk will 
cause the rebuild to fail. You can allow for the operation to continue via 
ignoreECC. Rebuild process is a background task and will change the state of 
a unit to REBUILDING. Various info commands also show a percent completion as 
rebuilding progresses. 

    Note that the port (disk) to be used to rebuild a unit, must be a SPARE or 
configured disk.

Let us know what happens...
hjm


On Thursday 09 June 2005 12:08 pm, Richard Jacobsen wrote:
> Hello everyone,
>
> I have a drive which is constantly putting out:
>
> 3w-9xxx: scsi0: AEN: ERROR (0x04:0x0009): Drive timeout detected:port=4,
>
> However the 3ware cli reports it as still a valid member of the array:
>
> //beautemps> info c0
>
> Unit  UnitType  Status         %Cmpl  Stripe  Size(GB)  Cache  AVerify 
> IgnECC
> ---------------------------------------------------------------------------
>--- u0    RAID-5    OK             -      64K     2328.2    ON     OFF     
> OFF
>
> Port   Status           Unit   Size        Blocks        Serial
> ---------------------------------------------------------------
> p0     OK               u0     232.88 GB   488397168     WD-WMAEP28256
> p1     OK               u0     232.88 GB   488397168     WD-WMAEP28252
> p2     OK               u0     232.88 GB   488397168     WD-WMAEP27015
> p3     OK               u0     232.88 GB   488397168     WD-WMAEP28280
> p4     OK               u0     232.88 GB   488397168     WD-WMAEP28256
> p5     OK               u0     232.88 GB   488397168     WD-WMAEP28257
> p6     OK               u0     232.88 GB   488397168     WD-WMAEP28253
> p7     OK               u0     232.88 GB   488397168     WD-WMAEP28252
> p8     OK               u0     232.88 GB   488397168     WD-WMAEP28566
> p9     OK               u0     232.88 GB   488397168     WD-WMAEP25657
> p10    OK               u0     232.88 GB   488397168     WD-WMAEP28584
> p11    OK               -      232.88 GB   488397168     WD-WMAEP28250
>
> Since I'm assuming that this constant drive timeout is what is making my
> array show to a crawl, I'd like to remove p4 from the array, have the
> hotswap on p11 take over, then replace p4.
>
> I'm thinking that:
>
> maint remove c0 p4
>
> Is the command I'm looking for.  Any caveats before I try?
>
> Thanks,
> Richard

-- 
Cheers, Harry
Harry J Mangalam - 949 856 2847 (vox; email for fax) - hjm@tacgi.com 
            <<plain text preferred>>
