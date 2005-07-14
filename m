From: James Pearson <james-p@moving-picture.com>
Subject: Re: Oops when starting md multipath on a 2.4 kernel
Date: Thu, 14 Jul 2005 22:02:08 +0100
Message-ID: <42D6D2D0.6050905@moving-picture.com>
References: <42D546AB.6060101@moving-picture.com>	 <42D5FCA4.10104@us.ibm.com>  <42D639DC.80608@moving-picture.com> <1121358044.7843.11.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1121358044.7843.11.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Luciano Chavez <lnx1138@us.ibm.com>
Cc: marcelo.tosatti@cyclades.com, Mike Tran <mhtran@us.ibm.com>, lmb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Luciano Chavez wrote:
> On Thu, 2005-07-14 at 11:09 +0100, James Pearson wrote:
>=20
>>Mike Tran wrote:
>>
>>>James Pearson wrote:
>>>
>>>
>>>>We have an existing system runing a 2.4.27 based kernel that uses m=
d=20
>>>>multipath and external fibre channel arrays.
>>>>
>>>>We need to add more internal disks to the system, which means the=20
>>>>external drives change device names.
>>>>
>>>>When I tried to start the md multipath device using mdadm, the kern=
el=20
>>>>Oops'd. Removing the new internal disks and going back the original=
=20
>>>>setup, I can start the multipath device - as this machine is in=20
>>>>production, I can't do any more tests.
>>>>
>>>>However, I can reproduce the problem on test system by creating an =
md=20
>>>>multipath device on an external SCSI disk, using /dev/sda1, stoppin=
g=20
>>>>the multipath device, rmmod'ing the SCSI driver, pluging in a coupl=
e=20
>>>>of USB storage devices which become /dev/sda and /dev/sdb and then=20
>>>>modprobing the SCSI driver, so the original /dev/sda1 is now /dev/s=
dc1.
>>>>
>>>>When I run 'mdadm -A -s', I get the following Oops:
>>>>
>>>> [events: 00000004]
>>>>md: bind<sdc1,1>
>>>>md: sdc1's event counter: 00000004
>>>>md0: former device sda1 is unavailable, removing from array!
>>>>md: unbind<sdc1,0>
>>>>md: export_rdev(sdc1)
>>>>md: RAID level -4 does not need chunksize! Continuing anyway.
>>>>md: multipath personality registered as nr 7
>>>>md0: max total readahead window set to 124k
>>>>md0: 1 data-disks, max readahead per data-disk: 124k
>>>>Unable to handle kernel NULL pointer dereference at virtual address=
=20
>>>>00000040
>>>> printing eip:
>>>>e096527e
>>>>*pde =3D 00000000
>>>>Oops: 0000
>>>>CPU:    0
>>>>EIP:    0010:[<e096527e>]    Not tainted
>>>>EFLAGS: 00010246
>>>>eax: deb62a94   ebx: 00000000   ecx: dd65b400   edx: 00000000
>>>>esi: 0000001c   edi: deb62a94   ebp: 00000000   esp: dd5fbdbc
>>>>ds: 0018   es: 0018   ss: 0018
>>>>Process mdadm (pid: 1389, stackpage=3Ddd5fb000)
>>>>Stack: dd4c4000 dfa96000 c035ad00 00000000 00000286 dd4c4000 000000=
00=20
>>>>00000000
>>>>       deb62a94 dd5fbe5c dd4c6000 c02a6e10 dd65b400 c035ef1f 000000=
7c=20
>>>>00000000
>>>>       0000000a ffffffff 00000002 00002e2e c0118b49 00002e2e 00002e=
2e=20
>>>>00000286
>>>>Call Trace:    [<c02a6e10>] [<c0118b49>] [<c0118cc4>] [<c024a88c>]=20
>>>>[<c024abb6>]
>>>>  [<c0118cc4>] [<c024907e>] [<c024b6f2>] [<c024c60c>] [<c014a326>]=20
>>>>[<c013c483>]
>>>>  [<c013ca18>] [<c01375ac>] [<c013ca63>] [<c01439b6>] [<c01087c7>]
>>>>
>>>>Code: 8b 45 40 85 c0 0f 84 c2 01 00 00 6a 00 ff b4 24 cc 00 00 00
>>>>
>>>>Running through ksymoops gives:
>>>>
>>>>Unable to handle kernel NULL pointer dereference at virtual address=
=20
>>>>00000040
>>>>e096527e
>>>>*pde =3D 00000000
>>>>Oops: 0000
>>>>CPU:    0
>>>>EIP:    0010:[<e096527e>]    Not tainted
>>>>Using defaults from ksymoops -t elf32-i386 -a i386
>>>>EFLAGS: 00010246
>>>>eax: deb62a94   ebx: 00000000   ecx: dd65b400   edx: 00000000
>>>>esi: 0000001c   edi: deb62a94   ebp: 00000000   esp: dd5fbdbc
>>>>ds: 0018   es: 0018   ss: 0018
>>>>Process mdadm (pid: 1389, stackpage=3Ddd5fb000)
>>>>Stack: dd4c4000 dfa96000 c035ad00 00000000 00000286 dd4c4000 000000=
00=20
>>>>00000000
>>>>       deb62a94 dd5fbe5c dd4c6000 c02a6e10 dd65b400 c035ef1f 000000=
7c=20
>>>>00000000
>>>>       0000000a ffffffff 00000002 00002e2e c0118b49 00002e2e 00002e=
2e=20
>>>>00000286
>>>>Call Trace:    [<c02a6e10>] [<c0118b49>] [<c0118cc4>] [<c024a88c>]=20
>>>>[<c024abb6>]
>>>>  [<c0118cc4>] [<c024907e>] [<c024b6f2>] [<c024c60c>] [<c014a326>]=20
>>>>[<c013c483>]
>>>>  [<c013ca18>] [<c01375ac>] [<c013ca63>] [<c01439b6>] [<c01087c7>]
>>>>Code: 8b 45 40 85 c0 0f 84 c2 01 00 00 6a 00 ff b4 24 cc 00 00 00
>>>>
>>>>
>>>>>>EIP; e096527e <[multipath]multipath_run+2be/6c0>   <=3D=3D=3D=3D=3D
>>>>
>>>>Trace; c02a6e10 <vsnprintf+2e0/450>
>>>>Trace; c0118b49 <call_console_drivers+e9/f0>
>>>>Trace; c0118cc4 <printk+104/110>
>>>>Trace; c024a88c <device_size_calculation+19c/1f0>
>>>>Trace; c024abb6 <do_md_run+2d6/360>
>>>>Trace; c0118cc4 <printk+104/110>
>>>>Trace; c024907e <bind_rdev_to_array+9e/b0>
>>>>Trace; c024b6f2 <add_new_disk+132/290>
>>>>Trace; c024c60c <md_ioctl+6fc/790>
>>>>Trace; c014a326 <iput+236/240>
>>>>Trace; c013c483 <bdput+93/a0>
>>>>Trace; c013ca18 <blkdev_put+98/a0>
>>>>Trace; c01375ac <fput+bc/e0>
>>>>Trace; c013ca63 <blkdev_ioctl+23/30>
>>>>Trace; c01439b6 <sys_ioctl+216/230>
>>>>Trace; c01087c7 <system_call+33/38>
>>>>Code;  e096527e <[multipath]multipath_run+2be/6c0>
>>>>00000000 <_EIP>:
>>>>Code;  e096527e <[multipath]multipath_run+2be/6c0>   <=3D=3D=3D=3D=3D
>>>>   0:   8b 45 40                  mov    0x40(%ebp),%eax   <=3D=3D=3D=
=3D=3D
>>>>Code;  e0965281 <[multipath]multipath_run+2c1/6c0>
>>>>   3:   85 c0                     test   %eax,%eax
>>>>Code;  e0965283 <[multipath]multipath_run+2c3/6c0>
>>>>   5:   0f 84 c2 01 00 00         je     1cd <_EIP+0x1cd> e096544b=20
>>>><[multipath]m
>>>>ultipath_run+48b/6c0>
>>>>Code;  e0965289 <[multipath]multipath_run+2c9/6c0>
>>>>   b:   6a 00                     push   $0x0
>>>>Code;  e096528b <[multipath]multipath_run+2cb/6c0>
>>>>   d:   ff b4 24 cc 00 00 00      pushl  0xcc(%esp,1)
>>>>
>>>>My /etc/mdadm.conf contains:
>>>>
>>>>DEVICE /dev/sd?1
>>>>ARRAY /dev/md0 level=3Dmultipath num-devices=3D1
>>>>  UUID=3D277e4ba5:6c23c087:e17c877c:da642955
>>>>
>>>>
>>>>Should md multipath be able to handle changes like this with the=20
>>>>underlying devices?
>>>>
>>>>
>>>>Thanks
>>>>
>>>>James Pearson
>>>>
>>>
>>>Hi James,
>>>
>>>My co-worker and I just happened to run into this problem a few days=
=20
>>>ago. So, I would like to share with you what we know.
>>>
>>>The device major/minor numbers no longer match up values recorded in=
 the=20
>>>descriptor array in the md superblock. Because of the exception made=
 in=20
>>>the current code, the descriptor entries are removed and although th=
e=20
>>>real devices are present and accounted for, they are kicked out from=
 the=20
>>>array. This leaves the array with zero devices. When multipath_run()=
 is=20
>>>invoked, it blows up expecting to have had some disks.
>>>
>>>Lars Marowsky-Br=E9e suggested some patches for md multipath in 2002=
 but=20
>>>never made it to mainline 2.4 kernel:
>>>http://marc.theaimsgroup.com/?l=3Dlinux-kernel&m=3D103355467608953&w=
=3D2
>>>
>>>That patch is large and most of it is not requried for this particul=
ar=20
>>>problem.  The section that reinitializes the descriptor array from=20
>>>current rdevs for the case of multipath will resolve this issue of=20
>>>device names shift.
>>>
>>>Lars, Is it ok with you if I compose a patch from your original patc=
h=20
>>>and post it here?
>>
>>Thanks - that patch applies OK to more recent 2.4 kernels and appears=
 to=20
>>'fix' this problem.
>>
>>However, if you have a cut down patch that fixes just this problem, t=
hen=20
>>I would appreciate it if you could make it available.
>>
>>Thanks
>>
>>James Pearson
>>
>=20
>=20
> James,
>=20
> Here is the reduced patch from the patch that Lars originally produce=
d
> that worked for us for that particular problem with the multipath dis=
ks
> major/minor numbers shifting. Hopefully, Marcelo can review it and
> consider it for inclusion in 2.4 mainline. Let us know if this works =
for
> you. The credit, of couse, should still go to Lars. We simply picked =
out
> the part that fixes that particular issue.

Patch appears to work fine.

Thanks

James Pearson
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
