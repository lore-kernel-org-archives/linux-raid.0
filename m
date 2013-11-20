From: "David F." <df7729@gmail.com>
Subject: Re: MDADM 3.3 broken?
Date: Tue, 19 Nov 2013 22:41:48 -0800
Message-ID: <CAGRSmLvR0vrddZ=qOQsM0m+3diDNC3uu-TW2OjwF2mS8UsNF7A@mail.gmail.com>
References: <CAGRSmLviYJtCfNiARKW0FvrJ0BUDrvhPnQy2drzbkf95-Gfpag@mail.gmail.com>
	<528A7721.8080604@arcor.de>
	<CAGRSmLvRVQtrkYPLS8NfRS+DvyS0xZ72cwVdLygb0w5KbVrARA@mail.gmail.com>
	<20131119110110.396b2af3@notabene.brown>
	<528BBFEB.7050202@arcor.de>
	<20131120105115.27494ab6@notabene.brown>
	<CAGRSmLsAALx=kJFiB6_b_yeb66qMZCa+4brg8Aejeaf031_JPg@mail.gmail.com>
	<CAGRSmLs8AXqTG9Y0YU46vtpb2q08-2ApknBHVPF75FXPJu7C0Q@mail.gmail.com>
	<20131120114833.695fc9d4@notabene.brown>
	<CAGRSmLsTnc_Lood59wF88w6nECVojbeiGkdntLExLEf6ZoaF7g@mail.gmail.com>
	<CAGRSmLvv0-MRyKV89W4zDi57Fhx8dxEUsR+zskOQ0R-H6x4Zbw@mail.gmail.com>
	<20131120133016.7de2d400@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131120133016.7de2d400@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Martin Wilck <mwilck@arcor.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

on the raid0 isw - the patch seems to work.

On Tue, Nov 19, 2013 at 6:30 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 19 Nov 2013 17:34:29 -0800 "David F." <df7729@gmail.com> wrote:
>
>
>> Contents of /proc/partitions:
>> major minor  #blocks  name
>>
>>    8       32  143638992 sdc
>>    8       33     102400 sdc1
>>    8       34  143535568 sdc2
>>    8       48  143638992 sdd
>>    8       64  143638992 sde
>>    8       80  143638992 sdf
>>    8       81     102400 sdf1
>>    8       82  143535568 sdf2
>>    8       96  143638992 sdg
>>   11        0      48160 sr0
>>    8       16    7632892 sdb
>
> This seems to suggest that there are no md devices that are active.
>
>
>> Contents of /proc/mdstat (Linux software RAID status):
>> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
>> [raid4] [multipath]
>> md127 : inactive sdg[0](S)
>>       1061328 blocks super external:ddf
>>
>> unused devices: <none>
>
> And this confirms it - just md127 which is inactive and is a ddf 'container'.
>
>> Contents of /etc/mdadm/mdadm.conf (Linux software RAID config file):
>> # mdadm.conf
>> #
>> # Please refer to mdadm.conf(5) for information about this file.
>> #
>>
>> # by default (built-in), scan all partitions (/proc/partitions) and all
>> # containers for MD superblocks. alternatively, specify devices to scan, using
>> # wildcards if desired.
>> DEVICE partitions containers
>>
>> # automatically tag new arrays as belonging to the local system
>> HOMEHOST <system>
>>
>> ARRAY metadata=ddf UUID=7ab254d0:fae71048:404edde9:750a8a05
>> ARRAY container=7ab254d0:fae71048:404edde9:750a8a05 member=0
>> UUID=45b3ab73:5c998afc:01bbf815:12660984
>
> This shows that mdadm is expecting a container with
>       UUID=7ab254d0:fae71048:404edde9:750a8a05
> which is presumably found, and a member with
>       UUID=45b3ab73:5c998afc:01bbf815:12660984
> which it presumably has not found.
>
>> >
>> >> mdadm --examine --scan
>> > ARRAY metadata=ddf UUID=7ab254d0:fae71048:
>> > 404edde9:750a8a05
>> > ARRAY container=7ab254d0:fae71048:404edde9:750a8a05 member=0
>> > UUID=5337ab03:86ca2abc:d42bfbc8:23626c78
>
> This shows that mdadm found a container with the correct UUID, but the member
> array inside the container has the wrong uuid.
>
> Martin: I think one of your recent changes would have changed the member UUID
> for some specific arrays because the one that was being created before wasn't
> reliably stable.  Could  that apply to David's situation?
>
> David: if you remove the "UUID=" part for the array leaving the
> "container=.... member=0" as the identification, does it work?
>
>
>> >
>> >> mdadm --assemble --scan --no-degraded -v
>> > mdadm: looking for devices for further assembly
>> > mdadm: /dev/md/ddf0 is a container, but we are looking for components
>> > mdadm: no RAID superblock on /dev/sdf
>> > mdadm: no RAID superblock on /dev/md/MegaSR2
>> > mdadm: no RAID superblock on /dev/md/MegaSR1
>> > mdadm: no RAID superblock on /dev/md/MegaSR
>
> This seems to suggest that there were 3 md arrays active, where as the
> previous data didn't show that.  So it seems the two sets of information are
> inconsistent and any conclusions I draw are uncertain.
>
> NeilBrown
>
