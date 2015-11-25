From: Phil Turmel <philip@turmel.org>
Subject: Re: Recovering RAID5 with 2, actually 1, faulty disks.
Date: Wed, 25 Nov 2015 08:22:55 -0500
Message-ID: <5655B62F.2070806@turmel.org>
References: <189791448292518@web28m.yandex.ru> <565359F6.3020201@turmel.org>
 <3822301448453563@web17m.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3822301448453563@web17m.yandex.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Semyon Enskiy <semyon.enskiy@yandex.ru>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/25/2015 07:12 AM, Semyon Enskiy wrote:
> Hi Phil.
> 
> Thanks for your suggestions, I have followed them, but RAID5 at md3 not
> recovered at yet, maybe you will find time to suggest anything else.
> 
> Exactly, power and data connections of SATA disks was not reliable, fixed
> this and after boot get no errors in kernel logs.
> md3 was replaced with "<ingore>" in mdadm.conf and commented in fstab before
> poweroff, things returned back after boot.
> 
>     # mdadm --assemble --update=revert-reshape /dev/md3

This ^^^ is a mistake.  It did nothing because you didn't list all of
the component partitions.  Stop md3 and try this part again.  If it
still doesn't work, add --force.

>     # mdadm --assemble --scan -vv

> Note the difference in --display and --examine outputs (see below) about
> total and delta device numbers, 10 in detail and 11 in examine.

--display is pretty much useless on an inactive array.  The --examine
reports are the ones that matter.

> Also note, that sda3 is marked as "spare" device, I am wrote before in first
> message, that some useless commands was executed.

This is from the --add operation you should not have done.

>     # mdadm --add /dev/md3 --re-add /dev/sda3

Augh!  Don't guess at what to do!  And even if the right thing, the
syntax is wrong (never put --add and --re-add together).

> mdadm: Cannot get array info for /dev/md3
> # This is because array is not started?

Yes.

[trim /]

>     # mdadm --examine /dev/sd?3

[trim /]

Very good, you have device roles 0-7 & 9, plus one spare, matching the
array state.  Put these devices in the --assemble --update command.

>     # for x in /dev/sd[a-z] ; do echo $x ; smartctl -i -A $x ; done

[trim /]

Your drives are entirely healthy.  No apparent lasting effects from the
problem cables/power.

For reference, your drive name to serial numbers to roles:

/dev/sda3 ==> WD-WCC4E1657399 ==> spare
/dev/sdb3 ==> WD-WCC4E1643332 ==> role 6
/dev/sdc3 ==> WD-WCC4E1649141 ==> role 7
/dev/sdd3 ==> WD-WCC4E0340253 ==> role 4
/dev/sde3 ==> WD-WCC4E1658818 ==> role 5
/dev/sdf3 ==> WD-WCC4E1349511 ==> role 0
/dev/sdg3 ==> WD-WCC4E1265787 ==> role 3
/dev/sdh3 ==> WD-WCC4E1639809 ==> role 2
/dev/sdi3 ==> WD-WCC4E1639009 ==> role 1
/dev/sdj3 ==> WD-WCC4E1228884 ==> role 9

Your next operations are:

mdadm --stop /dev/md3

mdadm -v --assemble --update=revert-reshape /dev/md3 /dev/sd[a-i]3

If successful, it should begin rebuilding onto /dev/sda3 (role 8).

If the above fails, repeat with --force.  If that fails show the output
and do nothing else.

Phil
