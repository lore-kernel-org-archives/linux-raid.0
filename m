From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: split RAID1 during backups?
Date: Mon, 24 Oct 2005 09:26:56 -0400
Message-ID: <435CE120.2030003@steeleye.com>
References: <E1EU16u-0002ZK-00@toko.jab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1EU16u-0002ZK-00@toko.jab.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Breidenbach <jeff@jab.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff Breidenbach wrote:

>>However you will endure a rebuild on md0 when you re-add the disk, but
>>given everything is mounted read-only, you should not practically be
>>doing anything
> 
> 
> If the rebuild operation is a no-op, then that sounds like a great
> idea. If the rebuild operation requires scanning over all data in both
> drives, I think that's going to be at least as expensive as the
> current 10 hour process.

You seem to be using a pretty bleeding edge kernel (2.6.12). If you were 
to upgrade to 2.6.13, the md bitmap (intent logging) functionality that 
is present in that kernel will allow the resync to be a no-op. 
Basically, the bitmap tracks writes to the md array, and then when 
resync occurs, only syncs blocks that have been written. Since the array 
would be readonly while you're doing backups, there would be nothing to 
resync.

See the list archives for more details on md bitmap.

--
Paul
