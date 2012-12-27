From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: possibly silly configuration question
Date: Fri, 28 Dec 2012 03:21:24 +1100
Message-ID: <50DC7584.4030701@websitemanagers.com.au>
References: <50DBCB88.5070408@meetinghouse.net> <50DBD1E5.8000206@websitemanagers.com.au> <50DC710E.7040402@meetinghouse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50DC710E.7040402@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: Miles Fidelman <mfidelman@meetinghouse.net>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 28/12/12 03:02, Miles Fidelman wrote:
> Adam,
>
> Thanks for the suggestions.  The thing I'm worried about is how much
> traffic gets generated as I start wiring together more complex
> configurations, and the kind of performance hits involved
> (particularly if a node goes down and things start getting re-syncd).
>
With my suggested config, I'd put 2 x Gb ethernet from each machine on
one vlan, and the other two from each to the network. (Actually, what is
you're bandwidth to the end user? If these are Internet services, you
probably don't need 2 x Gb connections, so use 3Gb for the storage, and
1Gb for the end user facing network).

Anyway, under normal load, you should get reasonable performance (you
are using spinning disks for a random small read/write load (assumed)),
so you won't get fantastic IO performance anyway (hopefully they are 15k
rpm enterprise disks). Ideally, as you said, putting two storage servers
with 8 disks each in RAID10 would provide much better performance, but
you don't always get what you want....

When a system fails, you will get degraded I/O performance, since you
now have additional load on the remaining machines, but I suppose
degraded performance is better than a total outage. When the machine
comes back into service, just ensure the resync speed is low enough to
not cause additional performance degradation. You could even delay the
resync until "off peak" times.

At the end of the day, you will need to examine your work load, and
expected results, if they are not possible with existing hardware, you
either need to change the hardware, or change the work load, or change
the expected results.

The biggest issue I've found with this type of setup is the lack of I/O
performance, which simply comes down to the fact you have a small number
of disks trying to seek all over the place to satisfy all the different
VM's. Seeks really kill performance. The only solutions are:
1) Get lots of (8 or more) fast disks (15k rpm) and put them in RAID10,
then proceed from there...
2) Get enterprise grade SSD's and use some RAID for data protection (no
need for RAID10, use RAID5 or RAID6).

Personally, I have a couple of systems in live operation, one is using 4
disks in RAID10, and it mostly works.... another is using 5 consumer
grade SSD's in RAID5, with the secondary DRBD using 4 disks in RAID10
and it mostly works. I'd love to replace everything with the consumer
grade SSD's, but I just can't justify the dollars in these scenarios. If
only I had realised this issue before I started.... SSD's are amazing
with lots of small, random, IO.

Do you actually know what the workload will be ?

PS. I did forget to add last time, I could be wrong, the above could be
a bunch of nonsense, etc... Though hopefully it will help...

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au

