From: Wilson Jonathan <piercing_male@hotmail.com>
Subject: Re: Is it possible to create a raid from/over other raids?
Date: Thu, 19 Dec 2013 13:57:54 +0000
Message-ID: <BLU0-SMTP33624DD4A22378F9BCFD8D198C50@phx.gbl>
References: <BLU0-SMTP2702D8075688EF7D229D66498DA0@phx.gbl>
	 <52B2B9BF.6030707@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52B2B9BF.6030707@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2013-12-19 at 03:17 -0600, Stan Hoeppner wrote:
> On 12/18/2013 3:12 PM, Wilson Jonathan wrote:
> > I realise if it is possible its not going to be the best solution, but a
> > temp stop gap... 
> 
> The primary purpose of RAID is to protect your filesystem and files
> against failure of a disk in an array.  The purpose of RAID6 is to
> protect against a second disk failure or read error while you're
> rebuilding the first failed drive in an array.  By creating a RAID6 with
> one missing, you've essentially created a RAID5 array, as you can only
> lose one drive.
> 
> Why didn't you simply create a RAID5, then reshape it to RAID6 when you
> acquire your "4th" disk?  If you'd done that you wouldn't be worrying
> about "plugging this hole".

I think I over thought things/was trying to be to clever :-/

> The tone of your request suggests the time frame to add the 4th drive is
> now indeterminate, and you have a realization that it may possibly never
> happen.  This being the case, I'd suggest you backup all your files,
> blow away the 'kissing' RAID6, and make a fresh RAID5 of your 3 drives.
>  Or a RAID10.  Then format and restore.  Your performance will increase,
> and you won't have to worry about this missing drive in your crippled
> RAID6 array.

The intention was to copy the existing raid6-6drive data (the end of the
new 3tb drives now holds/replaces the original 1tb drives) then copy the
data across to the new raid6 (held in the first 2tb of space on the
3-3tb disks) then destroy the 6 disk raid and finally re-use the disks
until a new drive can be purchased (was looking at 1-2 months time)
however thinking about it again and in light of your comments I think
I'll leave everything well alone and leave the 6 disk original running
(with 3 new drives)... when I've installed the missing 4th disk at that
point I will copy over the data, then tear down the 6 disk array, that
way I will have my 2 drive redundancy should any disk suffer an early
death. It will also mean that the existing 3 new disks will have had a
1-2 month workout, again allowing for 2 drive deaths in the original
array.


