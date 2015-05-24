From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Fwd: Installing Linux directly onto RAID6 Array...........
Date: Sun, 24 May 2015 13:41:13 +0100
Message-ID: <5561C6E9.3060706@youngman.org.uk>
References: <CAOS+5GFwGJouUfZ_RWhtRVXw7wnoP1Ry4doHTJmkruFoccmqRg@mail.gmail.com> <555294A0.6040703@websitemanagers.com.au> <CAOS+5GEP6+7OAHkqQjeyGHAB5u-_-Vq2JWGpcOemYHdCjmR5Lg@mail.gmail.com> <CAOS+5GHKwQRPfNAw0EpSjjDUt=9PmjjrkUg+dhGxFS+uOWWVug@mail.gmail.com> <alpine.DEB.2.02.1505241032210.9487@uplift.swm.pp.se> <5561B237.4040709@youngman.org.uk> <5561BCA4.4060904@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5561BCA4.4060904@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@fnarfbargle.com>, Mikael Abrahamsson <swmike@swm.pp.se>, Another Sillyname <anothersname@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24/05/15 12:57, Brad Campbell wrote:
> On 24/05/15 19:12, Wols Lists wrote:
> 
>> Don't bother raid'ing swap at all! If you set the priority equal on all
>> the swaps, linux will do a raid 0 for you and, frankly, what's the point
>> of doing raid on your swap partition? You really shouldn't (in normal
>> usage) be using swap at all.
> 
> When you develop a bad block in one of your non-RAID swap partitions and
> you spend a week trying to figure out why processes randomly die for no
> apparent reason you'll reconsider that attitude.
> 
aiui raid won't help you at all here, will it?

Firstly, if you get write failures, the hard drive should swap the
block, or the write layer should swap it. Nothing to do with raid
whatsoever.

And if you get read errors, well, aiui, raid won't help here either -
especially with mirrored raid, you just get a read failure. Raid does
NOT give you error recovery unless the drive physically fails, and if
it's a bad block it gets fixed at the disk or disk driver level - well
below the raid driver.

Cheers,
Wol
