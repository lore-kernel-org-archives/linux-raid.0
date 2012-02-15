From: keld@keldix.com
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Wed, 15 Feb 2012 14:08:29 +0100
Message-ID: <20120215130829.GA6452@www5.open-std.org>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com> <4F35E925.6000003@hardwarefreak.com> <CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com> <4F38FD5D.1010201@hardwarefreak.com> <CAGqmV7o6SNGV_A=iP2-uJXAJpPwh83GuqTZ-BzuY6vceMJJPVg@mail.gmail.com> <20120213230228.GA5822@www5.open-std.org> <4F39D9B2.3050305@hardwarefreak.com> <20120214113832.GA6157@www5.open-std.org> <4F3AEDEF.2000608@hardwarefreak.com> <4F3BA0B8.2000405@westcontrol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F3BA0B8.2000405@westcontrol.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: stan@hardwarefreak.com, CoolCold <coolthecold@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Feb 15, 2012 at 01:10:32PM +0100, David Brown wrote:
> 
> Reads will normally be taken from the outer halves (A1 and B1), since 
> these have faster throughput, and keeping the heads there means half the 
> head movement (actually less than that on average).  But if the system 
> happens to be reading from (or writing to) A1, and needs access to data 
> that is also on A1, it can read it from B2 in parallel.

reads in raid10,far will allways come from the lowest block available disk,
that is the fastest disk on most hardware disks. This is to prevent
oddly characteriscs disks from not striping: when two disks with eg slightly
different access times were read from, the IO driver could tend to favourize
the faster, and thus make overall operations slower. This also works in
degraded mode. I wrote the one-line patch:-)

Best regards
Keld
