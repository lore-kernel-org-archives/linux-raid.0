From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Growing a single disk into a 2 disk raid0
Date: Fri, 28 Jan 2011 18:14:44 +0000
Message-ID: <4D430794.60101@anonymous.org.uk>
References: <4D42FA3E.6000206@cfl.rr.com> <4D4302B6.2090208@panix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D4302B6.2090208@panix.com>
Sender: linux-raid-owner@vger.kernel.org
To: Berkey B Walker <berk@panix.com>
Cc: Phillip Susi <psusi@cfl.rr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 28/01/2011 17:53, Berkey B Walker wrote:
>
>
> Phillip Susi wrote:
>> I had someone wanting to take an existing disk full of data and expand
>> it by adding a second disk. This seemed reasonable, and I thought of
>> several ways you could do this, but none of them pan out:
>>
>> 1) Create a single disk raid0 using the existing disk, then reshape it
>> adding the second disk. mdadm fails to add the second disk as a spare
>> so that you can reshape, with the kernel complaining that personality
>> does not support diskops.
>>
>> 2) Create a single disk raid1 using the existing disk, then reshape it
>> adding the second disk. Apparently you can not reshape from raid1 to
>> raid0.
>>
>> 3) Create a raid10 using the existing disk, setting the number of near
>> copies to only 1 so as to preserve the existing data, then reshape
>> adding the second disk. I ran into two problems here:
>>
>> a) mdadm refuses to create a single disk raid10, saying that at least
>> two devices are needed for raid level 4 or 5. I am surprised that you
>> can not create a single disk raid10 even with --force, and the message
>> mentions the wrong level. I would think that a single disk raid10 with
>> 2 far copies would be fairly useful.
>>
>> b) I tried 2 disks with one missing and mdadm refuses to create a raid10
>> with only a single near copy. The kernel complains that layout 0x101 is
>> unsupported.
>>
>> Is there any way to accomplish this?
>>
> Because 1) I'm old, and 2) I don't trust documentation, I do it the
> slow, easy way. I use the blank disk and make a RAID missing a disk. I
> then copy the data to the RAIDed disk. If everything is OK, zero out the
> old data disk and add it to the raid (filling the "missing"). I do it
> this way any time I want to make raid of a disk full of data, to any
> level of raid.

At the moment, mdadm doesn't support reshaping RAID-0 and RAID-10, 
though if you've been following the many posts/patches from the Intel 
guys, you'll know it's coming in mdadm 3.2.

Anything involving mirroring (RAID-1 or RAID-10) isn't going to expand 
the available storage space; you've only got two discs, so the second 
will be consumed by a mirror of the first.

So, Philip, if all you have is one full disc and one empty one, I think 
pretty much your only option at the moment is --level linear, either by 
--creating a new array with on-disc metadata with the new disc only, 
copying the data, then adding the original disc to the new array (as 
Berkey suggests), or by --building an array (with no stored metadata, 
meaning it'll need to be built again every time you reboot) which adds 
the second disc onto the first one. (Actually there is a cunning third 
option: shrink the filesystem a little and create the array with 
metadata at the end, but I'd be very VERY wary of doing this on data of 
any value.) I think I'd use LVM instead (multiple PVs in a VG usable by 
one LV) though it has the same problems with what to do with metadata.

If you want some redundancy as well as more storage space, you need more 
discs.

Cheers,

John.

