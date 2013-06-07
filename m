From: Steve Bergman <sbergman27@gmail.com>
Subject: Re: Is this expected RAID10 performance?
Date: Fri, 7 Jun 2013 07:59:59 -0500
Message-ID: <CAO9HMNHdyTg-LrZB0Mtyp16Zhstw_QETS5C3mtDsfgveWwe1_g@mail.gmail.com>
References: <CAO9HMNH4eFyshhhohw0wQ13j98BTRELTiWF9uDLp3vmFsOEfwQ@mail.gmail.com>
	<CAAMCDefb7TFXDOD7=aK-FjHVCQXMdiQKdz=CFJT4+q9rKR3KGA@mail.gmail.com>
	<CAGqvA+svdBvWTbwnzQjoHWQz6n0iEaAZzmu-EqKqdPx-AK0Zkg@mail.gmail.com>
	<CAO9HMNE3F-ZN0fQmHW7yz2JLRFaUqSYSaVpZe3KaXuaLMojV8w@mail.gmail.com>
	<51B1D48C.7050006@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51B1D48C.7050006@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

66MHz/32bit matches the lshw output I posted. And the machine does
have 1 PCI-X slot. So I imagine they're using the same interface for
the onboard SATA controllers. Whatever it has, each of 2 pairs of SATA
ports seems to be on one of them.

No offense intended, but reliability is more important than
performance in this scenario. And although the machine is on a good
UPS with apcupsd installed, it's not sitting in a data center, but in
an office area. And I've found XFS to have pretty bad behavior on
unlcean shutdowns. I'm used to the rock-solid reliability of ext3 in
ordered mode, so even ext4 seems a bit reckless to me. I did compare
XFS when it was configured to RAID1, and it was slightly better. Most
of what this machine will be doing is single-threaded. But XFS is not
an option for testing on an LV right now since the whole VG is sitting
on an RAID10 at the default 512k chunk size, and XFS doesn't support
larger than 256k chunks while maintaining optimal su and sw. I may
grab the machine and bring it back to my office so that I can work
with it "in person" over the weekend. It's currently remote to me.

-Steve
