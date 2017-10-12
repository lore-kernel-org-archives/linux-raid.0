From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [mdadm PATCH] mdopen: call "modprobe md_mod" if it might be
 needed.
Date: Thu, 12 Oct 2017 10:55:14 +0100
Message-ID: <59DF3C02.6080104@youngman.org.uk>
References: <87y3p372b0.fsf@notabene.neil.brown.name>
 <cba5f77f-d6de-7a6b-35b0-70b7c56eb3f7@suse.com>
 <87bmleyd0y.fsf@notabene.neil.brown.name>
 <375cf2fb-bd4b-abef-5012-1361c224d254@suse.com>
 <87h8v5nsa6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87h8v5nsa6.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Zhilong Liu <zlliu@suse.com>, "jes.sorensen@gmail.com" <jes.sorensen@gmail.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/10/17 01:06, NeilBrown wrote:
> Yes - exactly like that except that I wouldn't wrap the long string.
> Lines longer than 80 chars are good to avoid, but breaking string
> literals is worse than having long lines.  e.g. it makes searching for
> the string hard.

Isn't that the kernel standard anyway?

"Wrap at 80 chars *unless* that would mean breaking a string literal".

Iirc an lwn story or something about how all subsystems tended to follow
this rule except one, so they were going to try and standardise across
everything.

Cheers,
Wol
