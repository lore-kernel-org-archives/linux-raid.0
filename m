From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH v2 00/12] Partial Parity Log for MD RAID 5
Date: Wed, 7 Dec 2016 15:36:01 +0100
Message-ID: <84c59771-48b7-da47-3497-c82c6c6939c9@intel.com>
References: <20161205153113.7268-1-artur.paszkiewicz@intel.com>
 <87fum04m0m.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87fum04m0m.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/07/2016 01:32 AM, NeilBrown wrote:
> 
> I would expect to see as description of what a PPL actually is and how
> it works here... but there is none.
> 
> The change-log for patch 06 has a tiny bit more information which is
> just enough to be able to start trying to understand the code, but it
> isn't much.
> And none of this description gets into the code, or into the
> Documentation/.  This makes it hard to review and hard to maintain.
> 
> Remember: if you want people to review you code, it is in your interest
> to make it easy.  That means give lots of details.

Hi Neil,

Thank you for taking the time to look at this and for your feedback. I
didn't try to make it hard to review... Sometimes it's easy to forget
how non-obvious things are after looking at them for too long :) I will
improve the descriptions and address the issues that you found in the
next version of the patches.

Thanks,
Artur
