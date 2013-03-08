From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID performance -  5x SSD RAID5 - effects of stripe cache
 sizing
Date: Fri, 8 Mar 2013 06:57:20 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1303080652470.378@uplift.swm.pp.se>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au>
 <5120A84E.4020702@websitemanagers.com.au> <51222A81.9080600@hardwarefreak.com> <51250377.509@websitemanagers.com.au> <5125B8E5.5000502@hardwarefreak.com> <5125C154.3090603@websitemanagers.com.au> <51272808.7070302@hardwarefreak.com> <512A79D3.9020502@hardwarefreak.com>
 <5130D206.4090302@websitemanagers.com.au> <5131C338.8010402@hardwarefreak.com> <c886b8ac-9786-4e7d-b6f1-b6fb5d801c85@email.android.com> <5134917F.8060903@hardwarefreak.com> <5134CB39.8050000@websitemanagers.com.au> <5135BB2C.5030400@hardwarefreak.com>
 <513614F9.1050808@websitemanagers.com.au> <51384366.2030307@hardwarefreak.com> <51392E1F.3080000@websitemanagers.com.au> <513962C2.5020809@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <513962C2.5020809@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 7 Mar 2013, Stan Hoeppner wrote:

> I think you missed the point.  SMB with TS<->DC is ~10MB/s, but should 
> be more like 100MB/s.  Run the FTP client on TS against the FTP service 
> on the DC.  Get and put files from/to the 300GB NTFS volume that is 
> shared.  If FTP is significantly faster then we know SMB is the problem, 
> or something related to SMB, not TCP.

Don't know if it's obvious to everybody, so if you already know the 
internals of SMB, you can stop reading:

Older versions of SMB uses a 60 kilobyte block for transferring files. 
This works by requesting a block, waiting for that block to be delivered, 
then requesting the next one. Those who remember Xmodem will know what I'm 
talking about.

So if there is latency introduced somewhere, SMB performance deteriorates 
severely, to the point where if there is 30 ms delay, one can't really get 
more than 1 megabyte/s transfer speed, even if there is a 10GE pipe 
between the involved computers.

1 second / 30 milliseconds = 33 roundtrips, 60 kilbytes per roundtrip 
means 1980 kilobytes/s max theoretical throughput for SMB on 30 ms link.

Latencies can be introduced by trying to read for HDDs as well, so... this 
might be worthwile to look at.

I don't know exactly when the better versions of SMB/CIFS were introduced, 
but I believe it happened in Vista / Windows server 2008.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
