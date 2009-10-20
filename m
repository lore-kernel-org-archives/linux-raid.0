From: "NeilBrown" <neilb@suse.de>
Subject: Re: Raid 5 to raid 6 reshape failure after reboot
Date: Tue, 20 Oct 2009 16:54:43 +1100
Message-ID: <c57ee40d9e6139de2993fb18934837c2.squirrel@neil.brown.name>
References: <20091018181033.0255346c@borg.bxl.tuxicoman.be>
    <358606dfd356518f7fa42219f26082d2.squirrel@neil.brown.name>
    <20091019155322.65b4287f@zombie>
    <5744c797713398f21b00e5323ddeac1e.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5744c797713398f21b00e5323ddeac1e.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Guy Martin <gmsoft@tuxicoman.be>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, October 20, 2009 7:05 am, NeilBrown wrote:
> On Tue, October 20, 2009 12:53 am, Guy Martin wrote:
>>
>> Hi Neil,
>>
>> Same result with the latest commit after a reboot.
>>
>> Maybe the problem comes from the fact that I first try to assemble
>> the array without providing a backup file ?
>
> That should not cause a problem - mdadm will simply fail in that
> case and leave you to do it 'right'.
>
> I assume it is the same backup file from before - not a file in /tmp
> or something like that?
>
>>
>> For reference I did the following :
>> mdadm --create /dev/md0 -l 5 -n 3 /dev/sd[bdf]1
>> mdadm --add /dev/md0 /dev/sde1
>> [wait for the raid 5 to rebuild]
>> mdadm --grow /dev/md0 --backup-file backup -l 6 -n 4
>> [wait a few hours]
>> reboot
>> mdadm --assemble /dev/md0 /dev/sd[bdef]1
>> mdadm --assemble /dev/md0 /dev/sd[bdef]1 --backup-file backup
>>
>> Any other output you'd need ?
>
> In general adding '-v' to '--assemble' is a good idea, but I doubt
> it would give anything particularly useful in this case.
> I'll try to reproduce your result and let you know how I go.

I tried to reproduce this and failed - it works perfectly for me.

I have added some more tracing messages to --assemble which are enabled
by --verbose.
Could you please pull the latest devel-3.1 branch from my git tree and
try the same assemble command but with --verbose at the end and report the
result.

Thanks.
NeilBrown

