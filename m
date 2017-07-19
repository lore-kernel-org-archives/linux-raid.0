From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: 3-disk fail on raid-6, examining my options...
Date: Wed, 19 Jul 2017 13:09:14 -0400
Message-ID: <20170719170914.GA4353@animx.eu.org>
References: <07b77b80-4bee-3820-6a0d-3323ef06a3f3@ultratux.net>
 <596E6D72.8050108@youngman.org.uk>
 <20170718202550.GA2533@animx.eu.org>
 <596F47CF.6020007@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="HlL+5n6rz5pIUxbD"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <596F47CF.6020007@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Maarten <maarten@ultratux.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Wols Lists wrote:
> On 18/07/17 21:25, Wakko Warner wrote:
> > Wols Lists wrote:
> >> On 18/07/17 18:20, Maarten wrote:
> >>> Now from what I've gathered over the years and from earlier incidents, I
> >>> have now 1 (one) chance left to rescue data off this array; by hopefully
> >>> cloning the bad 3rd-failed drive with the aid of dd_rescue and
> >>> re-assembling --force the fully-degraded array. (Only IF that drive is
> >>> still responsive and can be cloned)
> >>
> >> If it clones successfully, great. If it clones, but with badblocks, I
> >> keep on asking - is there any way we can work together to turn
> >> dd-rescue's log into a utility that will flag failed blocks as "unreadable"?
> > 
> > I wrote a shell script that will output a device mapper table to do this. 
> > It will do either zero or error targets for failed blocks.  It's not
> > automatic and does require a block device (loop for files).  I've used this
> > several times at work and works for me.
> > 
> > I'm not sure if this is what you're talking about or not, but if you want
> > the script, I'll post it.
> > 
> I'm not sure I understand what you're saying, but I'm certainly
> interested. It'll probably end up on the wiki if that's okay with you?

That's fine.

> I'll aim to understand and document it so others will be able hopefully
> to use it as a "fire and forget" tool (inasmuch as you can
> fire-and-forget any recovery task :-)
> 
> What I'm thinking of is a utility that uses "hdparm --make-bad-sector".
> The idea being that if you have multiple disk failures, you can at least
> clone everything worth having off the broken disks, and then you can run
> a "tar . > /dev/null" or do a sync or whatever, and know that if it
> reads successfully off the array it isn't corrupt. Unless you're unlucky
> enough to have multiple drives fail in the same stripe, you should then
> recover your array no problem.

That's pretty much how I use it in a way.

Here's a real ddrescue log from one that I did:
# Rescue Logfile. Created by GNU ddrescue version 1.16
# Command line: ddrescue -s 85900394496 /dev/sdg /path/to/image.img /path/to/image.log
# current_pos  current_status
0xA078F9C00     +
#      pos        size  status
0x00000000  0xA078F9000  +
0xA078F9000  0x00001000  -
0xA078FA000  0x9F8806000  +
0x1400100000  0x2638A2E000  ?

I use losetup to make /path/to/image.img a block device.

I run the script I wrote:
sh ddlog-to-dm.sh /dev/loop0 < /path/to/image.log

Which outputs the following:
0 84133832 linear /dev/loop0 0
84133832 8 error
84133840 83640368 linear /dev/loop0 84133840

Then I run:
dmsetup create sometarget

I paste in the output and I now have /dev/mapper/sometarget that has errors
at the location that was bad.  Since it uses device mapper, the error part
doesn't retry.  This will work with hard disks instead of images.

To work with a real disk, skip the losetup part and use /dev/sdX instead of
/dev/loop0.  In my case above, assume I closed sdg to sdh, I would do:
sh ddlog-to-dm.sh /dev/sdh < /path/to/image.log
dmsetup create sdh

Then use /dev/mapper/sdh.

If you're familiar with device mapper, there are no partitions, you have to
create another target.  I use kpartx -a for this and when I'm done, I use
kpartx -d to tear it down.

When you're done, dmsetup remove sometarget and remove the loop device.

I have attached the script.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.

--HlL+5n6rz5pIUxbD
Content-Type: application/x-sh
Content-Disposition: attachment; filename="ddlog-to-dm.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/sh=0A=0A# Convert a ddrescue log file into text suitable for dmsetup=
 create to=0A# help with recovery.=0A#=0A# Licensed under GPL2.=0A#=0A# Wri=
tten by William Thompson 2017=0A=0ADEV=3D$1=0ABBT=3D$2=0A=0Aif [ -z "$DEV" =
];then=0A	echo "Usage: $0 <device> [bbt]"=0A	echo " or  : $0 <device> [bbt]=
 < ddrescue.log"=0A	echo=0A	echo "device	Backing device for linear target. =
 Does not have to exist."=0A	echo "		A real device must be available before=
 dmsetup will work."=0A	echo "bbt	Bad block target.  Must be either error o=
r zero."=0A	echo "		Default is error."=0A	exit 1=0Afi=0A=0Acase "$BBT" in=
=0A	"")=0A		BBT=3Derror=0A		;;=0A	error | zero)=0A		;;=0A	*)	echo "Bad Bloc=
k target must be error or zero"=0A		exit 1=0A		;;=0Aesac=0A=0Aif [ -t 0 ];t=
hen=0A	echo "Paste a ddrescue log file here and it will be converted to"=0A=
	echo "a device mapper target."=0A	echo "Press ^C to cancel or ^D to finish=
=2E"=0Afi=0A=0Aunset table=0Auntried=3D0=0Anextstart=3D0=0Awhile read start=
 length status junk;do=0A	case "$start" in=0A		0x*)	start=3D$(($start)) ;;=
=0A		\#*)	continue ;;=0A		*)	echo "Start must be a hex number beginning wit=
h 0x"=0A			exit 1=0A			;;=0A	esac=0A	case "$length" in=0A		# Status line=0A=
		"?" | "*" | / | - | F | G | +)=0A			continue=0A			;;=0A		0x*)	length=3D$(=
($length)) ;;=0A		*)	echo "Length must be a hex number beginning with 0x"=
=0A			exit 1=0A			;;=0A	esac=0A	if [ "$(($start & 511))" -gt 0 ];then=0A		e=
cho "Start is not a multiple of 512, aborting"=0A		exit 1=0A	fi=0A	if [ "$(=
($length & 511))" -gt 0 ];then=0A		echo "Length is not a multiple of 512, a=
borting"=0A		exit 1=0A	fi=0A	if [ "$start" !=3D "$nextstart" ];then=0A		ech=
o "Exected start of $nextstart, got $start, aborting"=0A		exit 1=0A	fi=0A	n=
extstart=3D$(($start + $length))=0A	start=3D$(($start >> 9))=0A	length=3D$(=
($length >> 9))=0A	if [ "$untried" =3D 1 ];then=0A		echo "An untried region=
 exists and is not the last, aborting"=0A		exit 1=0A	fi=0A	target=3Dbad=0A	=
case "$status" in=0A		"*" | "/" )=0A			echo "A non-trimmed/non-scraped/non-=
split block detected, converting to $BBT"=0A			target=3D$BBT=0A			;;=0A		"-=
")	target=3D$BBT=0A			;;=0A		"+")	table=3D"$table$start $length linear $DEV=
 $start=0A"=0A			continue=0A			;;=0A		"?")	untried=3D1=0A			target=3Dzero=
=0A			continue=0A			;;=0A	esac=0A	table=3D"$table$start $length $target=0A"=
=0Adone=0A=0Aecho "$table"=0A
--HlL+5n6rz5pIUxbD--
