From: Philip Molter <philip@corp.texas.net>
Subject: Re: Software RAID & Filesystem Cache
Date: Sat, 07 Aug 2004 09:04:48 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4114E180.7000902@corp.texas.net>
References: <4112731A.5030000@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4112731A.5030000@h3c.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> <berlin>/sys % find . | grep ahead
> ./block/hdf/queue/read_ahead_kb
> ./block/hdg/queue/read_ahead_kb
> ./block/hdc/queue/read_ahead_kb
> ./block/hda/queue/read_ahead_kb

Yeah, these definitely have no effect on how much is being read from the 
disks.  There is a direct correlation, though, between the chunk size on 
the raid0 portion of the raid10 and the amount of data that is read.  If 
you increase the chunk size, you increase not just the number of bytes 
read from the disks.

There's something seriously messed up with software RAID10.  It's 
practically unusable for high-load situations where before it was 
perfectly fine.
