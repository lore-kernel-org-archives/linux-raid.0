From: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Subject: Re: Debugging new HW XOR engine driver
Date: Thu, 17 Jul 2008 18:37:29 -0700 (PDT)
Message-ID: <663880.24246.qm@web81306.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dan,
Corruption I see is ext3_chec_descriptor: error.=A0Error suggesting to =
run fsck. When I run fsck it complains that "there is no valid file sys=
tem". Curroption seems to be happening with only=A0huge data files bein=
g written to=A0/dev/md0.=A0
=A0 I tried to write one stripe(12k -- with 4disks) and half stripe (6k=
B). I don't corruption with small files,=A0Every time I write and read =
it back=A0works fine up to 40MB.=20
=A0I know it is too much to ask . Do you happened to have sample code y=
ou used to debug=A0 your driver. I am using xor_blocks() function to co=
mpute XOR in the aync_xor() function to compare SW and HW XOR calculati=
ons. I am not sure if that is right way to do it. So far I did not see =
data missmatch.
Thanks and Regards,
Marri
=A0

----- Original Message ----
=46rom: Dan Williams <dan.j.williams@intel.com>
To: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Cc: thomas62186218@aol.com; linux-raid@vger.kernel.org
Sent: Tuesday, July 15, 2008 11:48:46 PM
Subject: Re: Debugging new HW XOR engine driver

On Tue, Jul 15, 2008 at 3:52 PM, tirumalareddy marri
<tirumalareddymarri@yahoo.com> wrote:
> I am able to create a disk size of 40MB and mount it(mkfs.ext3 -b 409=
6 /dev/md0 10000). I was able to copy files to this mounted disk and re=
ad them back. If I increased the size more than 40MB file system if fai=
ling to mount.
>=A0 Is it possible that data I have read/write was in page cache and n=
ever really written to Hard Disks=A0 ?

What does the corruption look like?=A0 Does it seem to be wrong data or
stale data?

> Is it safe to say RAID-5 is partially working ?

Without more information this sounds like the hw-xor driver is broken.
What kernel version are you developing against?=A0 You may want to take
a look at the dmatest client in async_tx/next [1].=A0 It currently only
supports copy tests, but should exercise your driver's descriptor
processing routines.=A0 When I tracked down bugs in iop-adma I used
raid5 as the test client and modified the kernel to do data
verification after each calculation in the ops_complete_* routines.
This requires userspace to use a predictable data pattern when writing
to the array.

--
Dan

[1] http://git.kernel.org/?p=3Dlinux/kernel/git/djbw/async_tx.git;a=3Ds=
hortlog;h=3Dnext
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
