From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: AWFUL reshape speed with raid5.
Date: Fri, 1 Aug 2008 08:14:30 -0500
Message-ID: <cccedfc60808010614k2c740af7h9f24148dd3eec540@mail.gmail.com>
References: <cccedfc60807281039y67c27685n161708146d7c2b3d@mail.gmail.com>
	 <18578.26174.118449.299867@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18578.26174.118449.299867@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Jul 31, 2008 at 8:26 PM, Neil Brown <neilb@suse.de> wrote:
> On Monday July 28, jnelson-linux-raid@jamponi.net wrote:
>> I built a raid5 with 2 devices (and --assume-clean) using 2x 4GB
>> partitions (not logical volumes).
>> I then grew it to 3 devices.
>> The reshape speed is really really slow.
> ...
>>
>> Kernel is 2.6.25.11 (openSUSE 11.0 x86-64 stock)
>>
>> /proc/mdstat for this entry:
>>
>> md99 : active raid5 sdd3[2] sdc3[1] sdb3[0]
>>       3903744 blocks super 1.0 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>>       [=>...................]  reshape =  8.2% (324224/3903744)
>> finish=43.3min speed=1373K/sec
>>
>
>
> 1.3MB/sec is certainly slow.  On my test system (which is just a bunch
> of fairly ordinary SATA drives in a cheap controller) I get about 10
> times this - 13MB/sec.

I was able to sorta replicate it.

The exact sequence of commands;

mdadm --create /dev/md99 --level=raid5 --raid-devices=2
--spare-devices=0 --assume-clean --metadata=1.0 /dev/sdb3 /dev/sdc3
echo 2000 >  /sys/block/md99/md/sync_speed_min
mdadm --add /dev/md99 /dev/sdd3
mdadm --grow --raid-devices=3 /dev/md99

cat /proc/mdstat

md99 : active raid5 sdd3[2] sdc3[1] sdb3[0]
      3903744 blocks super 1.0 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
      [=>...................]  reshape =  5.1% (202240/3903744)
finish=28.5min speed=2161K/sec


dstat shows this (note that the total is doubled for some reason...):

--dsk/sdb-----dsk/sdc-----dsk/sdd-----dsk/sde----dsk/total-
 read  writ: read  writ: read  writ: read  writ: read  writ
 549k   78k: 542k   68k: 534k   72k: 174B   11k:3333k 1097k
7936k 3970k:7936k 3970k:   0  3970k:   0     0 :  31M   23M
4096k 2050k:4096k 2050k:   0  2050k:   0     0 :  16M   12M
2816k 1282k:2816k 1282k:   0  1410k:   0     0 :  11M 7948k
1280k  836k:1280k  768k:   0   640k:   0     0 :5120k 4488k
7936k 3970k:7936k 3970k:   0  3970k:   0     0 :  31M   23M
5120k 2562k:5120k 2562k:   0  2562k:   0     0 :  20M   15M
3456k 1728k:3456k 1728k:   0  1728k:   0     0 :  14M   10M
1664k  834k:1664k  834k:   0   834k:   0     0 :6656k 5004k
3072k 1560k:3072k 1536k:   0  1536k:   0     0 :  12M 9264k
9216k 4612k:9216k 4612k:   0  4612k:   0     0 :  36M   27M


Which clearly shows not a great deal of I/O: 5-18MB/s *total*.


..

> You can possibly increase the speed somewhat by increasing the buffer
> space that is used, thus allowing larger reads followed by larger
> writes.  This is done by increasing
>       /sys/block/mdXX/md/stripe_cache_size

turnip:~ # cat /sys/block/md99/md/stripe_cache_size
256
turnip:~ # cat /sys/block/md99/md/stripe_cache_active
0

Increasing that to 4096 moves the rebuild speed to between 3 and 4MB/s.
Any ideas?

This appears to happen with all metadata versions.

100% reproduceable.

-- 
Jon
