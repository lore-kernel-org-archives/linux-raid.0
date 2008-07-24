From: John Robinson <john.robinson@anonymous.org.uk>
Subject: dmraid / RAID-5 / ICH10R
Date: Thu, 24 Jul 2008 18:32:56 +0100
Message-ID: <4888BCC8.9020308@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just got myself a new PC with an Asus P5Q PRO board and a bunch of SATA 
discs, and I'd like to install it booting off a RAID-5 array on the 
Intel Matrix Storage controller on the ICH10R southbridge, so I'm 
looking for dmraid support for the ICH10R. It's there up to a point in 
CentOS 5.2, but I think not for RAID-5, at least not according to the 
docs I've looked at. I'd settle for booting off RAID-1 but the Intel 
BIOS utility won't let me configure both a small RAID-1 and the rest 
RAID-5 on the same bunch of discs.

I see a report of a similar problem in Fedora 8 on ICH9R from November 
2007, so I've stuck my oar in there too: 
https://bugzilla.redhat.com/show_bug.cgi?id=364901

Anyway, is this something that should be working already and I'm doing 
it wrong, or something that's coming soon?

Cheers,

John.

