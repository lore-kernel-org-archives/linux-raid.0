From: Nick Andrew <nick@nick-andrew.net>
Subject: Re: Sharing disks amoung multiple software RAIDs
Date: Fri, 2 May 2008 11:23:37 +1000
Message-ID: <20080502012337.GD13463@tull.net>
References: <771640.4981.qm@web50209.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933964AbYEBBYF@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <771640.4981.qm@web50209.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Davis <alex14641@yahoo.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, May 01, 2008 at 04:35:07AM -0700, Alex Davis wrote:
> Is this a bad thing? I'm guessing that it is, but I want independent
> confirmation before I spoke to someone I know who's doing this.

I use it to ensure that multiple partitions are RAIDed. I have a /boot
partition which is ext3 and a large LVM partition. Both of them are
RAID-1 onto a second drive (md0 and md1) for redundancy. The second
drive has an identical partition table to the first drive.

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
