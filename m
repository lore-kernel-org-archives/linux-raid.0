From: Brad Campbell <brad@fnarfbargle.com>
Subject: Re: Maximizing failed disk replacement on a RAID5 array
Date: Tue, 07 Jun 2011 13:35:51 +0800
Message-ID: <4DEDB8B7.2070708@fnarfbargle.com>
References: <BANLkTimBYFhjQ-sC9DhTMO+PG-Ox+A9S2Q@mail.gmail.com>	<BANLkTimOxCF7diZfeFgtqCBWKZVF2pxyLg@mail.gmail.com>	<BANLkTi=px08AWxfJJq+zNepCZM8aAsKECA@mail.gmail.com>	<4DECF025.9040006@fnarfbargle.com>	<BANLkTi=jPiXLySacVZqDkeThdG80K_HTxQ@mail.gmail.com>	<4DECF841.1060906@fnarfbargle.com>	<BANLkTikPxQvyDD3d_A6d3+GLKOLgqFJbFw@mail.gmail.com> <BANLkTi=+2GFWRFKT0SCXRtkdn71msgDY=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=+2GFWRFKT0SCXRtkdn71msgDY=g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Durval Menezes <durval.menezes@gmail.com>
Cc: linux-raid@vger.kernel.org, Drew <drew.kay@gmail.com>
List-Id: linux-raid.ids

On 07/06/11 13:03, Durval Menezes wrote:
> Hello Folks,
>
> Just finished the "repair". It completed OK, and over SMART the HD now
> shows a "Reallocated_Sector_Ct" of 291 (which shows that many bad
> sectors have been remapped), but it's also still reporting 4
> "Current_Pending_Sector" and 4 "Offline_Uncorrectable"... which I
> think means exactly the same thing, ie, that there are 4 "active"
> (from the HD perspective) sectors on the drive still detected as bad
> and not remapped.
>
> I've been thinking about exactly what that means, and I think that
> these 4 sectors are either A) outside the RAID partition (not very
> probable as this partition occupies more than 99.99% of the disk,
> leaving just a small, less than 105MB area at the beginning), or B)
> some kind of metadata or unused space that hasn't been read and
> rewritten by the "repair" I've just completed. I've just done a "dd
> bs=1024k count=105</dev/DISK>/dev/null" to account for the
> hyphotesys A), and come out empty: no errors, and the drive still
> shows 4 bad, unmapped sectors on SMART.
>
> So, by elimination, it must be either case B) above, or a bug in the
> linux md code (which prevents it from hitting every needed block on
> the disk), or a bug in SMART (which makes it report inexistent bad
>
Try running a SMART long test smartctl -t long and it will tell you whether the sectors are really 
bad or not.
I've had instances where the firmware still thought that some previously pending sectors were still 
pending until I forced a test, at which time the drive came to its senses and they went away.

I believe if you wait until the drive gets around to doing its periodic offline data collection 
you'll see the same thing, but a long test is nice as it will give you an actual block number for 
the first failure (if you have one)

