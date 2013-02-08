From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Sat, 09 Feb 2013 01:31:30 +1100
Message-ID: <51150C42.4040703@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <5113A3D4.6000605@turmel.org> <5113A4E9.5020005@websitemanagers.com.au> <5113A628.6010304@turmel.org> <9DD5BA53-A9DF-4D8C-AE5C-BD6D69FAEF2C@colorremedies.com> <C96434C1-FD46-456E-9FE2-C0B50727D219@colorremedies.com> <37E3C429-0A78-4DAE-BD2C-F23CF931BD91@colorremedies.com> <51149A66.6000308@websitemanagers.com.au> <DFB376BB-32B9-48DE-A7E9-A1B8F97982EF@colorremedies.com> <A48D2760-7317-475D-9A95-27DCD8C47DBD@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A48D2760-7317-475D-9A95-27DCD8C47DBD@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "stan@hardwarefreak.com Hoeppner" <stan@hardwarefreak.com>, Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org list" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/02/13 19:34, Chris Murphy wrote:
> 
> On Feb 8, 2013, at 12:35 AM, Chris Murphy <lists@colorremedies.com>
> wrote:
>> 
>> I'm flummoxed off hand if an NTFS formatted iSCSI block device
>> behaves exactly as an NTFS formatted LV;
> 
> The answer depends on whether you formatted the iSCSI target directly
> or partitioned it, then formatted the partition. If the latter, use
> kpartx -av to make the partition available under /dev/mapper and then
> you mount the device kpartx returns. Anyway the point was to run
> benchmarks on these; but if you have space in the VG you can make new
> (smaller) LVs for this, it's slightly safer.
> 
> I'd benchmark one LV as a reference. Then two simultaneously. Then
> three. I think the more basic the test for now the better or there's
> just too much data. Then I'd do that same test on physical servers,
> over iSCSI (one, two, then three simultaneous targets). Then do that
> same test within a VM, over iSCSI.
> 
> Trust Stan and Phil on this more than me. I just think something
> appallingly obvious will materialize with simple tests, and then you
> can dig down deeper with more specific tests.
> 
> First though, sort out this write error business. That bugs me more
> than the benchmarking stuff. Client and server side write errors in
> an iSCSI context make me think of file system corruption, either the
> write error caused by file system corruption, or creating it.

The write errors are pop-ups on windows saying "Delayed Write Failure -
some part of the file blahblah could not be written, this may be due to
network or system errors, etc..."

This message is also recorded in the "Event Viewer", and also logged to
the "console" as individual message boxes that you can click OK to
dismiss each one.

Sorry, I've shutdown everything now so don't have the full message, but
in effect, windows fails to write the data, and that write is thrown
away. Generally the application will terminate, and re-starting is OK.
Often, Excel will end up with a corrupted file, and the file needs to be
recovered from the backup system (at least we have one). Also, Outlook
will have problems recovering, and MYOB will frequently fail  and crash
(MYOB is australian commercial accounting application).

IMHO, these are significant issues, I'd be happy to have slow
performance, as long as no data was lost or corrupted (well, happier :)).


Since restarting the physical box that is running the windows 2000 DC
last night (less than 24 hours), there were zero error messages in the
dmesg output. Just the startup and shutdown messages to create and
destroy the virtual network interface when the VM was booted and shutdown.

On the storage server, there are zero messages in the kern.log file
between 6:57am and 8:57pm (which is when the DRBD connection to the
second server is stopped and started). Same applies to the messages and
syslog files....

I might have a network related issue, but I really want to ensure that
RAID/disk performance is right/sorted before I move on. Else I'll start
looking at lots of things and never properly tick anything off as OK.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
