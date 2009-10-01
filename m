From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: BUG: soft lockup in [md4_raid5:21137]
Date: Thu, 1 Oct 2009 13:41:49 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0910011334100.6401@praktifix.dwd.de>
References: <Pine.LNX.4.64.0909181255380.21814@diagnostix.dwd.de>
 <e9c3a7c20909181055u5d66086chd199f48453c476d8@mail.gmail.com>
 <Pine.LNX.4.64.0909290914330.24558@praktifix.dwd.de>
 <e9c3a7c20909291806o6985259doc911012dd88dc76c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="646811178-1629444445-1254404509=:6401"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20909291806o6985259doc911012dd88dc76c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--646811178-1629444445-1254404509=:6401
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 29 Sep 2009, Dan Williams wrote:

> On Tue, Sep 29, 2009 at 2:24 AM, Holger Kiehl <Holger.Kiehl@dwd.de> wrote:
>> On Fri, 18 Sep 2009, Dan Williams wrote:
>> __async_schedule+0x10e/0x130
>>   Sep 29 09:02:15 apollo kernel: [<ffffffff8108ad7e>] ?
>> async_schedule_domain+0x1c/0x32
>>   Sep 29 09:02:15 apollo kernel: [<ffffffff81379852>] ? raid5d+0x3f8/0x44c
>>   Sep 29 09:02:15 apollo kernel: [<ffffffff81446b68>] ?
>> _spin_unlock_irqrestore+0x21/0x3c
>>   Sep 29 09:02:15 apollo kernel: [<ffffffff81383db1>] ?
>> md_thread+0x100/0x132
>>   Sep 29 09:02:15 apollo kernel: [<ffffffff81084113>] ?
>> autoremove_wake_function+0x0/0x5a
>>   Sep 29 09:02:15 apollo kernel: [<ffffffff81383cb1>] ? md_thread+0x0/0x132
>>   Sep 29 09:02:15 apollo kernel: [<ffffffff81083d04>] ? kthread+0x89/0x91
>>   Sep 29 09:02:15 apollo kernel: [<ffffffff8102f36a>] ? child_rip+0xa/0x20
>>   Sep 29 09:02:15 apollo kernel: [<ffffffff81083c7b>] ? kthread+0x0/0x91
>>   Sep 29 09:02:15 apollo kernel: [<ffffffff8102f360>] ? child_rip+0x0/0x20
>>
>> The system also becomes very unresponsive. How can I fix this since it
>> looks your patch does not apply to 2.6.32-rc1. Or is this another bug,
>> since I have enabled CONFIG_MULTICORE_RAID456.
>
> This is a new issue with the (experimental) multicore implementation.
> If you turn that off then you will be using the same single threaded
> flow as 2.6.31.  If you want to play with the multicore option a bit
> more the patch below should squelch the softlockup.  However, I
> suspect we will need our own md specific thread pool because the
> current implementation spends too much effort bouncing stripes between
> the async thread pool and raid5d.
>
Thanks, for the patch. Then these softlockups go away, but performance
is terrible (factor 6 slower with CONFIG_MULTICORE_RAID456).

Holger
--646811178-1629444445-1254404509=:6401--
