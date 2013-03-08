From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance -  5x SSD RAID5 - effects of stripe cache sizing
Date: Fri, 08 Mar 2013 04:09:16 -0600
Message-ID: <5139B8CC.40805@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <51222A81.9080600@hardwarefreak.com> <51250377.509@websitemanagers.com.au> <5125B8E5.5000502@hardwarefreak.com> <5125C154.3090603@websitemanagers.com.au> <51272808.7070302@hardwarefreak.com> <512A79D3.9020502@hardwarefreak.com> <5130D206.4090302@websitemanagers.com.au> <5131C338.8010402@hardwarefreak.com> <c886b8ac-9786-4e7d-b6f1-b6fb5d801c85@email.android.com> <5134917F.8060903@hardwarefreak.com> <5134CB39.8050000@websitemanagers.com.au> <5135BB2C.5030400@hardwarefreak.com> <513614F9.1050808@websitemanagers.com.au> <51384366.2030307@hardwarefreak
 .com> <51392E1F.3080000@websitemanagers.com.au> <513962C2.5020809@hardwarefreak.com> <alpine.DEB.2.00.1303080652470.378@uplift.swm.pp.se>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1303080652470.378@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 3/7/2013 11:57 PM, Mikael Abrahamsson wrote:
> On Thu, 7 Mar 2013, Stan Hoeppner wrote:
> 
>> I think you missed the point.  SMB with TS<->DC is ~10MB/s, but should
>> be more like 100MB/s.  Run the FTP client on TS against the FTP
>> service on the DC.  Get and put files from/to the 300GB NTFS volume
>> that is shared.  If FTP is significantly faster then we know SMB is
>> the problem, or something related to SMB, not TCP.
> 
> Don't know if it's obvious to everybody, so if you already know the
> internals of SMB, you can stop reading:
> 
> Older versions of SMB uses a 60 kilobyte block for transferring files.
> This works by requesting a block, waiting for that block to be
> delivered, then requesting the next one. Those who remember Xmodem will
> know what I'm talking about.

The default MaxTransmitBufferSize is actually quite low, 16644 bytes if
system RAM is >512MB, and 4356 bytes if RAM <512MB.  You can get it up
to 60KB read and 64KB write by modifying some other reg values.  This
applies all the way up to Server 2008.  But transmit buffers size isn't
the problem in this case.

> So if there is latency introduced somewhere, SMB performance
> deteriorates severely, to the point where if there is 30 ms delay, one
> can't really get more than 1 megabyte/s transfer speed, even if there is
> a 10GE pipe between the involved computers.

It's very unlikely that he's hitting latency over the wire.  GbE latency
is ~250uS (0.25ms).  We know from others' published experience that the
8111 series Realteks can be good for up to 90MB/s with fast CPUs, but
that others have trouble getting 25MB/s from them.  They could be part
of the problem here due to drivers, virtualization, etc.  I'm sure we'll
be looking at this.  Recall I recommended some time ago that Adam should
perform end-to-end netcat testing on all of his hosts' NIC ports to get
a baseline of TCP performance.

> Latencies can be introduced by trying to read for HDDs as well, so...
> this might be worthwile to look at.

The problem could be one of any number of things, or a combination.
It's too early to tell without testing.  And the FTP test won't be the
last.  Hunting down Windows server performance problems is bad enough,
but once virtualized it gets worse.

> I don't know exactly when the better versions of SMB/CIFS were
> introduced, but I believe it happened in Vista / Windows server 2008.

Yes, SMB 2.0 was introduced with Vista and 2008.  It has higher
throughput over high latency links due to pipelining, but this doesn't
yield much on a LAN, even Fast Ethernet.  W2K/XP default SMB can hit the
25MB/s peak duplex data rate of 100FDX.

-- 
Stan

