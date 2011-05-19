From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Best way to create RAID-6 for swap partition - existing one failed
Date: Wed, 18 May 2011 22:28:02 -0500
Message-ID: <4DD48E42.4010800@hardwarefreak.com>
References: <826307.18822.qm@web65107.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <826307.18822.qm@web65107.mail.ac2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gavin Flower <gavinflower@yahoo.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, mb@gem.win.co.nz
List-Id: linux-raid.ids

On 5/18/2011 9:50 PM, Gavin Flower wrote:

> Hibernation mostly worked (almost all problems were associated with the Radeon video drivers) when I was using the RAID-6 swap partition.  So I was not anticipating any new problem with hibernations.
> 
> I am using Fedora 14 with all the latest patches applied.
> 
> $ uname -a
> Linux saturn 2.6.35.13-91.fc14.x86_64 #1 SMP Tue May 3 13:23:06 UTC 2011 x86_64 x86_64 x86_64 GNU/Linux

Did you modify grub accordingly since switching from swap partition to
file, and reboot?  My very basic understanding, after reading a single
Google hit, is that hibernation to/from swap has a dependency on a grub
entry.  Thus, the problem you have now is not due to switching to a swap
file per se.  It's due to the hibernation code not automatically
recognizing you did so.

Did you read any of the Google search results?  All of the answers you
need should be there, or not far away.

-- 
Stan
