From: =?ISO-8859-1?Q?Tor_Arne_Vestb=F8?= <torarnv@gmail.com>
Subject: Re: Linux RAID autodetect partitions go missing from /dev, but fdisk
 can see them
Date: Thu, 18 Dec 2008 23:03:38 +0100
Message-ID: <494AC8BA.7010704@gmail.com>
References: <49402CFE.3080708@gmail.com> <18759.8246.568849.244513@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18759.8246.568849.244513@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil!

Neil Brown wrote:
> On Wednesday December 10, torarnv@gmail.com wrote:
>> I have a very strange problem that I've been trying to debug for
>> days now. I had a RAID5 with four drives and one spare,
>> /dev/sd[bcde]1 + /dev/sdf1, and everything was working fine, until
>> one day one of the drives in the array (sdb) no longer had a
>> partition (sdb1). Letting the spare take over I ignored this for a
>> few days, but then it happened again, this time with sdc1.

>> I'm hoping someone on this list may have ran into this before, or
>> have any tips on how I can continue debugging this, because I have t=
o
>> admit I'm a little lost...
>=20
> Yes, it does sound rather weird.

=46irst of all, thank you so much for helping me out with this, as I'm
still very lost :)

In addition to the things listed in the first e-mail, I've also tried
installing the latest kernel from kernel.org, but that did not solve
anything. Also, in case it's relevant, I'm running openSUSE 10.3.

> Can you:
>=20
>   mdadm -Esv

http://pastebin.com/d7b14d14e

=46or some reason it seems to think that /dev/sdc and /dev/sdb are part=
 of
the array, while it really is /dev/sdc1 and /dev/sdb1. I'm guessing
since they are missing somehow from the device nodes in /dev mdadm
assumes the disk itself is the member?

> and
>   mdadm --stop /dev/md0
>   strace -o /tmp/str -s 200 mdadm --assemble --scan --verbose /dev/md=
0

http://pastebin.com/f2c1db2e4

The original array had sd[bcde]1 + sdf1 as spare. Then sdb1 went missin=
g
and the spare kicked in, and then sdc1 went missing, leaving me with a
degraded array.

> Also the contents of /etc/mdadm.conf might help.

http://pastebin.com/f573346ef

Is there anything else I can run, cat, and/or paste that would shed
light over what's going on?

> Thanks,

Thank _you_ :)

Tor Arne



>> raid support in. The symptoms are:
>>
>>   - The kernel seems to detect the partitions (lines 396 and 407 in =
the
>> dmesg [1])
>>
>>   - But once the boot process finishes and the RAID is started, ther=
e is
>> no longer any sdc1 or sdb1, so the RAID fails to start (lines 550-57=
6 in
>> dmesg [1])
>>
>>   - Running fdisk -l shows that the drives in question (sdb and sdc)=
 do
>> have similar partitions as the other working drives, namely one Linu=
x
>> RAID autodetect partition each (see command output [2])
>>
>>   - But, the partitions are missing from /proc/partitions (see [3])
>>
>>   - Manually adding device nodes using mknod works, but doing file -=
sL
>> on the device gives "writable, no read permission", even though
>> permissions are the same as the other sd* nodes in /dev
>>
>>   - Running 'partprobe -s' successfully finds the two missing partit=
ions
>> and adds device nodes, and the nodes can be 'file -sL'ed, but when
>> trying to assemble the array again with these new nodes in the syste=
m,
>> I'm told that sdc1 is not found, and after the --assemble is done, t=
he
>> device nodes are once again missing (!) see [4]
>>
>>   - I've tried using the 'dmraid' command to look for fakeraid
>> partitions or meta data on the drives, which I was told could mess u=
p
>> the auto-detection of Linux software ride partitions, but could not =
find
>> any issues.
>>
>>
>> As you can tell I've exhausted all my current options, so any help o=
n
>> what I could try next would be very much appreciated. I am especiall=
y
>> curious as to why I lose the partitions when mdadm tries to assemble=
 the
>> array?
>>
>> Thanks!
>>
>> Tor Arne Vestb=F8
>>
>> [1] http://pastebin.com/m15b9c275   dmesg
>> [2] http://pastebin.com/f50fb323a   fdisk -l
>> [3] http://pastebin.com/f4547c2ca   cat /proc/partitions
>> [4] http://pastebin.com/m4475c9ae   partprobe + mdadm --assemble
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
