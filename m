From: Bryan Bush <bbushvt@gmail.com>
Subject: Re: RAID6 grow failed
Date: Wed, 28 Mar 2012 03:54:45 -0400
Message-ID: <CAJ72viMxgfjhQiqJYVnjBQGfCq7jtegfvUY0nRdj46XDedeSjg@mail.gmail.com>
References: <CAJ72viP2MLb2tL84P-aK6Rs9eAH4x9Wwd=kVNbmPA=2LAfNLjg@mail.gmail.com>
	<20120328151828.6988d3db@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120328151828.6988d3db@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 28, 2012 at 12:18 AM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 27 Mar 2012 22:44:18 -0400 Bryan Bush <bbushvt@gmail.com> wro=
te:
>
>> I hope this is the right place to ask this question. =A0I have at 8
>> drive RAID 6 array that I wanted to grow to 13 drives (adding 5 more=
).
>> =A0I issued the mdadm command and checked /proc/mdstat and all looke=
d
>> well. =A0However at some point in time a disk failed and that hung m=
y
>> system. =A0Upon reboot the array is inactive and I can't get it to
>> reassemble.

> Hmmm... what do you have in /etc/mdadm.conf??

root@diamond:~# cat /etc/mdadm/mdadm.conf
# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default, scan all partitions (/proc/partitions) for MD superblocks=
=2E
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE partitions

# auto-create devices with Debian standard permissions
CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR root

# definitions of existing MD arrays

# This file was auto-generated on Fri, 14 Jan 2011 22:22:14 -0500
# by mkconf $Id$

ARRAY /dev/md1 level=3Draid6 num-devices=3D8 metadata=3D01.02 name=3D1
UUID=3Dfa32e2c5:e7bda20b:32af7c90:c7ee61eb
ARRAY /dev/md0 level=3Draid5 num-devices=3D4 metadata=3D00.90
UUID=3D989c3b8b:bd60d243:683690d9:73a11dfa

root@diamond:~#

>
> Though if the names have changed at all it would be safer to do
>
> =A0mdadm -Asf /dev/md1 -u fa32e2c5:e7bda20b:32af7c90:c7ee61eb
>

root@diamond:~# mdadm -Asf /dev/md1 -u fa32e2c5:e7bda20b:32af7c90:c7ee6=
1eb
mdadm: metadata format 01.02 unknown, ignored.
mdadm: metadata format 00.90 unknown, ignored.
mdadm: no devices found for /dev/md1
root@diamond:~#

Didn't seem to help.
Any other ideas?
Thanks
-Bryan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
