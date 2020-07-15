From: Adam Barnett <adamtravisbarnett@gmail.com>
Subject: Re: Reshape using drives not partitions, RAID gone after reboot
Date: Tue, 14 Jul 2020 20:28:40 -0600
Message-ID: <8373f6a8-f0d9-02de-268d-64bddc4b9aa2@gmail.com>
References: <b551920e-ddad-c627-d75a-e99d32247b6d@gmail.com>
 <0b857b5f-20aa-871d-a22d-43d26ad64764@youngman.org.uk>
 <CAAMCDec22wshoG8eb9aM4su-EBdJRbh_LyVtaskR9FbYc4f=gw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAMCDec22wshoG8eb9aM4su-EBdJRbh_LyVtaskR9FbYc4f=gw@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>, antlists <antlists@youngman.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks for all the the replies. The drives had single gpt partitions 
that were created before adding the drives to the arrays. So I'll give 
removing the partition tables a try and forcing reassembly.

I also tried stopping the array before forcing reassembly but this issue 
is that the newly added drives appear to have no superblocks, so mdadm 
aborts the assembly.

My current plan is to try to --create --assume-clean the array, but I 
have been reading about using overlay files to preserve the drives. If 
anyone could help me understand exactly how that is done I would be very 
appreciative.

I don't think the list allows links(?) but I'm following the steps on 
the kernel wiki under "Recovering_a_failed_software_RAID" but the bash 
commands are a bit confusing due to the use of the parallel command.

Thanks again all!

-Adam

On 7/14/20 5:27 PM, Roger Heflin wrote:
> Did you create the partition before you added the disk to mdadm or
> after?  If after was it a dos or a gpt?  Dos should have only cleared
> the first 512byte block.  If gpt it will have written to the first
> block and to at least 1 more location on the disk, possibly causing
> data loss.
>
> If before then you at least need to get rid of the partition table
> completely.   Having a partition on a device will often cause a number
> of things to ignore the whole disk.  I have debugged "lost" pv's where
> the partition effectively "blocked" lvm from even looking at the
> entire device that the pv was one.
>
> If it is a dos partition table then:
> save a backup of each disk first (always a good idea, you can dd it
> back if you screwed up so long as you carefully create the backups and
> name them properly).
> dd if=/dev/sdx of=/root/sdxbackup.img bs=512 count=1
> then clear the partition table space, rebooting is probably the
> easiest way to clear out the mappings, it can be done without
> rebooting but I have to do it trial and error to figure out the exact
> order and commands.
> dd if=/dev/zero of=/dev/sdX bs=512 count=1
>
> On Tue, Jul 14, 2020 at 6:11 PM antlists <antlists@youngman.org.uk> wrote:
>> On 14/07/2020 20:50, Adam Barnett wrote:
>>> Forcing the assembly does not work:
>>>
>>> $ sudo mdadm /dev/md1 --assemble --force /dev/sd[ijmop]1 /dev/sd[kln]
>>> mdadm: /dev/sdi1 is busy - skipping
>>> mdadm: /dev/sdj1 is busy - skipping
>>> mdadm: /dev/sdm1 is busy - skipping
>>> mdadm: /dev/sdo1 is busy - skipping
>>> mdadm: /dev/sdp1 is busy - skipping
>>> mdadm: Cannot assemble mbr metadata on /dev/sdk
>>> mdadm: /dev/sdk has no superblock - assembly aborted
>> Did you do an "mdadm --stop /dev/md1" before trying that? That's a
>> classic error from an array that's previously been partially assembled
>> and failed ...
>>
>> The other thing I'd do is make sure there aren't any other unepected
>> partially assembled arrays. I doubt it applies here, but I have come
>> across mirrors that get broken in half and you get two failed arrays
>> instead of one working one ...
>>
>> Cheers,
>> Wol
