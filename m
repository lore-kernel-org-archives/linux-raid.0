From: Phil Turmel <philip@turmel.org>
Subject: Re: Query regarding disk failure
Date: Wed, 10 Jul 2013 11:22:20 -0400
Message-ID: <51DD7C2C.2080901@turmel.org>
References: <51DD4EF0.6020509@perpetual-data.com> <20130710131119.GA26658@cthulhu.home.robinhill.me.uk> <51DD6D07.1060401@perpetual-data.com> <51DD74F0.8020006@turmel.org> <51DD79B4.3000102@perpetual-data.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51DD79B4.3000102@perpetual-data.com>
Sender: linux-raid-owner@vger.kernel.org
To: Priya Kamala <priya.kamala@perpetual-data.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/10/2013 11:11 AM, Priya Kamala wrote:
> 
> On 10/07/2013 15:51, Phil Turmel wrote:
>> You haven't actually told us whether it is turned on.  Desktop drives
>> that support it don't have it enabled by default.  Please show "smartctl
>> -l scterc /dev/sdX" for each of your drives.
> I don't have access to the original system right now. This is the output
> from the another system with the same drive type. All the drives show
> the same output, so I'm including only one. The drives are Seagate
> Barracuda ES.2 Model ST31000340NS.

Ok, enterprise drives.  ERC is on by default.

> -bash-4.1# smartctl -l scterc /dev/sda
> smartctl 5.43 2012-06-30 r3573 [i686-linux-3.2.40] (local build)
> Copyright (C) 2002-12 by Bruce Allen, http://smartmontools.sourceforge.net
> 
> SCT Error Recovery Control:
>            Read:    100 (10.0 seconds)
>           Write:    100 (10.0 seconds)

Did you have an idea of number of read error events?  "Pending" sector
counts on the problem drive might be a useful number to report.  (Or
just report complete output of "smartctl -x" for each drive.)

Meanwhile, what distro, kernel, and mdadm versions are involved here?

Phil

