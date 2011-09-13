From: Alexander =?iso-8859-1?b?S/xobg==?= <alexander.kuehn@nagilum.de>
Subject: Re: RAID6 issues
Date: Tue, 13 Sep 2011 10:12:56 +0200
Message-ID: <20110913101256.Horde.BlNQOpk8pphObxCII67BCSk@cakebox.homeunix.net>
References: <CAGZH0-dz9y5=vH7PQr8VRy15i1WsuAxKjPPpmx8-1UqCaJnRxg@mail.gmail.com>
 <20110913082511.3c34dec9@notabene.brown>
 <CAGZH0-fEU+NTdAF1AWcU6SnyBPYgd51zjizaiZT_toV=k4EDFg@mail.gmail.com>
 <20110913084419.380babcc@notabene.brown>
 <CAGZH0-fRTkKOL8ofLbChmNH3fuiYwHkC0LAv1-VVyb22O7UnwA@mail.gmail.com>
 <20110913093850.606efa70@notabene.brown>
 <CAGZH0-f+e80W36VMZMHrTakTxUHO2nppO9xHSTmHh6QV_Mo2Fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; DelSp=Yes
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGZH0-f+e80W36VMZMHrTakTxUHO2nppO9xHSTmHh6QV_Mo2Fg@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Andriano <chief000@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Zitat von Andriano <chief000@gmail.com>:

> On Tue, Sep 13, 2011 at 5:38 PM, NeilBrown <neilb@suse.de> wrote:
>> On Tue, 13 Sep 2011 17:05:06 +1000 Andriano <chief000@gmail.com> wrote:
>>
>>> On Tue, Sep 13, 2011 at 4:44 PM, NeilBrown <neilb@suse.de> wrote:
>>> > On Tue, 13 Sep 2011 16:33:36 +1000 Andriano <chief000@gmail.com> wrote:
>>> >
>>> >> >
>>> >> >> Hello Linux-RAID mailing list,
>>> >> >>
>>> >> >> Linux 3.0.4-2-desktop #1 SMP PREEMPT Wed Aug 31 09:30:44 UTC 2011
>>> >> >> (a432f18) x86_64 x86_64 x86_64 GNU/Linux
>>> >> >> Gigabyte EP35C-DS3 motherboard with 8 SATA ports + SuperMicro
>>> >> >> AOC-SASLP-MV8 based on Marvel 6480, firmware updated to 3.1.0.21
>>> >> >> running mdadm 3.2.2, single array consists of 10 2T disks, 8 of them
>>> >> >> connected to the HBA, 2 - motherboard ports
>>> >> >>
>>> >> >> I had some issues with one of the onboard connected disks,  
>>> so tried to
>>> >> >> plug it to different ports, just to eliminate possibly faulty port.
>>> >> >> After reboot, suddenly other drives got kicked out from the array.
>>> >> >> Re-assembling them gives weird errors.
>>> >> >>
> Apparently you're right
> blockdev --getsz /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg
> /dev/sdh /dev/sdi /dev/sdj /dev/sdk
> 3907027055
> 3907027055
> 3907029168
> 3907029168
> 3907029168
> 3907029168
> 3907027055
> 3907029168
> 3907029168
> 3907029168
>
> sdb, sdc and sdh - are smaller and they are problem disks
>
> So what would be a solution to fix this issue?

The solution seems obvious:
Plug them (or at least one of them) back into the original ports so  
that they regain their original size.
Then you can try and shrink your filesystem/logical volumes and then  
the array, then check everything is working (do a raid check too).
Then you can move one one the disks to a good port, zero the metadata  
on it and add it back to regain full redundancy. Once done, move the  
next...
