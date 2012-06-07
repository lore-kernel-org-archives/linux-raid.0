From: Joe Landman <joe.landman@gmail.com>
Subject: Re: Software RAID checksum performance on 24 disks not even close
 to kernel reported
Date: Thu, 07 Jun 2012 10:40:56 -0400
Message-ID: <4FD0BD78.2050808@gmail.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com> <CA+4vN7xQgecd95FO6gYVLMuPDKXbfZfzuXS1dzHd+e-otrPxwg@mail.gmail.com> <CAA9_cmcANJjd8gfagWw5vENABh+n13xFnk7OF-ZzxecfxU719w@mail.gmail.com> <4FD028B2.1050306@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FD028B2.1050306@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Not to interject too much here ...

On 06/07/2012 12:06 AM, Stan Hoeppner wrote:
> On 6/6/2012 11:09 AM, Dan Williams wrote:
>
>> Hardware raid ultimately does the same shuffling, outside of nvram an
>> advantage it has is that parity data does not traverse the bus...
>
> Are you referring to the host data bus(s)?  I.e. HT/QPI and PCIe?
>
> With a 24 disk array, a full stripe write is only 1/12th parity data,
> less than 10%.  And the buses (point to point actually) of 24 drive
> caliber systems will usually start at one way B/W of 4GB/s for PCIe 2.0
> x8 and with one way B/W from the PCIe controller to the CPU starting at

PCIe gen 2 is ~500MB/s per lane in each direction, but there's like a 
14% protocol overhead, so your "sustained" streaming performance is more 
along the lines of 430 MB/s.  For a PCIe x8 gen 2 system, this nets you 
about 3.4GB/s in each direction.

> 10.4GB/s for AMD HT 3.0 systems.  PCIe x8 is plenty to handle a 24 drive
> md RAID 6, using 7.2K SATA drives anyway.

Each drive capable of streaming say 140 MB/s (modern drives).  24 x 140 
= 3.4 GB/s

This assumes streaming, no seeks that aren't part of streaming.

This said, this is *not* a design pattern you'd want to follow for a 
number of reasons.

But for seek heavy designs, you aren't going to hit anything close to 
140 MB/s.  We've just done a brief study for a customer on what they 
should expect to see (by measuring it and reporting on the measurement). 
  Assume close to an order of magnitude off for seekier loads.

Also, please note that iozone, dd, bonnie++, ... aren't great load 
generators, especially if things are in cache.  You tend to measure the 
upper layers of the file system stack, and not the actual full stack 
performance.  fio does a better job if you set the right options.  This 
said, almost all of these codes suffer from a measurement at the front 
end of the stack, if you want to know what the disks are really doing, 
you have to start poking your head into the kernel proc/sys spaces. 
Whats interesting is that of the tools mentioned, only fio appears to 
eventually converge its reporting to what the backend hardware does. 
The front end measurements seem to do a pretty bad job of deciding when 
an IO begins and when it is complete.  Could be an fsync or similar 
problem (discussed in the past), but its very annoying.  End users look 
at bonnie++ and other results and don't understand why their use case is 
so badly different in performance.


> What is a bigger issue, and may actually be what you were referring to,
> is read-modify-write B/W, which will incur a full stripe read and write.
>   For RMW heavy workloads, this is significant.  HBA RAID does have a big
> advantage here, compared to one's md array possessing the aggregate
> performance to saturate the PCIe bus.

The big issues for most HBAs are the available bandwidth to the disks, 
the quality/implementation of the controllers/drivers, etc.  Hanging 24 
drives off a single controller is a low cost design, not a high 
performance design.  You will get contention (especially with expandor 
chips).  You will get sub-optimal performance.

Checksumming speed on the CPU will not be the bottleneck in most of 
these cases.  Controller/driver performance and contention will be.

Back to your regularly scheduled thread ...

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
