From: Brad Campbell <brad@fnarfbargle.com>
Subject: Re: Fwd: Installing Linux directly onto RAID6 Array...........
Date: Sun, 24 May 2015 19:57:24 +0800
Message-ID: <5561BCA4.4060904@fnarfbargle.com>
References: <CAOS+5GFwGJouUfZ_RWhtRVXw7wnoP1Ry4doHTJmkruFoccmqRg@mail.gmail.com> <555294A0.6040703@websitemanagers.com.au> <CAOS+5GEP6+7OAHkqQjeyGHAB5u-_-Vq2JWGpcOemYHdCjmR5Lg@mail.gmail.com> <CAOS+5GHKwQRPfNAw0EpSjjDUt=9PmjjrkUg+dhGxFS+uOWWVug@mail.gmail.com> <alpine.DEB.2.02.1505241032210.9487@uplift.swm.pp.se> <5561B237.4040709@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5561B237.4040709@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Mikael Abrahamsson <swmike@swm.pp.se>, Another Sillyname <anothersname@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24/05/15 19:12, Wols Lists wrote:

> Don't bother raid'ing swap at all! If you set the priority equal on all
> the swaps, linux will do a raid 0 for you and, frankly, what's the point
> of doing raid on your swap partition? You really shouldn't (in normal
> usage) be using swap at all.

When you develop a bad block in one of your non-RAID swap partitions and 
you spend a week trying to figure out why processes randomly die for no 
apparent reason you'll reconsider that attitude.

Brad
-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.
