From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: southbridge/sata controller performance?
Date: Sun, 4 Jan 2009 16:32:27 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901041630000.20628@p34.internal.lan>
References: <20090103193429.GA17462@sewage.raw-sewage.fake> <495FC67A.2030201@gmail.com> <alpine.DEB.1.10.0901040451520.18797@p34.internal.lan> <20090104194023.GB10174@sewage.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090104194023.GB10174@sewage.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Roger Heflin <rogerheflin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sun, 4 Jan 2009, Matt Garman wrote:

> On Sun, Jan 04, 2009 at 04:55:18AM -0500, Justin Piszcz wrote:
>>> The biggest different for RAID is what happens when multiple
>>> channels are used.   On full speed streaming read/write almost
>>> every (even the worst PCI controllers on a PCI bus) sata
>>> controller is close to equal when you only have one drive, once
>>> you use 2 drives or more things change.   If the given controller
>>> setup can actually run several drives at close to full single
>>> drive speed performance will be good, if it cannot things are
>>> going to get much slower.
>
> So, in general, the ideal is to be able to simultaneously read/write
> from multiple disks at the same speed as a single drive.
>
>> This has been discussed before, on the southbridge it is usually
>> good/you will get the maximum bandwidth for each of the 6 sata
>> ports.  After that, you need to use PCI-e lanes from the
>> northbridge.  Using PCI-e x1 slots that come off the southbridge
>> can degrade performance of the 6 SATA ports or the speed coming
>> off the drives connected to the x1 slots will be slow.
>
> Are you talking about using additional SATA controllers (i.e. via
> add-on cards)?  Or simply talking about the interconnect between the
> southbridge and the northbridge?
Interconnect between northbridge and southbridge.  When all 6 channels on
mobo are in use, speed from PCI-e x1 is ~80MiB/s, when you stop that access
from all 6 ports, I get ~120MiB/s.

>
> I think you're talking about the former, i.e. the SATA controller
> integrated in the southbridge generally ought to be fine, but if you
> start adding additional controllers that hang off the south bridge,
> their could be competition for bandwidth to the northbridge...
> right?  (And wouldn't the nvidia chips have an edge here, since they
> have everything combined into one chip?)
>
> Makes intuitive sense anyway; but in my case I'm really just curious
> about the SATA controller integrated into the southbridge; not
> concerned with additional SATA controllers.
>
>> What are you trying to accomplish?
>
> Trying to determine what motherboard would be ideal for a home NAS
> box AND have the lowest power consumption... the AMD solutions seem
> to win on the power consumption front, but I'm not sure about the
> performance.
How fast do you need? Gigabit is only ~100MiB/s.  Are you buying a 10Gbps
card?

>
>> As Roger pointed out, doing a dd is a good way to test, from each
>> disk, simultaneously, on an old Intel P965 board I was able to
>> achieve 1.0-1.1Gbyte/sec doing that with 12 Velociraptors and
>> 1.0Gbyte/sec reads on the XFS filesystem when dd (reading) large
>> data on the volume.  Approx 500-600MiB/s from the southbridge, the
>> other 400MiB/s from the northbridge.
>
> Is the "parallel dd test" valid if I do a raw read off the device,
> e.g. "dd if=/dev/sda of=/dev/null"?  All my drives are already in an
> md array, so I can't access them individually at the filesystem
> level.
Yes.  You do not need to access them at the filesystem level.  Both RAW
and on the filesystem, my benchmarks were the same when reading from 10 disks
raw or reading in a large file with dd using XFS as the filesystem.

Justin.

