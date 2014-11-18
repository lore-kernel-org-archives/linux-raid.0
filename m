From: Phil Turmel <philip@turmel.org>
Subject: Re: Re-assemble RAID6 from SW to HW RAID
Date: Tue, 18 Nov 2014 08:34:15 -0500
Message-ID: <546B4AD7.3060408@turmel.org>
References: <CADNH=7H=ge5P9rm5hRjO3GhOFF-jAqFZrNMjNeEGVDwe=BOARw@mail.gmail.com> <CADNH=7HeKemJvN5gNtxznZWArqe2ibBaMTMJqdfsKyYAr4EcKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7HeKemJvN5gNtxznZWArqe2ibBaMTMJqdfsKyYAr4EcKw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Mathias,

On 11/17/2014 05:51 PM, Mathias Bur=C3=A9n wrote:
> On 17 November 2014 22:14, Mathias Bur=C3=A9n <mathias.buren@gmail.co=
m> wrote:
>> Hi all,
>>
>> I've a 6 disk RAID6 array, with 1 missing disk. I moved 2 of the HDD=
s
>> from the on-board SATA controller to a LSI MegaRAID controller where=
 I
>> created them as individual RAID0's. The data in the array isn't
>> important, but it'd be nice if I can reassemble it.

[trim /]

> It appears to have a superblock?

Take a close look at your new device sizes.  The hardware raid almost
certainly shortened the devices to fit its own metadata on the end.  MD
v1.2 metadata contains enough info to reject the SB if the used space
doesn't fit the device.

You should look if your MegaRAID has a 'JBOD' mode for the drives.

Regards,

Phil

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
