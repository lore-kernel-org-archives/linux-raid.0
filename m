From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] Use new sb type
Date: Fri, 8 Feb 2008 01:23:15 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801292347430.14907@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801281818430.1185@fbirervta.pbzchgretzou.qr>
 <479E1C95.1040008@dgreaves.com> <479FB1FB.6040500@tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479FB1FB.6040500@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: David Greaves <david@dgreaves.com>, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jan 29 2008 18:08, Bill Davidsen wrote:

>> IIRC there was a discussion a while back on renaming mdadm options
>> (google "Time to deprecate old RAID formats?") and the superblocks
>> to emphasise the location and data structure. Would it be good to
>> introduce the new names at the same time as changing the default
>> format/on-disk-location?
>
> Yes, I suggested some layout names, as did a few other people, and
> a few changes to separate metadata type and position were
> discussed. BUT, changing the default layout, no matter how "better"
> it seems, is trumped by "breaks existing setups and user practice."

Layout names are a different matter from what the default sb type should 
be.
