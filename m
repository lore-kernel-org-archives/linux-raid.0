From: Mike Alsop <mike.alsop@tbpl.com.au>
Subject: Upgarding Mdadm
Date: Tue, 18 Dec 2012 15:18:02 +0930
Message-ID: <1355809682.2269.65.camel@mike-g73>
Reply-To: mike.alsop@tbpl.com.au
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi guys

I would mainly like to get some confirmation that I can upgrade my mdadm
with source code on a system that is already running.

I am running an Ubuntu 10.04 server which has a fairly early version of
madm (straight from repository) and it has the problem that so many
people have written about when rebooting or starting up. I have to have
about 3 goes as it keeps complaining that one of the drives (by UUID) is
not present. It is the drive listed in fstab, not the arrays. All of a
sudden after a few attempts it starts up OK.

Many of the articles refer to upgrading to mdadm 3.1.5 from the source
code as a good fix.

I haven't actually seen anyone write about the upgrade process itself,
so my question boils down to asking if I can remove the repository
version with apt-get, then install the new version from source on a
system that is actually operating??

Is anyone sure if it will work with Ubuntu 10.04 server?? Does anything
else need upgrading.

I would certainly appreciate any advice.

Mike
Australia

