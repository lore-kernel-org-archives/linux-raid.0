From: Ninti Systems <office@ninti.com.au>
Subject: Re: fd filesystem and RAID1
Date: 05 Apr 2004 17:30:16 +0930
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1081152016.2301.40.camel@localhost>
References: <1080948756.999.10.camel@localhost>
	 <87oeq7me9d.fsf@enki.rimspace.net>
Reply-To: office@ninti.com.au
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87oeq7me9d.fsf@enki.rimspace.net>
To: Daniel Pittman <daniel@rimspace.net>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks for your patient replies Daniel. I'm not having a lot of luck
with RAID1 on Slackware, and will probably have to go back to RedHat9's
comfy GUI.

I have followed the instructions in your initial reply, but haven't been
able to set up even a non-root RAID device using mdadm that doesn't try
to resync on every reboot. This is with all fs types as 'fd'. The fault
lies with me of course, not your instructions. which I must be
misreading somehow.

I'm thinking of trying mkraid and using a startup script to get RAID
going. Or maybe just mirroring data to the second disk with rsync.


On Mon, 2004-04-05 at 10:28, Daniel Pittman wrote:
> On 03 Apr 2004, Ninti Systems wrote:
> > I've been able to do everything involved in setting up a simple RAID1
> > with 2 IDE disks on Slackware 9.1 except get it to actually keep
> > working on reboot.
> > 
> > I installed on one disk, built 'degraded' RAID1 devices on the second
> > disk, copied data, etc. I can hot add devices from the original disk
> > to the RAID arrays. RAID devices in /etc/fstab come up (in degraded
> > mode) on boot.
> > 
> > The problem is that hot-added devices never stick, the RAID arrays are
> > always degraded again on reboot. 
> > 
> > mdadm complains of missing superblocks. I have read the man page but
> > can't see how to manage superblocks (create/delete) if this is even
> > possible.
> > 
> > I'm wondering if have to make the original install partitions type
> > 'fd' as well as those on the second disk?
> 
> The kernel auto-discovery will only probe a partition that has type
> 'fd', so if you want both parts of the mirror to work, both need to be
> type 'fd'.
> 
>      Daniel
-- 
--------------------------------------
Ninti Systems: Smart IT Solutions
Michael Hall
Mobile: 0429 095 392
Ph/Fax: 08 8953 1442       
Email:  office at ninti dot com dot au
Web:    http://ninti.com.au
--------------------------------------

