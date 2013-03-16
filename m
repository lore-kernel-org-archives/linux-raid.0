From: Andrey Borzenkov <arvidjaar@gmail.com>
Subject: Handling of stale array members in Linux MD
Date: Sat, 16 Mar 2013 12:04:51 +0400
Message-ID: <20130316120451.4cd714c3@opensuse.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm looking at adding validation of array members to grub2 array
assembly code and have some questions.

1. As far as I understand, two devices are compared basing on single 64
bit event counter. I do not see any counter wrap around check. Is it
something that can not ever happen?

2. When array is declared ready for use? I.e. consider RAID10 with 4
members where each mirror pair lost one member. E.g. due to
connectivity failure. After some time system is rebooted and second
pair is lost, but the first one is now available. So we get valid array
(both stale members have the same event counter). Will array be
assembled at this point? What happens if other two device appear later?
Will the be kicked off array? 

Thank you in advance

-andrey
