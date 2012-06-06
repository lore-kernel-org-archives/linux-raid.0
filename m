From: Ole Tange <ole@tange.dk>
Subject: Re: Software RAID checksum performance on 24 disks not even close to
 kernel reported
Date: Wed, 6 Jun 2012 21:26:34 +0200
Message-ID: <CA+4vN7xjqbd-o2k4u3SM90xQ3-zHp+ei3H9Mr6TxAD__rYnoQQ@mail.gmail.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
 <CA+4vN7xQgecd95FO6gYVLMuPDKXbfZfzuXS1dzHd+e-otrPxwg@mail.gmail.com>
 <CAA9_cmcANJjd8gfagWw5vENABh+n13xFnk7OF-ZzxecfxU719w@mail.gmail.com>
 <CA+4vN7x6R3+oKUg_tXJXvcZ1CuRwcSxn8Q-+Gc0ok36jg4xp7A@mail.gmail.com> <CABE8wws8u_bOwfv_j1gJicFbrwUQ4M_BFc7bMV2_+fJSkhL=mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABE8wws8u_bOwfv_j1gJicFbrwUQ4M_BFc7bMV2_+fJSkhL=mg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 6, 2012 at 9:24 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Wed, Jun 6, 2012 at 12:19 PM, Ole Tange <ole@tange.dk> wrote:
>> On Wed, Jun 6, 2012 at 6:09 PM, Dan Williams <dan.j.williams@intel.com> wrote:
:
>>> Don't use CONFIG_MULTICORE_RAID456, we need a different approach.
>>
>> Here you disagree with Brad Campbell and Igor M Podlesny. Can you
>> elaborate why you do not think I should use CONFIG_MULTICORE_RAID456
>> and why you do not think that approach will work?
>
> Because I wrote the code and it doesn't work the way I want it to [...]

It can hardly be more authoritative than this :-)


/Ole
