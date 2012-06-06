From: Ole Tange <ole@tange.dk>
Subject: Re: Software RAID checksum performance on 24 disks not even close to
 kernel reported
Date: Wed, 6 Jun 2012 21:19:56 +0200
Message-ID: <CA+4vN7x6R3+oKUg_tXJXvcZ1CuRwcSxn8Q-+Gc0ok36jg4xp7A@mail.gmail.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
 <CA+4vN7xQgecd95FO6gYVLMuPDKXbfZfzuXS1dzHd+e-otrPxwg@mail.gmail.com> <CAA9_cmcANJjd8gfagWw5vENABh+n13xFnk7OF-ZzxecfxU719w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmcANJjd8gfagWw5vENABh+n13xFnk7OF-ZzxecfxU719w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 6, 2012 at 6:09 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Wed, Jun 6, 2012 at 7:11 AM, Ole Tange <ole@tange.dk> wrote:
>> On Tue, Jun 5, 2012 at 1:14 AM, Ole Tange <ole@tange.dk> wrote:
>>
>>> But I cannot explain why even the best performance (4600 MB/11s = 420
>>> MB/s) is not even close to the checksum performance reported by the
>>> kernel at boot (6196 MB/s):
>>
>> From the friendly people on the mailing list the answer can be summarized as:
:
>> In other words: What you see is normal, and it is not out of the
>> ordinary to see md0_raid6 use 100% CPU time on a single core when
>> using a 24 disk RAID6. Work is underway to spread the load to multiple
>> cores using the experimental kernel parameter
>> CONFIG_MULTICORE_RAID456.
>
> Don't use CONFIG_MULTICORE_RAID456, we need a different approach.

Here you disagree with Brad Campbell and Igor M Podlesny. Can you
elaborate why you do not think I should use CONFIG_MULTICORE_RAID456
and why you do not think that approach will work?


/Ole
