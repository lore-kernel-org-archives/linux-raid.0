From: Emmanuel Noobadmin <centos.admin@gmail.com>
Subject: Re: metadata versions: 0.90 vs 1.2
Date: Thu, 14 Jun 2012 01:29:30 +0800
Message-ID: <CAAYorBL5Xi_hVdkQFQqU_jYpSzgfnddVV1g7gyoCc3Kn0SiqEw@mail.gmail.com>
References: <1339563343.41566.YahooMailClassic@web190003.mail.sg3.yahoo.com>
	<alpine.DEB.2.00.1206130744440.25054@uplift.swm.pp.se>
	<CAAYorBKkvGacKKDVqs+F3HP6q8DUANFB4HcM5mNqfgqm-qnh_A@mail.gmail.com>
	<4FD8AF18.70401@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FD8AF18.70401@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, plug bert <plugbert@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/13/12, Phil Turmel <philip@turmel.org> wrote:
> On 06/13/2012 10:46 AM, Emmanuel Noobadmin wrote:
>> On 6/13/12, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
>>> If you want to be able to mount the individual RAID1 members but still
>>> use
>>> the newer version superblock, you need to use version 1.0 (stored at the
>>> end of the device/partition).
>>>
>>> I'd recommend to go with 1.0 instead of 0.90.
>>
>> Would metadata 1.0 boot with older grub? Since that's often why we're
>> using 0.9.
>
> It does.  It's what I use myself.

Thank you very much for that confirmation :)
