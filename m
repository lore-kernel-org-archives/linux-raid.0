From: Max Waterman <davidmaxwaterman@fastmail.co.uk>
Subject: what went wrong?
Date: Sun, 30 Jan 2005 23:48:16 +0800
Message-ID: <41FD01C0.3000206@fastmail.co.uk>
Reply-To: mwaterman@jingmei.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've set up raid on my fc3 box using mdadm.

I have 3 arrays - a RAID0 and two RAID5s, which are md0, md1, and md2=20
respectively.

Initially, I had a problem where only md0 was being assembled at boot=20
time. It seemed to revolve around missing /dev/md[12] devices files. I=20
fixed that by adding a call to '/sbin/MAKEDEV md' just before the call=20
to mdadm in /etc/rc.sysinit, but it creates many /dev/md* files when I=20
only really need three.

However, I since discovered the 'auto' parameter - from the mdadm man p=
age :

auto=3D  This  option  declares to mdadm that it should try to create
        the device file of the array if it doesn=92t already exist, or
        exists but with the wrong device number.

        The  value  of  this option can be "yes" or "md" to indicate
        that a traditional, non-partitionable  md  array  should  be
        created,  or "mdp", "part" or "partition" to indicate that a
        partitionable md array (only  available  in  Linux  2.6  and
        later)  should be used.  This later set can also have a num-
        ber appended to  indicate  how  many  partitions  to  create
        device files for, e.g.  auto=3Dmdp5.  The default is 4.

so I tried to use that.

=2E.but that didn't seem to work very well. I don't know exactly what w=
ent=20
wrong with using this, but it seemed to me like there was a problem wit=
h=20
the device numbers (I think the drives were being associated with the=20
wrong array or something)....so, I figured I'd try the super-minor=20
option too, but that didn't work very well. I seemed to lose a drive in=
=20
each array (which I later mdadm --add'ed back in - takes ages to fix=20
itself though :( ).

So, I put removed the 'auto' and 'super-minor' options and put the 'fix=
'=20
back into rc.sysinit. Works fine again, but I can't think it is not a=20
real fix.

I am just wondering what I did wrong and what is the correct method for=
=20
creating the devices above md0.

Can someone enlighten me?

Thanks.

Max.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
