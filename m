From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: rebuilding Raid1 array
Date: Thu, 17 May 2012 20:44:09 +0100
Message-ID: <4FB55509.7050300@anonymous.org.uk>
References: <4FB5402C.10306@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FB5402C.10306@rogers.com>
Sender: linux-raid-owner@vger.kernel.org
To: Wiliam Colls <william.colls@rogers.com>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 17/05/2012 19:15, Wiliam Colls wrote:
> We recently had one of the disks in a 2 disk RAID1 array go down. We
> successfully removed the failed unit from the array, replaced the
> physical disk, and rebooted. Once back up and running the partition
> table from the working disk was copied to the new physical disk, and
> then the appropriate partition was added back into the array, and the
> array began to resync, and now appears to be running happily.
>
> In reviewing the process afterwards, I realised that the partition was
> never formatted (ext3). Does the resync apply the format as part of the
> process?

Yes, md operates below the level of the filesystem, and mirrors 
everything including the format and filesystem, so you don't need to 
format member devices before building an array or replacing them.

Cheers,

John.

