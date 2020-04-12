From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Is it possible to create a single zone RAID0 with different
 size member disks?
Date: Sun, 12 Apr 2020 14:12:59 +0500
Message-ID: <20200412141259.14955b2e@natsu>
References: <5ng5lZpZoJjtdf9Xkshn3CSzsLIErcNWAzPPARDbDdzNY9Kr-tgMjy6djUaqRVo9r9KmB2HMV0ZQuurdV7wNDYGOP4azAiw1jPkcoF10-SM=@protonmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5ng5lZpZoJjtdf9Xkshn3CSzsLIErcNWAzPPARDbDdzNY9Kr-tgMjy6djUaqRVo9r9KmB2HMV0ZQuurdV7wNDYGOP4azAiw1jPkcoF10-SM=@protonmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Fisher <fisherthepooh@protonmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 10 Apr 2020 09:29:19 +0000
Fisher <fisherthepooh@protonmail.com> wrote:

> Is there any way I can create a single zone raid0 with different size member disks?

I'm not sure about the actual zones issue, but the easiest workaround seems to
be to just create a same-sized partition on each disk, and then do RAID0 of
those partitions.

It might be a good idea regardless (RAID of partitions instead of raw disks),
because that way unrelated operating systems and LiveCDs you might boot on the
machine will not see these as empty uninitialized drives, but will properly
detect what they are used for, and to what extent.

In fact you can even use the remaining space on each disk for partitions of
other purposes -- or to make more RAIDs. Say, if you got disks of:

  2TB
  2TB
  3TB
  3TB

You can make one 4x2TB RAID0, and one 2x1TB RAID0 from the tails of 3TB disks.

Or 4x2TB RAID5 and 2x1TB RAID1.

Then run LVM on top of it all to join both into one large volume.

-- 
With respect,
Roman
