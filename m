From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: mismatch_cnt, random bitflips, silent corruption(?), mdadm/sw
 raid[156]
Date: Wed, 31 Dec 2008 12:39:16 +0100
Message-ID: <slrnglmmf7.agm.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <alpine.DEB.1.10.0812250435260.12329@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756596AbYLaLjl@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, smartmontools-support@lists.sourceforge.net
List-Id: linux-raid.ids

Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> Options/alternatives for maintaining data integrity?
> 3. Keep an md5sum for each file on the filesystem and run daily checks?

I'm doing this since about 6 years now with all of my files and I never
experienced any silent corruption.
I also regularly experience MD mismatch_cnt effects on RAID1 with ext2/3
filesystems with heavy file removal/creation load (even before MD
implemented its self-check features - I cmp-ed and corrected them
manually before) and they all seem to have been related to metadata,
i.e. inodes.


regards
   Mario
-- 
[mod_nessus for iauth]
<delta> "scanning your system...found depreciated OS...found
        hole...installing new OS...please reboot and reconnect now"
