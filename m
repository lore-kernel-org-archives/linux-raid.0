From: George Rapp <george.rapp@gmail.com>
Subject: Re: Reshape stalled at first badblock location (was: RAID 5
 --assemble doesn't recognize all overlays as component devices)
Date: Tue, 21 Feb 2017 20:12:14 -0500
Message-ID: <CAF-KpgZ3tZQy93PwUFk0RZRfv1w0_WBRhU+FQ9C4=Hhh44H7KQ@mail.gmail.com>
References: <CAF-KpgY0ySvCN9ftbDmW_P6wDiyfN2yWE6=NECVru4=vCe+pbQ@mail.gmail.com>
 <20170221175801.wt64t2tzcvg3sfmc@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170221175801.wt64t2tzcvg3sfmc@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>, Matthew Krumwiede <matt.krumwiede@me.com>, NeilBrown <neilb@suse.com>, Jes.Sorensen@gmail.com
List-Id: linux-raid.ids

> On Mon, Feb 20, 2017 at 05:18:46PM -0500, George Rapp wrote:
>> On Sat, Feb 11, 2017 at 7:32 PM, George Rapp <george.rapp@gmail.com> wrote:
>> [...snip...]
>>
>> When I try to assemble the RAID 5 array, though, the process gets
>> stuck at the location of the first bad block. The assemble command is:
>>
>> [...snip...]
>>
>> The md4_raid5 process immediately spikes to 100% CPU utilization, and
>> the reshape stops at 1901225472 KiB (which is exactly half of the
>> first bad sector value, 3802454640):
>>
> [...snip...]
On Tue, Feb 21, 2017 at 4:51 AM, Tomasz Majchrzak
<tomasz.majchrzak@intel.com> wrote:
> As long as you're sure the data on the disk is valid, I believe clearing
> bad block list manually in metadata (no easy way to do it) would allow
> reshape to complete.
>
> Tomek
On Tue, Feb 21, 2017 at 12:58 PM, Shaohua Li <shli@kernel.org> wrote:
>
> Add Neil and Jes.
>
> Yes, there were similar reports before. When reshape finds nadblocks, the
> reshape will do an infinite loop without any progress. I think there are two
> things we need to do:
>
> - Make reshape more robust. Maybe reshape should bail out if badblocks found.
> - Add an option in mdadm to force reset badblocks

OK, I examined the structure of the superblock and the badblocks
array. My first attempt was to zero out the bblog_offset and
bblog_size in the md superblock using dd (but that causes the checksum
to be different than the sb_csum in the superblock, and the mdadm
--assemble fails. I didn't want to research how to recalculate the
checksum unless I really, really have to.  8^)

Running mdadm under gdb, I determined that my bblog_offset was 72
sectors from the start of the md superblock), and filled that space
with 0xff characters in my overlay file:

# dd if=/dev/mapper/sdg4 bs=512 count=1 skip=73 of=ffffffff
# dd if=ffffffff of=/dev/mapper/sdg4 bs=512 count=1 seek=72

That convinced mdadm that I have a badblocks list, but it's empty:

# mdadm --examine-badblocks /dev/mapper/sdg4
Bad-blocks on /dev/mapper/sdg4:
#

Once I did that, and restarted the array with my overlay files:

# mdadm --assemble --force /dev/md4
--backup-file=/home/gwr/2017/2017-01/md4_backup__2017-01-25
/dev/mapper/sde4 /dev/mapper/sdf4 /dev/mapper/sdh4 /dev/mapper/sdl4
/dev/mapper/sdg4 /dev/mapper/sdk4 /dev/mapper/sdi4 /dev/mapper/sdj4
/dev/mapper/sdb4
mdadm: accepting backup with timestamp 1485366772 for array with
timestamp 1487645030
mdadm: /dev/md4 has been started with 9 drives (out of 10).
#

The reshape operation got past the two positions where it had frozen
earlier, and didn't throw any obvious errors to /var/log/messages, so
Tomek's suggestion seems to clear the badblocks seems to have worked.
However, this was in the overlay files, not the actual devices.

Before I proceed for real, does clearing the badblocks log and
assembling the array seem like my best option?

-- 
George Rapp  (Pataskala, OH) Home: george.rapp -- at -- gmail.com
LinkedIn profile: https://www.linkedin.com/in/georgerapp
Phone: +1 740 936 RAPP (740 936 7277)
