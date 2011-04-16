From: Simon McNair <simon@mcnair.co.uk>
Subject: Re: single threaded parity calculation ?
Date: Sat, 16 Apr 2011 20:07:14 +0100
Message-ID: <4DA9E8E2.20701@mcnair.co.uk>
References: <4DA89A18.5010002@mcnair.co.uk> <BANLkTims2gPKdxOo4_dd1NAnOz=CcL6yGQ@mail.gmail.com>
Reply-To: simon@mcnair.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTims2gPKdxOo4_dd1NAnOz=CcL6yGQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Drew,
Thanks for the response. Phil is already intimately familiar with this 
but it's an Asus p7t deluxe v2 and the card is a pcie x4 supermicro 8 
port AOC-SASLP-MV8.
Simon

On 16 Apr 2011, at 14:45, Drew <drew.kay@gmail.com 
<mailto:drew.kay@gmail.com>> wrote:

>> iostat reports 83MB/s for each disk, running up to 830MB/s for all 10 
>> disks,
>> but the max read speed of the array is approx 256MB/s.
>
> This may be a dumb question but what motherboard & disk controllers
> are you using and how are they setup?
>
> That 256MB/s feels to me like you may be bumping up against a
> bandwidth limitation of your bus. PCI (32bit/33MHz) is limited to
> 133MB/s max and PCIe(1.0/2.0) is limited to 250/500MB/s per lane. To
> sustain 830MB/s you need at least a PCIe (1.0) x4 or PCI-X 133
> controller card which are both rated for (theoretically) 1GB/s.
>
> As an aside, for read speeds on a RAID-5, the parity disk isn't used
> so theoretical maximum in this case is 9x83MB/s or 747MB/s. ;-)
>
>
> -- 
> Drew
>
> "Nothing in life is to be feared. It is only to be understood."
> --Marie Curie
