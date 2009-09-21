From: Tim Bostrom <tbostrom@gmail.com>
Subject: Re: RAID 5 array recovery - two drives errors in external enclosure
Date: Sun, 20 Sep 2009 21:40:30 -0700
Message-ID: <2267211f0909202140m54039f77rce262283eb4e371@mail.gmail.com>
References: <2267211f0909171342g6ebf68a2y393daa587e59c714@mail.gmail.com>
	<6b696870909180910q67d8166ay7796321b8cd35809@mail.gmail.com>
	<2267211f0909180912p745e4ea0idb5659cb54a6adce@mail.gmail.com>
	<6b696870909180923m35f29fa2l857b6f6402eb20be@mail.gmail.com>
	<2267211f0909181041o29d6f5eft1e260696c6ab9c57@mail.gmail.com>
	<6b696870909181317x777e3c5dsdcf0e7709f9c4979@mail.gmail.com>
	<2267211f0909181630r33fcdbe5hb0d158b9bf12924b@mail.gmail.com>
	<70ed7c3e0909181637g35b31926ref7e4a16beaab73c@mail.gmail.com>
	<1f0f1a960909181817s6ad0a3f3l386a478603e9fde8@mail.gmail.com>
	<AFD5FB84146A49B186DAB822C95DE16D@m5>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AFD5FB84146A49B186DAB822C95DE16D@m5>
Sender: linux-raid-owner@vger.kernel.org
To: Guy Watkins <guy@watkins-home.com>
Cc: Tom Carlson <twigathy@gmail.com>, "Majed B." <majedb@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Well, thank god I copied everything off the array this weekend, but str=
ange:

I had gotten the array up finally with the correct order and missing dr=
ive:

mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sdf1 /dev/sdc1 /dev/sdb1
/dev/sdd1 missing

------------
After copying everything off, I power-cycled my server and tried to
bring the array back up again using:

mdadm -A /dev/md0 /dev/sdf1 /dev/sdc1 /dev/sdb1 /dev/sdd1 missing

I received the error : mdadm: superblock on /dev/sdc1 doesn't match
others - assembly aborted.

This is strange since I had this seemingly working and was able to
copy all the data offline this weekend.
Drives haven't changed order - I haven't unplugged anything or changed
any cords.

Another issue of the command that worked before on the array:
mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sdf1 /dev/sdc1 /dev/sdb1
/dev/sdd1 missing

yields my old problem of not being able to mount.
EXT3-fs: md0: couldn't mount because of unsupported optional features
(3fd18e00).
mount: wrong fs type, bad option, bad superblock on /dev/md0,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

What gives?  The drive order couldn't have changed just through a
reboot.   All the same number of drives and drive letters are there.


-Tim



On Fri, Sep 18, 2009 at 6:35 PM, Guy Watkins <guy@watkins-home.com> wro=
te:
> If you are starting over, maybe you should use RAID6?
>
> } -----Original Message-----
> } From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> } owner@vger.kernel.org] On Behalf Of Tom Carlson
> } Sent: Friday, September 18, 2009 9:18 PM
> } To: Majed B.
> } Cc: Tim Bostrom; linux-raid
> } Subject: Re: RAID 5 array recovery - two drives errors in external
> } enclosure
> }
> } 2009/9/19 Majed B. <majedb@gmail.com>:
> } > If you're going to take all your data out, I would suggest you do=
 a
> } > clean start and zero out all the disks to force the remapping of =
bad
> } > sectors, then run smartctl -t offline on all disks and after it's=
 done
> } > (it will take A LONG time), create your filesystem on an array an=
d put
> } > back your data.
> }
> } I'd recommend running the badblocks program on each device to be pu=
t
> } in the array too, just to be certain that none of your disks are go=
ing
> } to go horribly flakey on assembly and build... I'm not sure if the
> } offline smart test does a full scan like badblocks would.
> }
> } T
> } --
> } To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> } the body of a message to majordomo@vger.kernel.org
> } More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>
>



--=20
-tim
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
