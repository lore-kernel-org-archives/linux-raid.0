From: Neil Brown <neilb@suse.de>
Subject: Re: Raid 5 Problem
Date: Tue, 16 Dec 2008 08:50:20 +1100
Message-ID: <18758.53532.742930.802728@notabene.brown>
References: <49450D04.8060703@nigelterry.net>
	<4945276E.1010405@ziu.info>
	<49456F94.8020100@nigelterry.net>
	<49457719.4000009@ziu.info>
	<49457BE3.4090200@nigelterry.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from nterry on Sunday December 14
Sender: linux-raid-owner@vger.kernel.org
To: nterry <nigel@nigelterry.net>
Cc: Michal Soltys <soltys@ziu.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday December 14, nigel@nigelterry.net wrote:
> 
> I added the DEVICE /dev/sd[bcde]1 to mdadm.conf and that apepars to have 
> fixed the problem.  2 reboots and it worked both times.

An alternate fix in this case would be

  mdadm --zero-superblock /dev/sdb

to remove the old superblock that is confusing things.

NeilBrown

