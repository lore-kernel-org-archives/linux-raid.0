From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH v2 00/12] Partial Parity Log for MD RAID 5
Date: Tue, 13 Dec 2016 10:25:04 -0500
Message-ID: <wrfjy3zjq2b3.fsf@redhat.com>
References: <20161205153113.7268-1-artur.paszkiewicz@intel.com>
        <87fum04m0m.fsf@notabene.neil.brown.name>
        <84c59771-48b7-da47-3497-c82c6c6939c9@intel.com>
        <20161207170906.sthdxswufwk5fqhn@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161207170906.sthdxswufwk5fqhn@kernel.org> (Shaohua Li's
        message of "Wed, 7 Dec 2016 09:09:06 -0800")
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Shaohua Li <shli@kernel.org> writes:
> On Wed, Dec 07, 2016 at 03:36:01PM +0100, Artur Paszkiewicz wrote:
>> On 12/07/2016 01:32 AM, NeilBrown wrote:
>> > 
>> > I would expect to see as description of what a PPL actually is and how
>> > it works here... but there is none.
>> > 
>> > The change-log for patch 06 has a tiny bit more information which is
>> > just enough to be able to start trying to understand the code, but it
>> > isn't much.
>> > And none of this description gets into the code, or into the
>> > Documentation/.  This makes it hard to review and hard to maintain.
>> > 
>> > Remember: if you want people to review you code, it is in your interest
>> > to make it easy.  That means give lots of details.
>> 
>> Hi Neil,
>> 
>> Thank you for taking the time to look at this and for your feedback. I
>> didn't try to make it hard to review... Sometimes it's easy to forget
>> how non-obvious things are after looking at them for too long :) I will
>> improve the descriptions and address the issues that you found in the
>> next version of the patches.
>
> Havn't looked at the patches yet, being busy recently, sorry! When you repost
> these, I'd like to know why we need another log for raid5 considering we
> already had one to fix similar issue. What's the good/bad side of this new log?
> There is such feature in Intel RSTe doesn't sound like a technical reason we
> should support this.

Shaohua,

Any further thought on these patches? I am considering doing a release
of mdadm early in the new year. it would be nice to include these
patches if the feature is going in.

As for supporting it, if IMSM supports it and it is used in the field,
then it seems legitimate for Linux to support it too. Just like we
support so many other obscure pieces of hardware :)

Cheers,
Jes
