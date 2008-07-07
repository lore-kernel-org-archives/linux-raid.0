From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Proper partition type for components with V1.x superblocks?
Date: Mon, 07 Jul 2008 10:38:52 -0700
Message-ID: <487254AC.7040106@zytor.com>
References: <484F9A3E.7020709@rabbit.us>	<18512.25940.653867.623185@notabene.brown>	<486BFB03.7060100@zytor.com>	<1215062276.14196.6.camel@firewall.xsintricity.com> <18545.35548.800516.532854@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18545.35548.800516.532854@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, Peter Rabbitson <rabbit+list@rabbit.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> 
> But if you use 1.0, then some well-meaning install program might mount
> one drive from a raid1 as a filesystem, write to it, and get your RAID
> all out of sync.
> 

One more thing on this: this is actually fine as long as the RAID code 
detects the out-of-syncness.  This can't be foolproof, of course, but 
for virtually all filesystems there is *something* in the first megabyte 
or so (usually within the first 128K) that is touched by almost every 
write -- the superblock, or its equivalent.

If the RAID code did a sanity check on the first megabyte, it would 
catch the vast majority of all unintentional desynchronization events.

	-hpa
