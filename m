From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Proper partition type for components with V1.x superblocks?
Date: Mon, 07 Jul 2008 10:33:08 -0700
Message-ID: <48725354.1070900@zytor.com>
References: <484F9A3E.7020709@rabbit.us>	 <18512.25940.653867.623185@notabene.brown> <486BFB03.7060100@zytor.com>	 <1215062276.14196.6.camel@firewall.xsintricity.com>	 <18545.35548.800516.532854@notabene.brown> <1215439360.14196.17.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1215439360.14196.17.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Neil Brown <neilb@suse.de>, Peter Rabbitson <rabbit+list@rabbit.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford wrote:
> 
> The same is true of version 0.90.0 superblocks.  It was probably a bad
> decision to make raid1 arrays mountable as normal filesystems in
> hindsight, but it did ease a lot of things at the time (like booting
> from a raid1 device using lilo, the only boot loader back in the day).
> In any case, given the number of existing 0.90.0 and 1.0 superblock
> systems out there, any install code that doesn't look for them is just
> flat deficient.  So I can see your point from the stand point of wanting
> to correct a past mistake, but the flip side of the coin is that even if
> you do such a thing, any installer will still be buggy and broken for
> many years to come if it doesn't check for raid superblocks before
> treating a filesystem like a normal filesystem.
> 

It certainly helps bootloaders wanting to boot off RAID-1.  1.2 
superblocks, at the beginning but with an offset, are fine for that 
purpose too, but requires special handling.

	-hpa
