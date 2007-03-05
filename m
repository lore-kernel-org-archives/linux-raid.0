From: Neil Brown <neilb@suse.de>
Subject: Re: no journaling and loops on softraid?
Date: Tue, 6 Mar 2007 10:32:51 +1100
Message-ID: <17900.43171.838082.323657@notabene.brown>
References: <200703052355.15363.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dexter Filmore on Monday March 5
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday March 5, Dexter.Filmore@gmx.de wrote:
> http://gentoo-wiki.com/HOWTO_Gentoo_Install_on_Software_RAID#Data_Scrubbing
> 
> "Warning: Be aware that the combination of RAID5 and loop-devices will most 
> likely cause severe filesystem damage, especially when using ext3 and 
> ReiserFS. Some users suggest that XFS is not affected by this, but this has 
> not been entirely confirmed. See kernel bug 6242 for updates on this bug.
> 
> Note: There are also reports that Journaled Filesystems are problematic on all 
> Software-RAID levels. No kernel bugs have been submitted regarding this bug 
> as of yet. A number of the reports involve using cryptoloops which are known 
> to cause corruption. See http://forums.gentoo.org/viewtopic-t-412467.html for 
> more information. This thread should be taken with a grain of salt."
> 
> Can someone shed some light on this? I have XFS on my raid and *had* problems 
> when unpacking large archives with many small files.
> 

Bugs that get mentioned on wiki's but never reported to maintainers
are unlikely to get fixed......

Back in 2.2 days ext3 over md/raid had problems if the raid was
rebuilding, but that was fixed in 2.4.

More recently there was an incompatibility between raid5 and dm-crypt
that could cause corruption, but that has been fixed on both sides
(there are two ways to report errors for a block-device request.
raid5 was setting only one of them and dm-crypt was listening only to
the other - there were "I don't have resources at the moment" errors
for read-ahead requests).


If you have problems with XFS on raid, I suggest you report it to the
XFS and RAID mailing lists - see the MAINTAINERS file for both.

NeilBrown
