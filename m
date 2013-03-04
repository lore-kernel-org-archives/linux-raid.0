From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance - new kernel results - 5x SSD RAID5
Date: Sun, 03 Mar 2013 23:25:21 -0600
Message-ID: <51343041.9010305@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <51222A81.9080600@hardwarefreak.com> <51250377.509@websitemanagers.com.au> <5125B8E5.5000502@hardwarefreak.com> <5125C154.3090603@websitemanagers.com.au> <51272808.7070302@hardwarefreak.com> <512A79D3.9020502@hardwarefreak.com> <5130D206.4090302@websitemanagers.com.au> <5131C338.8010402@hardwarefreak.com> <513231BB.4070903@turmel.org> <ac5cdf66-ba01-4d7b-bd7b-60fb67517ad
 4@email.android.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ac5cdf66-ba01-4d7b-bd7b-60fb67517ad4@email.android.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Phil Turmel <philip@turmel.org>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 3/3/2013 9:19 AM, Adam Goryachev wrote:
> Phil Turmel <philip@turmel.org> wrote:
...
>> Run "dmsetup table" and look at the start sectors for your volumes:
>> Fast-Root: 0 314572800 linear 9:3 3072
>> This volume starts at sector 3072 (1.5MB) on /dev/sda3.  So the volume
>> alignment within LVM is 512K.
> 
> I see this (for the first LV)
> vg0-hostname: 0 204808192 linear 147:2 512
> So, I'm guessing mine is starting at 512, and is also aligned at 512k ?
> 
> Also, pvdisplay tells me the PE Size is 4M, so I'm assuming that regardless of how the LV's are arranged, they will always be 512k aligned?
> 
> So, is that enough to be sure that this is not an issue?

If it starts at sector 512, that should be the first sector of the 2nd
md/RAID stripe, so the first sector of the LV is aligned.  204,808,192
sectors divided by a 256KB stripe width equals 400,016 stripes (a whole
number), so this partition is correctly aligned to the RAID device.  If
you have no gaps between this one and your other LVs, and each of them
is evenly divisible by 512 sectors, then they should all be aligned.

-- 
Stan

