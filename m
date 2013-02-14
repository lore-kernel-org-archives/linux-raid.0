From: Dave Cundiff <syshackmin@gmail.com>
Subject: Re: Possible to rescue SW Raid5 with 2 missing Disks
Date: Thu, 14 Feb 2013 12:18:27 -0500
Message-ID: <CAKHEz2YWqKTchKs=STmDtWCoRroZVw3wKfjOkz793A=nrKy=hA@mail.gmail.com>
References: <20130214150128.53080@gmx.net>
	<alpine.DEB.2.00.1302141802460.32644@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1302141802460.32644@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Dragon <Sunghost@gmx.de>, Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Feb 14, 2013 at 12:09 PM, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
> On Thu, 14 Feb 2013, Dragon wrote:
>
>> no i dindnt have a old version of examin from before ;(
>

Are the 2 disks completely failed? Or just dropped from the array?
Can you provide mdadm -E output from all devices that were in the array?

>
> Do you know what version of kernel and mdadm was used to create the raid5 in
> the first place? You should go back to that (at least the mdadm version) and
> try the --create --assume-clean with that mdadm version. Several key factors
> have changed between versions.

I would not do a --create --assume-clean on your array until you have
exhausted all other options. At 40TB this sounds like a very large
array. With raid5 disk ordering among other things is VERY important.


>
> Look at this thread for a person with similar problem
> <http://www.spinics.net/lists/raid/msg41732.html>, there is discussion about
> data offset etc in there, might be a good start.
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
Dave Cundiff
System Administrator
A2Hosting, Inc
http://www.a2hosting.com
