From: "Andrew Rechenberg Lists" <flux-ml@resurgent.com>
Subject: RE: RAID-10 and 4 HDDs - how many HDDs can break without loosing data?
Date: Mon, 14 Aug 2006 17:48:08 -0400
Message-ID: <E3B0B2160F552B408D3655883F58C1440D0145@cinshrexc02.shermfin.com>
References: <44DAF2C1.2050308@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <44DAF2C1.2050308@wpkg.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm not sure if the kernel raid10 module is the same as building a RAID0
md device out of multiple RAID1 devices.

We used to use the later to create a RAID10 device by striping Linux SW
RAID1 devices.  We had great luck creating a RAID10 array out of a large
number of disk spindles.

So in your /etc/raidtab (or /etc/mdadm.conf) your RAID0 /dev/md2 would
consist of striping across /dev/md0 and /dev/md1.  In your diagram below
your HDD1 and HDD2 would be mirrored to create either md0 or md1 and
HDD3 and HDD4 would then be the other md device.

I know how that works and it worked reliably for me so that's what I
would recommend doing.

BTW, you could only survive a 2 disk failure if they were the "correct"
2 disks.  If both HDD1 and HDD2 would fail then you would be out of
luck.  Again, I've never used the kernel raid10 module, and I haven't
been able to find any good (visual) information on the module to be able
to determine how the module would survive disk failures.  I would assume
it's the same as the striping of RAID1 devices that I described above,
but I don't like to assume ;)

Good luck,
Andy.

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Tomasz
Chmielewski
Sent: Thursday, August 10, 2006 4:48 AM
To: linux-raid@vger.kernel.org
Subject: RAID-10 and 4 HDDs - how many HDDs can break without loosing
data?

I want to set up RAID-10 on 4 400 GB drives, on not-so powerful machine
(600 MHz ARM, Thecus n4100) - to have a total of 800 GB storage, with
some protection against a drive failure.

As the machine is not very powerful, I don't want to use RAID-5 nor
RAID-6.


Previously, I would use RAID-0 on top of two RAID-1s:

     ----RAID0----
     |           |
   RAID1       RAID1
  |    |       |    |
HDD1 HDD2   HDD3 HDD4


With RAID-0 on top of RAID-1, with 4 drives, I would achieve:
- 100% chance of recovery if any single, one disk fails,
- 50% chance of recovery if any two disk failure.


Now with RAID-10 in the Linux kernel, what are my chances of recovering
from a single and two disk failure?

        RAID10
  ------------------
  |    |      |    |
HDD1 HDD2  HDD3 HDD4

Is it also 100% if one disk fails, and 50% if two disks fail?

Or perhaps, with 4 drives, RAID-10 can survive any 2 disks failure?


--
Tomasz Chmielewski
http://wpkg.org
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html
Confidentiality Notice: This e-mail message including attachments, if any, is intended
only for the person or entity to which it is addressed and may contain confidential
and/or privileged material. Any unauthorized review, use, disclosure or distribution
is prohibited. If you are not the intended recipient, please contact the sender by reply
e-mail and destroy all copies of the original message. If you are the intended recipient,
but do not wish to receive communications through this medium, please so advise the
sender immediately.


