From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Usefulness of RAID 4
Date: Wed, 20 Feb 2013 12:24:16 -0700
Message-ID: <2ED12907-9ECB-4FFE-9765-1048668D91A0@colorremedies.com>
References: <D5F9E1BC-26C0-4585-9DD5-0C19570FBA17@colorremedies.com> <5123FF85.50105@hardwarefreak.com> <CBC74AA5-EA3C-4B35-B43E-9C1F12C864CE@colorremedies.com> <512481BD.1010903@hesbynett.no>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <512481BD.1010903@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: stan@hardwarefreak.com, "linux-raid@vger.kernel.org list" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Feb 20, 2013, at 12:56 AM, David Brown <david.brown@hesbynett.no> wrote:
> 
> Raid 4 has no good uses as a final format for a raid layout - raid 5 is
> better in every way.
> 
> However, raid 4 /is/ useful as an intermediary format for md raid,
> during operations like re-shaping and re-sizing.

Understood.

> Fedora is a distribution aimed at experienced users and tinkerers, so it
> tends to include all sorts of weird opinions in the installer - simply
> because Linux supports them.  It will probably also have an option to
> use the minix file system for your root file system.

It doesn't. The Fedora 18 installer is ground up new. There are all sorts of things that linux supports that the installer won't let you do. Anyway, I think the offering of RAID 4 unnecessarily complicates the new plain language UI, because it has to be distinguished from RAID 5 without calling them RAID 4 and RAID 5. That makes the UI much more challenging, and just for the nine people on the whole rock who might use this as a final format.

> I don't see how.  The SSD dedicated to parity must have the same
> capacity as the HDDs.  The largest non PCIe monster SDDs are right at
> 1TB and the cheapest of those is ~$1000.

I was thinking of smaller drives, like 500GB. Maybe 3-4 data HDDs, and 1 SSD. That'd be pretty cheap. But even still, I think the number of people who'd want to do this could be counted on one hand.



Chris Murphy