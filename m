From: Martin Wilck <mwilck@arcor.de>
Subject: DDF RAID 10 with md?
Date: Mon, 10 Dec 2012 21:23:35 +0100
Message-ID: <50C644C7.3060502@arcor.de>
References: <1354919941-12070-1-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1354919941-12070-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

I wrote

> PS: These patches fix RAID1. I noticed that there are more severe problems 
> when I create a RAID 10 in the BIOS. I'll try to fix that, too.

I've digged a little further and from what I understand, the RAID10
concept in DDF ("DDF_2SPANNED" is what by BIOS creates) is incompatible
with that of MD RAID.

So I guess there is no easy solution, short of implementing an entirely
new RAID mapping in md.

Another possibility might be to setup the "spanning" block map of the
DDF secondary RAID using dm. There would be some minor problems to
overcome first though:

 1 - Currently, if I configure RAID10 in the BIOS, md will only
configure the first of the two basic RAID1 arrays.
 2 - When md is stopped and writes back the meta data, it will change
the seq number only on the first basic arrays, thus corrupting the meta
data of the RAID set.

I'd suggest that md should bail out if a DDF secondary RAID level is
encountered, knowing that this mapping is currently unsupported. That'd
be certainly better than corrupting the metadata.

Regards
Martin



