From: Neil Brown <neilb@suse.de>
Subject: Re: metadata update
Date: Mon, 21 Dec 2009 09:11:47 +1100
Message-ID: <20091221091147.743fd728@notabene.brown>
References: <4B2CC25F.1090308@1und1.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B2CC25F.1090308@1und1.de>
Sender: linux-raid-owner@vger.kernel.org
To: Jakob-Tobias Winter <jakob-tobias.winter@1und1.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 19 Dec 2009 13:09:03 +0100
Jakob-Tobias Winter <jakob-tobias.winter@1und1.de> wrote:

> Hey there,
> 
> my raidsets are still using 0.91 and I might want to upgrade to the
> newer metadata. - The system is running kernel 2.6.32.1 x86_64 with
> mdadm v3.0.3.

0.91 is only used during a reshape - e.g. adding a device to a RAID5.
Once the reshape completes it will revert to 0.90.

> 
> Are there benefits to upgrading or should I stay with my current
> metadata version?

You cannot upgrade the metadata on an array.  You can only create a new array
with new metadata.
If you create a new array with current mdadm you will get v1.1 metadata.

If what you have works, there is no need to change it.

NeilBrown

