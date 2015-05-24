From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Fwd: Installing Linux directly onto RAID6 Array...........
Date: Sun, 24 May 2015 12:12:55 +0100
Message-ID: <5561B237.4040709@youngman.org.uk>
References: <CAOS+5GFwGJouUfZ_RWhtRVXw7wnoP1Ry4doHTJmkruFoccmqRg@mail.gmail.com> <555294A0.6040703@websitemanagers.com.au> <CAOS+5GEP6+7OAHkqQjeyGHAB5u-_-Vq2JWGpcOemYHdCjmR5Lg@mail.gmail.com> <CAOS+5GHKwQRPfNAw0EpSjjDUt=9PmjjrkUg+dhGxFS+uOWWVug@mail.gmail.com> <alpine.DEB.2.02.1505241032210.9487@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1505241032210.9487@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>, Another Sillyname <anothersname@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24/05/15 09:36, Mikael Abrahamsson wrote:
> You don't want to run MD on the entire drive in this case, you most
> likely want to create multiple RAID1 and RAID6 mirrors. RAID1 your boot,
> root and swap, then run RAID6 on your home partition. Use use superblock
> type that creates the superblock at the end for the RAID1 partitions.

Don't bother raid'ing swap at all! If you set the priority equal on all
the swaps, linux will do a raid 0 for you and, frankly, what's the point
of doing raid on your swap partition? You really shouldn't (in normal
usage) be using swap at all.

NB - with swap, I always create one swap partition per drive, and make
it twice the maximum ram the mobo will take. I have still not had
anybody come back to me with any evidence that the swap algorithm
doesn't work better with that amount of swap, and the belief that "twice
ram no longer applies" was PROVEN to be an urban myth with linux 2.4
(yes, that was a long time ago, but as I said no-one has ever given me
any evidence that things have changed since).

I'm a bit unusual, running gentoo I need large chunks of temporary space
so I have a couple of huge tmpfs drives.

Cheers,
Wol
