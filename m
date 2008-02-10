From: David Greaves <david@dgreaves.com>
Subject: Re: [PATCH] Use new sb type
Date: Sun, 10 Feb 2008 10:34:02 +0000
Message-ID: <47AED31A.3070704@dgreaves.com>
References: <Pine.LNX.4.64.0801281818430.1185@fbirervta.pbzchgretzou.qr> <479E1C95.1040008@dgreaves.com> <479FB1FB.6040500@tmr.com> <Pine.LNX.4.64.0801292347430.14907@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0801292347430.14907@fbirervta.pbzchgretzou.qr>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Bill Davidsen <davidsen@tmr.com>, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jan Engelhardt wrote:
> On Jan 29 2008 18:08, Bill Davidsen wrote:
> 
>>> IIRC there was a discussion a while back on renaming mdadm options
>>> (google "Time to deprecate old RAID formats?") and the superblocks
>>> to emphasise the location and data structure. Would it be good to
>>> introduce the new names at the same time as changing the default
>>> format/on-disk-location?
>> Yes, I suggested some layout names, as did a few other people, and
>> a few changes to separate metadata type and position were
>> discussed. BUT, changing the default layout, no matter how "better"
>> it seems, is trumped by "breaks existing setups and user practice."
> 
> Layout names are a different matter from what the default sb type should 
> be.
Indeed they are. Or rather should be.

However the current default sb includes a layout element. If the default sb is
changed then it seems like an opportunity to detach the data format from the
on-disk location.

David

