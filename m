From: Michal Soltys <nozo@ziu.info>
Subject: Re: RAID on partitions and partitions on RAID
Date: Sat, 28 Jul 2007 23:42:08 +0200
Message-ID: <46ABB830.1000204@ziu.info>
References: <loom.20070727T225545-192@post.gmane.org> <46ABAC5A.2000103@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46ABAC5A.2000103@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: Cry Regarder <cry_regarder@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michal Soltys wrote:
> Cry Regarder wrote:
> 
>>
> one hot spare. Each disk is partitioned in the same way - 64mb boot 
> partition identical on each disk, and each disk is bootable (sdX1), swap 
> (sdX2), partitionable (sdX3). sd[abcde]3 raid has GPT partition - 1st 
> one is used by LVM2 for the usual stuff (root,usr,var,home.. "just" 24GB 
> 

Correction - The swap is also on raid (on partition governed by lvm). 
Initial idea was well, risky (i.e. what if a disk failed that had its swap 
actually used).
