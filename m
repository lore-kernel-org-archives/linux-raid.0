From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: RAID-5 to RAID-6 Reshape Process
Date: Mon, 23 Nov 2009 09:24:54 +0100
Message-ID: <87zl6dmyw9.fsf@frosties.localdomain>
References: <E0A5D033-60CF-4CC6-A124-37C597C6235B@gmail.com>
	<alpine.DEB.1.10.0911230717070.14550@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0911230717070.14550@uplift.swm.pp.se> (Mikael
	Abrahamsson's message of "Mon, 23 Nov 2009 07:19:07 +0100 (CET)")
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Joshua Hattersley <joshhattersley@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael Abrahamsson <swmike@swm.pp.se> writes:

> On Sun, 22 Nov 2009, Joshua Hattersley wrote:
>
>> I have a home server running Ubuntu 9.04 Server (kernel
>> 2.6.28-16-server), which has three drives in RAID-5 using mdadm
>> (version 2.6.7.1 according to mdadm --version).  I would like to
>> reshape this array into a RAID-6 using one additional drive, thereby
>> turning it into a four disk RAID-6 array (with the intention to grow
>> the usable size of the array later on).  I've been scouring the
>> relevant info I can find on the web and haven't come across a
>> well-outlined process by which to accomplish this.
>
> Read the mdadm annoucement from the 19th. You need latest mdadm and
> kernel 2.6.32 to do the reshape. After that is done you can run the
> raid6 on the 2.6.28 kernel you're running already.
>
> Personally I'd make sure my data was properly backed up before doing
> this process, it's quite recent code.

Alternatively you can degarde the raid5, start a new double degraded
raid6 and then copy the data over. If you used LVM on raid that can be
done completly online with pvmove.

MfG
        Goswin
