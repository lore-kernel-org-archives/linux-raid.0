From: Juraj Holtak <juraj@proaut.org>
Subject: Re: how to add third drive to RAID1 made of two drives without
	destroying data
Date: Sat, 22 Oct 2005 20:59:42 +0200
Message-ID: <1130007582.11518.21.camel@localhost.localdomain>
References: <1129999982.11518.18.camel@localhost.localdomain>
	 <200510221319.22002.chase.venters@clientec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200510221319.22002.chase.venters@clientec.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chase Venters <chase.venters@clientec.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Samstag, den 22.10.2005, 13:18 -0500 schrieb Chase Venters:

> Indeed. Check mdadm --grow:

I did

mdadm --grow /dev/md9 -n3
mdadm --manage /dev/md9 --add /dev/sdc9

Works like a charm. Thank you.

cheers,
juraj

