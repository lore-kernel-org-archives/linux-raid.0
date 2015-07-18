From: Steven Reddie <steven.reddie@gmail.com>
Subject: Re: Reversing parity recalculation on out-of-order RAID 6 array
Date: Sat, 18 Jul 2015 18:35:25 +1000
Message-ID: <CAFcup8G230TBec=FzM45GqUkb218yWcYiJJiHDNOkv9MQHkF0g@mail.gmail.com>
References: <CAFcup8FgJqu6q2BoUc7OSEL=iCFf_43wzj7dBuFXYp2R0t2kdg@mail.gmail.com>
	<alpine.DEB.2.02.1507180731040.11810@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1507180731040.11810@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Mikael,

I did look through the archives and also at that recovery wiki and
permute script, but I think my case is different, even though I'm sure
others must have also hit it before. My problem isn't that I don't
know the order of the disks in the array, but that the data in the
array has been scrambled. As an example, if a given extent in the
array was ordered across the disks as so:

    A B C P Q

where:
    P = A ^ B ^ C
    Q = A ^ mul(B) ^ mul(mul(C))

Then when my array was reconfigured in the incorrect order (say, with
disk 2 moved to the end), the layout was reordered to became:

    A C P Q B

Then when the array was recreated in this state, the parity
information was recalculated such that the data on disk became:

    A C P P' Q'

where:
    P' = A ^ C ^ P
    Q' = A ^ mul(C) ^ mul(mul(P))

Thus, the new parity information is now a function of two out of three
of the original data chunks (A and C) and one of the original parity
chunks (P), with data chunk B having been overwritten.

I need to reverse these disk writes across then entire length of the
array, after which I can reassemble the array in the correct order.

Thanks,

Steven

On Sat, Jul 18, 2015 at 3:33 PM, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
> On Sat, 18 Jul 2015, Steven Reddie wrote:
>
>> I'm kind of hoping that all of this might have already been done, so
>> any pointers would be appreciated.
>
>
> https://raid.wiki.kernel.org/index.php/RAID_Recovery
> https://raid.wiki.kernel.org/index.php/Permute_array.pl
>
> There have historically been lots of threads here with people having the
> same problems, so if you search the archives for things like "assume-clean",
> "order", "mdadm", "create", "superblock", you'll find multiple examples of
> people actually successfully getting out of the problem you're also having.
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se
