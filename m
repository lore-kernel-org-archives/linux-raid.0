From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Why 4k native drives haven't arrived
Date: Fri, 03 Jan 2014 16:04:41 -0500
Message-ID: <yq1d2k8zsie.fsf@sermon.lab.mkp.net>
References: <52C61807.6050906@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C61807.6050906@hardwarefreak.com> (Stan Hoeppner's message of
	"Thu, 02 Jan 2014 19:53:11 -0600")
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Stan" == Stan Hoeppner <stan@hardwarefreak.com> writes:

Stan,

Stan> Advanced Format 512e drives, drives with 4K native sectors but
Stan> 512B sectors presented to the host, 

Ignoring ECC, legacy/native drives have a 1:1 mapping between logical
and physical block sizes (512/520/528 bytes).

512e drives have a 512-byte logical block size. That's what the host
operating system uses for addressing purposes when filling out the
command to the disk. Internally, they use 4096-byte physical blocks on
media.

Drives with 4096-byte logical *and* physical blocks are slowly becoming
available. These drives are referred to as 4Kn (4K native) drives. So be
careful about using the term "native" when referring to the physical
sector size.

Linux supports drives with logical block sizes up to the system page
size. This means we support 4Kn drives and have for over a decade. DASD
on the mainframe is 4Kn, for instance. And there are a bunch of SAN
devices and SSDs out there that also report themselves as 4Kn. So
devices absolutely exist and are available.

4Kn harddrives are harder to come by, however. SAS/FC drives are
available formatted as 4Kn when you order them. Some 512n drives can be
reformatted. But you won't find 4Kn formatted drives in retail.

4Kn SATA works fine in Linux as well but has failed to get any
traction. Mainly because there is no win for the user. Just lots of
pain.


Stan> The physical sector size presented to the host is irrelevant to
Stan> the drive manufacturers, given the singular goal above.  Switching
Stan> to a native 4K sector does not benefit the manufacturers.  At the
Stan> current time it actually will cause them tremendous problems.

The drive vendors pushed 4Kn for years and years. The problem was that
to the host there is no benefit whatsoever. Just lots of pain throughout
the entire I/O stack (BIOS, OS, HBA ROMs, RAID controller firmware). And
no win. None.

So the drive vendors begrudgingly did 512e as a transitional thing. But
they would like nothing more than killing off read-modify-write handling
in their firmware/ASICs.

We are sticking with 512-byte logical/physical blocks for server
workloads for several reasons. First of all it's important to have
predictable performance. The read-modify-write cycles for misaligned
writes on 512e drives can severely impact performance.

The second reason is data integrity preservation. None of the consumer
512e drives feature protection against sibling block corruption during
read-modify-write. The nasty thing here is that a partial block write
can end up garbling logical blocks within the 4KB physical sector that
were not part of the failed I/O request. This is an absolute no-go from
a data integrity perspective.

Therefore server drives have two options: Native (512n up to a certain
capacity point, 4Kn for larger drives), or 512e with flash, supercaps or
other tech that'll allow the drive to complete a partial block write
during power failure. Both are out there.


Stan> Thus native 4K drives will not be on the open market until the
Stan> manufacturers are comfortable that most legacy machines have been
Stan> retired, eliminating the possibility of the scenario above.

Actually, >2TB USB drives typically expose 4Kn to the host. For that
reason there are already problems with XP and big drives.

PS. See also: https://oss.oracle.com/~mkp/docs/linux-advanced-storage.pdf

-- 
Martin K. Petersen	Oracle Linux Engineering
