From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID performance -  5x SSD RAID5 - effects of stripe cache
 sizing
Date: Fri, 8 Mar 2013 15:11:13 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1303081506100.378@uplift.swm.pp.se>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <51222A81.9080600@hardwarefreak.com>
 <51250377.509@websitemanagers.com.au> <5125B8E5.5000502@hardwarefreak.com> <5125C154.3090603@websitemanagers.com.au> <51272808.7070302@hardwarefreak.com> <512A79D3.9020502@hardwarefreak.com> <5130D206.4090302@websitemanagers.com.au> <5131C338.8010402@hardwarefreak.com>
 <c886b8ac-9786-4e7d-b6f1-b6fb5d801c85@email.android.com> <5134917F.8060903@hardwarefreak.com> <5134CB39.8050000@websitemanagers.com.au> <5135BB2C.5030400@hardwarefreak.com> <513614F9.1050808@websitemanagers.com.au> <51384366.2030307@hardwarefreak.com>
 <51392E1F.3080000@websitemanagers.com.au> <513962C2.5020809@hardwarefreak.com> <alpine.DEB.2.00.1303080652470.378@uplift.swm.pp.se> <5139B8CC.40805@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5139B8CC.40805@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 8 Mar 2013, Stan Hoeppner wrote:

> The default MaxTransmitBufferSize is actually quite low, 16644 bytes if 
> system RAM is >512MB, and 4356 bytes if RAM <512MB.  You can get it up 
> to 60KB read and 64KB write by modifying some other reg values.  This 
> applies all the way up to Server 2008.  But transmit buffers size isn't 
> the problem in this case.

Indeed, found this:

http://blogs.msdn.com/b/openspecification/archive/2009/04/10/smb-maximum-transmit-buffer-size-and-performance-tuning.aspx

It's not clear to me how the transmit buffers interact with reading from 
drive. If the 60 kilobyte read request comes in, 60 kilobytes (or 
whatever) is read, sent out, wait, new 60 kilobyte request comes in, needs 
to be read from drive, sent, wait. If automatic read-ahead isn't done and 
the blocks read are cached, I can see this going very inefficient very 
quickly.

> Yes, SMB 2.0 was introduced with Vista and 2008.  It has higher 
> throughput over high latency links due to pipelining, but this doesn't 
> yield much on a LAN, even Fast Ethernet.  W2K/XP default SMB can hit the 
> 25MB/s peak duplex data rate of 100FDX.

Yes, if latency is low, this isn't a problem.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
