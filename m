From: James Doebbler <jamesdoebbler@gmail.com>
Subject: Re: Corruption during RAID5->RAID6 migration
Date: Tue, 14 May 2013 15:56:57 -0500
Message-ID: <CAJDy477412O8_saeP-YYxXSoQsgMy8jEgdfXa7p5_2V54nMG=Q@mail.gmail.com>
References: <CAJDy474SBN7qMgccmkzc++=ZP43L1M=jVkyx_YVkqdZmbvwZfg@mail.gmail.com>
 <20130515020814.77ff1407@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130515020814.77ff1407@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>, Roman Mamedov <rm@romanrm.ru>
List-Id: linux-raid.ids

Roman,

I suppose that means you think it's hardware-related then.  Do you
have any suggestions on what/how I might be able to recover?

Hardware details:

The motherboard is ECS A785GM-M with 6x internal SATAII and 2x eSATAII
I have installed 2 x SYBA SD-SA2PEX-2IR (SiI3132 Chipset), each with
2x onboard SATAII

One of the addon cards I have been using for over 6 months, but not as
part of the RAID5.  The other one (identical model) was installed
several weeks ago.

I am only 70% sure about which drives are on which of the two add-on
cards, so I will need to confirm that tonight before responding.

Onboard IDE
  2 x WD2500LB (separate RAID1 array)
Onboard SATA:
  1 x HD203WI (/dev/sdd)
  5 x HD204UI (/dev/sd[abcef])
Onboard eSATA:
  1 x ST3000DM001 (/dev/sdg) - backup drive, not part of RAID array
  1 x (unused)

Addon-cards
  1 x WD20EFRX (/dev/sdh)
  1 x HD204UI (/dev/sdi)
  1 x ST2000DL003 (/dev/sdj) - not currently used, potential hot spare
  1 x DVD-RW


Nothing that looks like obvious hardware errors in dmesg.  The
following are the only unexpected entries:

[126480.924143] INFO: task jbd2/dm-5-8:22963 blocked for more than 120 seconds.
[126480.924147] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[126480.924150] jbd2/dm-5-8     D ffffffff81806240     0 22963      2 0x00000000
[126480.924154]  ffff8801127fbce0 0000000000000046 ffff8801127fbc90
0000000300000001
[126480.924158]  ffff8801127fbfd8 ffff8801127fbfd8 ffff8801127fbfd8
00000000000137c0
[126480.924161]  ffff880118d31700 ffff880114be5c00 ffff8801127fbcf0
ffff8801127fbdf8
[126480.924163] Call Trace:
[126480.924172]  [<ffffffff8165cbbf>] schedule+0x3f/0x60
[126480.924177]  [<ffffffff81262d0a>]
jbd2_journal_commit_transaction+0x18a/0x1240
[126480.924181]  [<ffffffff8165ed5e>] ? _raw_spin_lock_irqsave+0x2e/0x40
[126480.924187]  [<ffffffff81078098>] ? lock_timer_base.isra.29+0x38/0x70
[126480.924190]  [<ffffffff8108bec0>] ? add_wait_queue+0x60/0x60
[126480.924193]  [<ffffffff81267a8b>] kjournald2+0xbb/0x220
[126480.924195]  [<ffffffff8108bec0>] ? add_wait_queue+0x60/0x60
[126480.924197]  [<ffffffff812679d0>] ? commit_timeout+0x10/0x10
[126480.924200]  [<ffffffff8108b41c>] kthread+0x8c/0xa0
[126480.924203]  [<ffffffff81669234>] kernel_thread_helper+0x4/0x10
[126480.924205]  [<ffffffff8108b390>] ? flush_kthread_worker+0xa0/0xa0
[126480.924207]  [<ffffffff81669230>] ? gs_change+0x13/0x13
[126480.924303] INFO: task smbd:23413 blocked for more than 120 seconds.
[126480.924304] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[126480.924305] smbd            D ffffffff81806240     0 23413  23026 0x00000000
[126480.924308]  ffff88010b84dc98 0000000000000082 0000000000000060
000000000000004b
[126480.924311]  ffff88010b84dfd8 ffff88010b84dfd8 ffff88010b84dfd8
00000000000137c0
[126480.924313]  ffff880118d31700 ffff880117464500 ffff88010b84dca8
ffff8801001c4000
[126480.924316] Call Trace:
[126480.924318]  [<ffffffff8165cbbf>] schedule+0x3f/0x60
[126480.924320]  [<ffffffff81260442>] start_this_handle.isra.9+0x2b2/0x3f0
[126480.924322]  [<ffffffff8108bec0>] ? add_wait_queue+0x60/0x60
[126480.924325]  [<ffffffff8126064a>] jbd2__journal_start+0xca/0x110
[126480.924327]  [<ffffffff812606a3>] jbd2_journal_start+0x13/0x20
[126480.924329]  [<ffffffff81237c4f>] ext4_journal_start_sb+0x7f/0x1d0
[126480.924331]  [<ffffffff8121d7f6>] ? ext4_dirty_inode+0x26/0x60
[126480.924335]  [<ffffffff8118c1b0>] ? fillonedir+0xd0/0xd0
[126480.924337]  [<ffffffff812122d0>] ? ext4_dx_readdir+0x140/0x240
[126480.924339]  [<ffffffff8121d7f6>] ext4_dirty_inode+0x26/0x60
[126480.924342]  [<ffffffff811a2570>] __mark_inode_dirty+0x40/0x2a0
[126480.924344]  [<ffffffff811933a1>] touch_atime+0x121/0x160
[126480.924347]  [<ffffffff8118c1b0>] ? fillonedir+0xd0/0xd0
[126480.924349]  [<ffffffff8118c0c6>] vfs_readdir+0xc6/0xe0
[126480.924351]  [<ffffffff8118c389>] sys_getdents+0x89/0x100
[126480.924353]  [<ffffffff816670c2>] system_call_fastpath+0x16/0x1b

Thanks,
James

On Tue, May 14, 2013 at 3:08 PM, Roman Mamedov <rm@romanrm.ru> wrote:
> On Tue, 14 May 2013 14:56:22 -0500
> James Doebbler <jamesdoebbler@gmail.com> wrote:
>
>> Hello,
>>
>> I have encountered a scary situation with corruption on my RAID array
>> and would like any help/advice/pointers that might help me
>> save/recover any data I can.  I'll try to describe the situation as
>> best I can, so forgive the length of this email.
>>
>> I have a personal file and media server running Ubuntu Linux Server
>> 12.04.2, kernel version 3.2.0-41-generic.  I have a mdadm RAID5 array
>> of 2TB disks that I've been adding disks to and growing as needed off
>> the past couple of years and everything has been great other than a
>> non-zero mismatch_cnt.  The array was currently at 10TB/6 device and I
>> decided it was time to move to a RAID6 array since the number of
>> devices was getting large.  I wanted to minimize the chance of a total
>> failure during a rebuild as well as hopefully be able to resolve any
>> future mismatch_cnts correctly with the extra parity information.
>>
>> I had read on Neil Brown's blog that the migration would be much
>> faster if I was also adding capacity, so I installed two new 2TB
>> drives, added them to the array (as spares) and started the
>> reshape/grow. I've appended the commands used and mdadm output to the
>> end of this email.
>>
>> The reshape seemed to be going along as expected except I was only
>> getting ~5MB/s instead of the ~40MB/s I usually see.  Several hours
>> later I noticed that some of my recent downloads were corrupt when
>> extracting from archives.  I created some files from data in
>> /dev/urandom and calculated the md5sum.  A minute or so later I
>> recalculated the sum, and it was different.  Similarly, copying the
>> file resulted in another md5sum that was not the same as the previous
>> two.
>>
>> At that point I am not sure where the problem is, but I know my RAID
>> array is no longer correctly returning the data I store to them.  I do
>> not have verification data for most of the data already on the drive,
>> so I do not know if there is a problem reading any data, or a problem
>> writing new data (in which case my pre-existing data might be okay).
>>
>> Running iostat, I noticed that one drive was the bottleneck
>> (/dev/sdh).  It was one of the new drives and even though I had tested
>> them thoroughly, I worried that it was this drive that was returning
>> bad data or something.  I failed the drive in question and the RAID
>> reshape sped up considerably (to ~35MB/s).  However, doing the same
>> md5sum of new random data files with the drive non-active in the array
>> still failed in the same way.
>>
>> I then became worried about a hardware problem with my RAM or SATA
>> card
>
> Which SATA card (vendor/model)?
>
> Also describe what exactly you have connected and to where, e.g. do you also
> use the onboard controller of your motherboard (vendor/model?) for how many
> drives, and to which port and on which of the controllers you have added any
> new drives recently.
>
> Mentioning HDD models also won't hurt. Really, it's almost like you wrote a
> long winded post but gave barely any significant details whatsoever.
>
> --
> With respect,
> Roman
