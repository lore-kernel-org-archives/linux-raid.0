From: Julian Cowley <julian@lava.net>
Subject: Re: [RAID] forcing a read on a known bad block
Date: Tue, 11 Apr 2006 12:37:53 -1000 (HST)
Message-ID: <Pine.LNX.4.64.0604111232010.6603@taurus.cesta.com>
References: <Pine.LNX.4.64.0604092000020.29514@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0604092000020.29514@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 11 Apr 2006, dean gaudet wrote:
> anyhow this made me wonder if there's some other existing trick to force
> such reads/reconstructions to occur... or perhaps this might be a useful
> future feature.

For testing RAID, what would be really nice is if there were a virtual
disk device where one could simulate bad sectors (read or write),
non-responsive disks, etc.  It would be virtual in the same sort way
that /dev/full simulates a full disk.

This would be an ideal project for Xen.
