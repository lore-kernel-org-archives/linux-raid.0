From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: RAID-6 with 3 missing disks
Date: Sat, 4 May 2013 18:30:06 +0200
Message-ID: <20130504163006.GA3395@lazy.lzy>
References: <20130504160804.GA2242@lazy.lzy>
 <14872633-1367684555-cardhu_decombobulator_blackberry.rim.net-102434637-@b3.c7.bise7.blackberry>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <14872633-1367684555-cardhu_decombobulator_blackberry.rim.net-102434637-@b3.c7.bise7.blackberry>
Sender: linux-raid-owner@vger.kernel.org
To: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid-owner@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Rudy,

thanks for the answer, but as mentioned at the end,
"--force" assemby does not work.
Reason is, 7 disks complains 3 are missing and the
3 missing are assembed, since their superblock does
not report errors.
Of course, 3 disks are not enough to assembly the
array, forced or not.

bye,

pg

On Sat, May 04, 2013 at 04:22:39PM +0000, Rudy Zijlstra wrote:
> Hi
> 
> I would start with mdadm assemble --force
> 
> Do not use create unless all else has failed
> 
> Cheers
> 
> Rudy
> ---
> Verstuurd met mijn BlackBerry van Vodafone
> 
> -----Original Message-----
> From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
> Sender: linux-raid-owner@vger.kernel.org
> Date:	Sat, 4 May 2013 18:08:04 
> To: <linux-raid@vger.kernel.org>
> Subject: RAID-6 with 3 missing disks
> 
> Hi all,
> 
> I know this was probably already discussed, but
> maybe I need some refresh.
> 
> I've a 10 HDDs RAID-6 which, due to mishap (disks
> were disconnected accidentaly), has now 3 missing
> devices and cannot be assembled.
> The data should be OK, since no writes were occurring
> during the accident, so putting them together again
> should work.
> 
> As far as I know, one option is to create, with
> "mdadm -C" the array again, giving the disks in
> the proper order.
> 
> Since all HDDs are readable, I guess "mdadm -E"
> should return the role of each device.
> Is this correct for the creation order?
> 
> Second question is about the "Data Offset", since
> this array was created with an older version of
> "mdadm" and the data offset is very close to the
> superblock.
> As far as I know, new mdadm creates the data a
> bit far aways.
> Is there any way to specifiy the proper offset?
> 
> Finally, is there an alternative to "mdadm -C"
> or it is the only option?
> Forcing assembly does not work, but maybe there
> is another way to tell mdadm to really assemby
> the array, taking into account the superblock
> information, which are all readable.
> 
> Thanks a lot in advance,
> 
> bye,
> 
> -- 
> 
> piergiorgio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

piergiorgio
