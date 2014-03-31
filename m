From: Yorik <yoriks13@westnet.com.au>
Subject: Re: RAIS5 Rebuild Help - Possible Data Offset
Date: Mon, 31 Mar 2014 14:54:31 +0800
Message-ID: <CAFth78wtf5X0ycUuKCTV3QSvs4Uv8mvvZYH2Vqhwc2WwOqkHfg@mail.gmail.com>
References: <CAFth78x1SkCEUmETFt+F+79UpjUbhanNLUbZoWa7Hxi3EzsdMw@mail.gmail.com>
	<20140131102551.GA2425@cthulhu.home.robinhill.me.uk>
	<CAFth78xfsaBLzg9TC=UkEoQiafpg-oVJyoxbYgWyrVHCyAuHew@mail.gmail.com>
	<20140331172953.3f37f6c2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140331172953.3f37f6c2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil

Thanks very much for the help and advice.. Output as follows.

[root@desktop mdadm]# ./mdadm --assemble --force --verbose /dev/md0
/dev/sd[abc]1 /dev/sd[defgi]
mdadm: looking for devices for /dev/md0
mdadm: superblock on /dev/sdf doesn't match others - assembly aborted


Maybe there has been some differences in Data Offset and superblock
sizes with different versions of mdadm. I am not really sure what to
do now, I just got back from a long project overseas and was about to
start looking deeper into my options.

Appreciate any further help or advice that you have.

Regards
Derek

On 31 March 2014 14:29, NeilBrown <neilb@suse.de> wrote:
> On Sat, 1 Feb 2014 15:56:14 +0800 Yorik <yoriks13@westnet.com.au> wrote:
>
>> Thank you for your help. Sorry for my omission, I thought I had put
>> that in. It was one of the first things that I tried and have numerous
>> times since.
>>
>> #mdadm -Af /dev/md0 /dev/sd[abc]1 /dev/sd[defgi]
>> mdadm: /dev/md0 assembled from 5 drives - not enough to start the array.
>>
>> Then if I try the command again, I get the following
>>
>> # mdadm -Af /dev/md0 /dev/sd[abc]1 /dev/sd[defgi]
>> mdadm: /dev/sda1 is busy - skipping
>> mdadm: /dev/sdb1 is busy - skipping
>> mdadm: /dev/sdc1 is busy - skipping
>> mdadm: /dev/sdd is busy - skipping
>> mdadm: /dev/sde is busy - skipping
>> mdadm: /dev/sdf is busy - skipping
>> mdadm: /dev/sdg is busy - skipping
>> mdadm: /dev/sdi is busy - skipping
>>
>> And my /proc/mdstat looks like this, with all drives marked as spare.
>>
>> # cat /proc/mdstat
>> Personalities :
>> md0 : inactive sda1[0](S) sdf[7](S) sdg[8](S) sde[5](S) sdi[6](S)
>> sdd[4](S) sdc1[2](S) sdb1[1](S)
>>       23442114872 blocks super 1.1
>>
>> unused devices: <none>
>
> If this is still a problem then please:
> 1/ get the latest mdadm:
>      cd /tmp
>      git clone git://neil.brown.name/mdadm
>      cd mdadm
>      make
> 2/ stop the array
>      ./mdadm --stop /dev/md0
> 3/ force-assemble the array with --verbose:
>
>      ./mdadm --assemble --force --verbose /dev/md0 /dev/sd[abc]1 /dev/sd[defgi]
>
> and report all the output of the last command.
>
> NeilBrown
>
