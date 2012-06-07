From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Software RAID checksum performance on 24 disks not even close
 to kernel reported
Date: Wed, 06 Jun 2012 23:06:10 -0500
Message-ID: <4FD028B2.1050306@hardwarefreak.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com> <CA+4vN7xQgecd95FO6gYVLMuPDKXbfZfzuXS1dzHd+e-otrPxwg@mail.gmail.com> <CAA9_cmcANJjd8gfagWw5vENABh+n13xFnk7OF-ZzxecfxU719w@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmcANJjd8gfagWw5vENABh+n13xFnk7OF-ZzxecfxU719w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/6/2012 11:09 AM, Dan Williams wrote:

> Hardware raid ultimately does the same shuffling, outside of nvram an
> advantage it has is that parity data does not traverse the bus...

Are you referring to the host data bus(s)?  I.e. HT/QPI and PCIe?

With a 24 disk array, a full stripe write is only 1/12th parity data,
less than 10%.  And the buses (point to point actually) of 24 drive
caliber systems will usually start at one way B/W of 4GB/s for PCIe 2.0
x8 and with one way B/W from the PCIe controller to the CPU starting at
10.4GB/s for AMD HT 3.0 systems.  PCIe x8 is plenty to handle a 24 drive
md RAID 6, using 7.2K SATA drives anyway.

What is a bigger issue, and may actually be what you were referring to,
is read-modify-write B/W, which will incur a full stripe read and write.
 For RMW heavy workloads, this is significant.  HBA RAID does have a big
advantage here, compared to one's md array possessing the aggregate
performance to saturate the PCIe bus.

-- 
Stan
