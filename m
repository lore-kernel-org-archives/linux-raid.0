From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH] md: improve io stats accounting
Date: Tue, 2 Jun 2020 13:32:54 -0400
Message-ID: <24278.36166.418871.60864@quad.stoffel.home>
References: <20200601161256.27718-1-artur.paszkiewicz@intel.com>
        <CAPhsuW4fjc4NgFGQUPuAKSvtWvtzyPor876anj64NF=nqaPo5g@mail.gmail.com>
        <26d5f5c7-9a20-e7f9-617f-0353c5d9bb2e@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <26d5f5c7-9a20-e7f9-617f-0353c5d9bb2e@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Artur" == Artur Paszkiewicz <artur.paszkiewicz@intel.com> writes:

Artur> On 6/2/20 8:48 AM, Song Liu wrote:
>>> +               clone = bio_clone_fast(bio, GFP_NOIO, &mddev->md_io_bs);
>> 
>> Handle clone == NULL?

Artur> I think this should never fail - bio_alloc_bioset() guarantees that. It
Artur> is used in a similar manner in raid1 and raid10. How about
Artur> BUG_ON(clone == NULL)?

No, use WARN_ON() instead, why would you bug the entire system for
just one logical device throwing an error?  
