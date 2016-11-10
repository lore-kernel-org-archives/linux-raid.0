From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Help in recovering a RAID5 volume
Date: Thu, 10 Nov 2016 17:32:17 +0000
Message-ID: <5824AF21.70604@youngman.org.uk>
References: <CA+GmhESH-2hDJrOjvNzVBsgCP65BnUE2AbfOZ1Bbrp02jyBNUQ@mail.gmail.com>
 <5824A918.3030300@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5824A918.3030300@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Felipe Kich <fkich1977@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/11/16 17:06, Wols Lists wrote:
> Add in the fourth disk - it'll trigger a rebuild, but that's normal.
> 
Just had a thought. Especially if you get larger drives, and you can
identify and copy just the three good disks, then don't bother with the
bad one.

Just partition the new fourth disk the way you plan to do it, and then
add it back in. You can then use the utilities to re-arrange the other
drives.

Or, and it's a bit more work, partition the new drives the way you want,
and ddrescue the old drives partition by partition, rather than a drive
at a time. But it'll save moving the partitions around later.

Cheers,
Wol

