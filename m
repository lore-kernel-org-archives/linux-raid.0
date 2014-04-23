From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: raid6 - data integrity issue - data mis-compare on rebuilding
 RAID 6 - with 100 Mb resync speed.
Date: Wed, 23 Apr 2014 10:02:00 -0700
Message-ID: <CAPcyv4gg6N_FYOZmooXTUYT22AOuBmqFuin_TiKqn8A9DOCnqw@mail.gmail.com>
References: <13688C12F44C7C428726663F950CA2530972DC8C@venus.in.megatrends.com>
	<20140423170755.1aa92ba6@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140423170755.1aa92ba6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Manibalan P <pmanibalan@amiindia.co.in>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Apr 23, 2014 at 12:07 AM, NeilBrown <neilb@suse.de> wrote:
> On Fri, 11 Apr 2014 17:41:12 +0530 "Manibalan P" <pmanibalan@amiindia.co.in>
> wrote:
>
>> Hi Neil,
>>
>> Also, I found the data corruption issue on RHEL 6.5.
>>
>> For your kind attention, I up-ported the md code [raid5.c + raid5.h]
>> from FC11 kernel to CentOS 6.4, and there is no mis-compare with the
>> up-ported code.
>
> This narrows it down to between 2.6.29 and 2.6.32 - is that correct?
>
> So it is probably the change to RAID6 to support async parity calculations.
>
> Looking at the code always makes my head spin.
>
> Dan : have you any ideas?
>
> It seems that writing to a double-degraded RAID6 while it is recovering to
> a space can trigger data corruption.
>
> 2.6.29 works
> 2.6.32 doesn't
> 3.8.0 still doesn't.
>
> I suspect async parity calculations.

I'll take a look.  I've had cleanups of that code on my backlog for "a
while now (TM)".
