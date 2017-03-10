From: Roman Mamedov <rm@romanrm.net>
Subject: Re: RAID 5 3-drive array inactive - no superblock - can anything be
 saved?
Date: Fri, 10 Mar 2017 21:05:19 +0500
Message-ID: <20170310210519.5263a2bb@natsu>
References: <deec02c3-26fd-3297-ec0c-5497cbb9a9e7@schultzfamily.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <deec02c3-26fd-3297-ec0c-5497cbb9a9e7@schultzfamily.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Schultz <rob@schultzfamily.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 10 Mar 2017 10:18:19 -0500
Robert Schultz <rob@schultzfamily.ca> wrote:

>  >sudo mdadm --assemble --force /dev/md0 /dev/sdb /dev/sdc /dev/sdd
> mdadm: Cannot assemble mbr metadata on /dev/sdb
> mdadm: /dev/sdb has no superblock - assembly aborted
> 
> Running the command with any of the disks says the same thing - no 
> superblock.

But it seems that your array was/is on partitions, not disks, so why are you
assembling with disks? Use sdb1 sdc1 sdd1 in the assemble command and try
again.

-- 
With respect,
Roman
