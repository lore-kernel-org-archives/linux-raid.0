From: Stephen Haran <steveharan@gmail.com>
Subject: Re: RAID5 NAS Recovery...00.90.01 vs 00.90
Date: Thu, 6 Dec 2012 20:07:28 -0500
Message-ID: <CAKcp_7aW6_5AZ3AvW-cJPMgOODw28To23qfM-JN3z3UsUK7NCw@mail.gmail.com>
References: <CAKcp_7ZrR+L5jZBK3cd-z780Cw76XpwMuWmwtUGt=ecwbx_LPg@mail.gmail.com>
	<20121121083936.1a4d4b13@notabene.brown>
	<CAKcp_7YdAgfoVM_j+jQNE61cLoEVd+y75zfyPNy1wv9w7+jfdQ@mail.gmail.com>
	<20121122160248.42189273@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121122160248.42189273@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well after much trial and tribulation there is a happy ending to report.

Turns out the device size differences did not seem to matter.
The old raid size from the NAS raid.log file stated...
        Version : 00.90.01
  Creation Time : Wed Jun 24 19:00:59 2009
     Raid Level : raid5
     Array Size : 2925293760 (2789.78 GiB 2995.50 GB)
    Device Size : 975097920 (929.93 GiB 998.50 GB)

The new raid I created and recovered from is slightly larger...
        Version : 0.90.00
           UUID : 42a40d1c:d405694b:c97bd3bc:10cb3212 (local to host 7654ozz)
  Creation Time : Thu Dec  6 17:45:05 2012
     Raid Level : raid5
  Used Dev Size : 975298048 (930.12 GiB 998.71 GB)
     Array Size : 2925894144 (2790.35 GiB 2996.12 GB)

The complication was the client having created the array in the wrong
order wiping out the good meta data. And also the client not knowing
the correct order of the drives as they originally existed in the NAS.

So in a four drive raid5 there's 24 possible drive combinations and if
you allow for one missing drive add 96 more for a total of 120
different drive combination possibilities to try.

After about 20 tries I hit the right combination. But I still had to
recreate the VG and LVM and repair the ext3 FS with an alternate
superblock.

But in the end 1.5TB of data was recovered.  Thank you for your help Neil.

-Stephen Haran

On Thu, Nov 22, 2012 at 12:02 AM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 21 Nov 2012 12:29:53 -0500 Stephen Haran <steveharan@gmail.com> wrote:
>
>> Thank you Neil for your reply comments below...
>>
>> On Tue, Nov 20, 2012 at 4:39 PM, NeilBrown <neilb@suse.de> wrote:
>> > On Tue, 20 Nov 2012 15:41:57 -0500 Stephen Haran <steveharan@gmail.com> wrote:
>> >
>> >> Hi, I'm trying to recover a Western Digital Share Space NAS.
>> >> I'm able to assemble the RAID5 and restore the LVM but it can't see
>> >> any filesystem.
>> >>
>> >> Below is a raid.log file that shows how the raid was configured when
>> >> it was working.
>> >> And also the output of mdadm -D showing the raid in it's current state.
>> >> Note the Version difference 00.90.01 vs. 0.90. And the array size
>> >> difference 2925293760  vs. 2925894144
>> >> I'm thinking this difference may be the reason Linux can not see a filesystem.
>> >
>> > Probably not - losing a few blocks from the end might make 'fsck' complain,
>> > but it should still be able to see the filesystem.
>> >
>> > How did you test if you could see a filesystem?  'mount' or 'fsck -n' ?
>>
>> Yes I tried both mount and fsck. It can't find the superblock.
>> Testdisk finds ext3 partitions but can not see data.
>> But looking with hexedit the data appears to still be there.
>>
>> > It looks like you re-created the array recently (Nov 18 12:07:53 2012)  Why
>> > did you do that?
>>
>> The end user attempted a firmware upgrade on the NAS box and could not access
>> their data afterwards. Not sure if the firmware update or the end user
>> did the re-create.
>
> It looks like the devices have been repartioned.  The /dev/sdX4 partitions
> are 200Meg smaller than they were before.  Quite possible the start of the
> partitions has moved as well as the end.
> So the array created in these partitions will be quite different to what it
> was before.
>
> I don't suppose you have the old partition tables, like you have the old
> "mdadm --detail" output?
>
> If not, you need to find where the ext3 superblock is, deduce from that where
> the start of the device should be (I don't know if the superblock is at the
> start of the device, or in the second block) and then recreate the partition
> table.
> The X4 partitions need to be at least 128K larger than the "used device size".
>
> Good luck.
>
> NeilBrown
