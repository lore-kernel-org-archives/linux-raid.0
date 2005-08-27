From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: number of global spares?
Date: Sat, 27 Aug 2005 15:00:28 +1000
Message-ID: <87u0hc55zn.fsf@rimspace.net>
References: <1125082848.25483.23.camel@seki.nac.uci.edu>
	<200508262321.j7QNLuE03756@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Guy" <bugzilla@watkins-home.com> writes:

[...]

>> I've been working on a RAID setup with dual RAID controllers and
>> three expansion boxes - 48 disks in all, including data, parity and
>> global spares.

[...]

>> They don't feel that the storage has to be blazing fast, and 100% uptime
>> isn't paramount, however they very much do not want to lose their data.
>> 
>> The filesystem will not be backed up - we simply don't have anything large
>> enough to back it up -to-, so if the some part of the storage solution
>> goes kerflooey, we're totally...  er...  out of luck, and they'll probably
>> be looking at me (the primary sysadmin on the storage configuration),
>> wondering why their data is gone.
>
> RAID5, 6 or 1 is not data backup!  It is hardware redundancy!!
> Data loss or corruption can still occur with a RAID solution.  RAID won't
> help if someone fat fingers a "rm" command.
> Corruption of the filesystem can also cause major data loss, without a
> failed disk.
>
> If the data was lost, what would it cost to re-create it?
> Enough to buy a backup system?

I absolutely agree with this.  When - and it is when, not if - the
content of this filesystem goes away, you will be rightly blamed for it.

Invest the few thousand dollars in a good high capacity tape drive and
pay someone to change the tapes.  This will be worth it when the system
finally does fail in some nasty, unpredictable way!

        Daniel


