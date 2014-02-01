From: Yorik <yoriks13@westnet.com.au>
Subject: Re: RAIS5 Rebuild Help - Possible Data Offset
Date: Sat, 1 Feb 2014 15:56:14 +0800
Message-ID: <CAFth78xfsaBLzg9TC=UkEoQiafpg-oVJyoxbYgWyrVHCyAuHew@mail.gmail.com>
References: <CAFth78x1SkCEUmETFt+F+79UpjUbhanNLUbZoWa7Hxi3EzsdMw@mail.gmail.com>
	<20140131102551.GA2425@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140131102551.GA2425@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Yorik <yoriks13@westnet.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you for your help. Sorry for my omission, I thought I had put
that in. It was one of the first things that I tried and have numerous
times since.

#mdadm -Af /dev/md0 /dev/sd[abc]1 /dev/sd[defgi]
mdadm: /dev/md0 assembled from 5 drives - not enough to start the array.

Then if I try the command again, I get the following

# mdadm -Af /dev/md0 /dev/sd[abc]1 /dev/sd[defgi]
mdadm: /dev/sda1 is busy - skipping
mdadm: /dev/sdb1 is busy - skipping
mdadm: /dev/sdc1 is busy - skipping
mdadm: /dev/sdd is busy - skipping
mdadm: /dev/sde is busy - skipping
mdadm: /dev/sdf is busy - skipping
mdadm: /dev/sdg is busy - skipping
mdadm: /dev/sdi is busy - skipping

And my /proc/mdstat looks like this, with all drives marked as spare.

# cat /proc/mdstat
Personalities :
md0 : inactive sda1[0](S) sdf[7](S) sdg[8](S) sde[5](S) sdi[6](S)
sdd[4](S) sdc1[2](S) sdb1[1](S)
      23442114872 blocks super 1.1

unused devices: <none>

If I stop the Array and try again, the following messages are written
into /var/log/messages when the command is run.

 Feb  1 15:53:52 desktop kernel: [405874.418851] md: bind<sdg>
Feb  1 15:53:52 desktop kernel: [405874.419043] md: bind<sdf>
Feb  1 15:53:52 desktop kernel: [405874.419189] md: bind<sda1>
Feb  1 15:53:52 desktop udisksd[1715]: Error creating watch for file
/sys/devices/virtual/block/md0/md/sync_action: No such file or
directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error creating watch for file
/sys/devices/virtual/block/md0/md/degraded: No such file or directory
(g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/degraded': Failed to open file
'/sys/devices/virtual/block/md0/md/degraded': No such file or
directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/sync_action': Failed to open file
'/sys/devices/virtual/block/md0/md/sync_action': No such file or
directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/sync_completed': Failed to open
file '/sys/devices/virtual/block/md0/md/sync_completed': No such file
or directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/degraded': Failed to open file
'/sys/devices/virtual/block/md0/md/degraded': No such file or
directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/sync_action': Failed to open file
'/sys/devices/virtual/block/md0/md/sync_action': No such file or
directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/sync_completed': Failed to open
file '/sys/devices/virtual/block/md0/md/sync_completed': No such file
or directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/degraded': Failed to open file
'/sys/devices/virtual/block/md0/md/degraded': No such file or
directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/sync_action': Failed to open file
'/sys/devices/virtual/block/md0/md/sync_action': No such file or
directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/sync_completed': Failed to open
file '/sys/devices/virtual/block/md0/md/sync_completed': No such file
or directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/degraded': Failed to open file
'/sys/devices/virtual/block/md0/md/degraded': No such file or
directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/sync_action': Failed to open file
'/sys/devices/virtual/block/md0/md/sync_action': No such file or
directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/sync_completed': Failed to open
file '/sys/devices/virtual/block/md0/md/sync_completed': No such file
or directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/degraded': Failed to open file
'/sys/devices/virtual/block/md0/md/degraded': No such file or
directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/sync_action': Failed to open file
'/sys/devices/virtual/block/md0/md/sync_action': No such file or
directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/sync_completed': Failed to open
file '/sys/devices/virtual/block/md0/md/sync_completed': No such file
or directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/degraded': Failed to open file
'/sys/devices/virtual/block/md0/md/degraded': No such file or
directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/sync_action': Failed to open file
'/sys/devices/virtual/block/md0/md/sync_action': No such file or
directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/sync_completed': Failed to open
file '/sys/devices/virtual/block/md0/md/sync_completed': No such file
or directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/degraded': Failed to open file
'/sys/devices/virtual/block/md0/md/degraded': No such file or
directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/sync_action': Failed to open file
'/sys/devices/virtual/block/md0/md/sync_action': No such file or
directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/sync_completed': Failed to open
file '/sys/devices/virtual/block/md0/md/sync_completed': No such file
or directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/degraded': Failed to open file
'/sys/devices/virtual/block/md0/md/degraded': No such file or
directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/sync_action': Failed to open file
'/sys/devices/virtual/block/md0/md/sync_action': No such file or
directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/sync_completed': Failed to open
file '/sys/devices/virtual/block/md0/md/sync_completed': No such file
or directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/degraded': Failed to open file
'/sys/devices/virtual/block/md0/md/degraded': No such file or
directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/sync_action': Failed to open file
'/sys/devices/virtual/block/md0/md/sync_action': No such file or
directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/sync_completed': Failed to open
file '/sys/devices/virtual/block/md0/md/sync_completed': No such file
or directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/degraded': Failed to open file
'/sys/devices/virtual/block/md0/md/degraded': No such file or
directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/sync_action': Failed to open file
'/sys/devices/virtual/block/md0/md/sync_action': No such file or
directory (g-file-error-quark, 4)
Feb  1 15:53:52 desktop udisksd[1715]: Error reading sysfs attr
`/sys/devices/virtual/block/md0/md/sync_completed': Failed to open
file '/sys/devices/virtual/block/md0/md/sync_completed': No such file
or directory (g-file-error-quark, 4)

Any other ideas appreciated..

On 31 January 2014 18:25, Robin Hill <robin@robinhill.me.uk> wrote:
> On Thu Jan 30, 2014 at 10:20:45pm +0800, Yorik wrote:
>
>> Hello
>>
>> Sorry if double post had to remove some HTML.
>>
>> I've been using "mdadm" for about 8-9 years with a lot of success in
>> different Array configurations. I am a huge fan of Software RAID. I
>> recently suffered a failure that was very unfortunate and I now have
>> an issue with differing Data Offset and other issues preventing my
>> Array from rebuilding. A brief history follows:
>>
>> Array originally created as RAID5, 3x 3TB Drives in May 2011 on a
>> (then) latest Fedora build.
>> Added more drives in 2012 and 2013 with upgraded Fedora builds.
>> Recently added another drive and changed to RAID6, 6x6TB Drives.
>> Suffered a failure shortly after 2 more drives that kicked the last 2
>> drives off and one of the 6 other that were previously running.
>> During the RAID rebuild, my computer locked up and then suffered a
>> Power Failure (having a bad day) that stopped my OS Disk (SSD) from
>> allowing me to reboot. Eventually rebuilt the OS with Fedora 20,
>> wiping the majority of the SSD and config files with it.
>>
>> The RAID6 does not start, stating that it only has 5 of the 8 drives
>> required. Looking into this, the drives seem to be clean and check
>> okay, but there is even differences (expected) and Data Offset
>> difference between drives that I read (Neil Brown Blog date
>> -20120615073245) was not necessarily good for rebuilding and that I
>> should ask for a version of mdadm that can handle this as it's
>> possible that creating with an older version, then adding new drives
>> is causing an issue. Data Offsets of 2048 and 4096 exist.
>>
>> Also of note is that I have some drives that are on the Array without
>> partitions as they would not add to the Array with partitions on them
>> due to size when they were added. I think that I had version issue
>> with fdisk, but it seemed to work okay until now.
>>
>> When I run the following command:
>>
>> mdadm --create --assume-clean --level=6 --raid-devices=8
>> --size=2930263552 /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd
>> /dev/sdi /dev/sde /dev/sdg /dev/sdf
>>
>> I get:
>>
>> mdadm: /dev/sda1 is smaller than given size. 2930134016K < 2930263552K
>> + metadata
>> mdadm: /dev/sdb1 is smaller than given size. 2930134016K < 2930263552K
>> + metadata
>> mdadm: /dev/sdc1 is smaller than given size. 2930134016K < 2930263552K
>> + metadata
>> mdadm: /dev/sdd is smaller than given size. 2930135040K < 2930263552K + metadata
>> mdadm: /dev/sdi is smaller than given size. 2930135040K < 2930263552K + metadata
>> mdadm: /dev/sde is smaller than given size. 2930135040K < 2930263552K + metadata
>> mdadm: /dev/sdg is smaller than given size. 2930135040K < 2930263552K + metadata
>> mdadm: /dev/sdf is smaller than given size. 2930135040K < 2930263552K + metadata
>> mdadm: create aborted
>>
>> Which makes me think that there are further issues. Should I be
>> looking for an older version of mdadm or a different version? Can
>> anyone offer some advice please or where to look next.
>>
> You don't mention having tried a force assemble, which should have been
> done before resorting to re-creating the array. What's the output from
> running "mdadm -Af /dev/md0 /dev/sd[abc]1 /dev/sd[defgi]"?
>
> Cheers,
>     Robin
> --
>      ___
>     ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
>    / / )      | Little Jim says ....                            |
>   // !!       |      "He fallen in de water !!"                 |
