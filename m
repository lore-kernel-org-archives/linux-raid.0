From: Asdo <asdo@shiftmail.org>
Subject: Re: Some md/mdadm bugs
Date: Mon, 06 Feb 2012 18:07:38 +0100
Message-ID: <4F3008DA.8060402@shiftmail.org>
References: <4F2ADF45.4040103@shiftmail.org>
 <20120203081717.195bfec8@notabene.brown> <4F2B1519.5010500@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4F2B1519.5010500@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/02/12 23:58, Asdo wrote:
>
>>> Now it doesn't happen:
>>> When I reinserted the disk, udev triggered the --incremental, to
>>> reinsert the device, but mdadm refused to do anything because the old
>>> slot was still occupied with a failed+detached device. I manually
>>> removed the device from the raid then I ran --incremental, but mdadm
>>> still refused to re-add the device to the RAID because the array was
>>> running. I think that if it is a re-add, and especially if the 
>>> bitmap is
>>> active, I can't think of a situation in which the user would *not* want
>>> to do an incremental re-add even if the array is running.
>> Hmmm.. that doesn't seem right.  What version of mdadm are you running?
>
> 3.1.4
>
>> Maybe a newer one would get this right.
> I need to try...
> I think I need that.

Hi Neil,

Still some problems on mdadm 3.2.2 (from Ubuntu Precise) apparently:

Problem #1:

# mdadm -If /dev/sda4
mdadm: incremental removal requires a kernel device name, not a file: 
/dev/sda4

however this works:

# mdadm -If sda4
mdadm: set sda4 faulty in md3
mdadm: hot removed sda4 from md3

Is this by design? Would your udev rule
ACTION=="remove", RUN+="/sbin/mdadm -If $name"
trigger the first or the second kind of invocation?


Problem #2:

by reinserting sda, it became sdax, and the array is still running like 
this:

md3 : active raid1 sdb4[2]
       10485688 blocks super 1.0 [2/1] [_U]
       bitmap: 0/160 pages [0KB], 32KB chunk

please note the bitmap is active

so now I'm trying auto hot-add:

# mdadm  -I /dev/sdax4
mdadm: not adding /dev/sdax4 to active array (without --run) /dev/md3

still the old problem I mentioned with 3.1.4.
Trying more ways: (even with the "--run" which is suggested)

# mdadm --run -I /dev/sdax4
mdadm: -I would set mdadm mode to "incremental", but it is already set 
to "misc".

# mdadm -I --run /dev/sdax4
mdadm: failed to add /dev/sdax4 to /dev/md3: Invalid argument.

# mdadm -I --run sdax4
mdadm: stat failed for sdax4: No such file or directory.

# mdadm -I sdax4
mdadm: stat failed for sdax4: No such file or directory.


This feature not working is a problem because if one extracts one disk 
by mistake, and then reinserts it, even with bitmaps active, he needs to 
do a lot of manual work to re-add it to the arrays (potentially even 
error-prone, if he mistakes the partition numbers)...

Thank you
A.
