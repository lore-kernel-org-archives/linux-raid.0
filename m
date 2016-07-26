From: Phil Turmel <philip@turmel.org>
Subject: Re: GPT corruption on Primary Header, backup OK, fixing primary nuked
 array -- help?
Date: Tue, 26 Jul 2016 13:14:03 -0400
Message-ID: <54ca746c-36eb-c1cb-1975-9ecc619fb1b2@turmel.org>
References: <5796B46B.6060905@suddenlinkmail.com>
 <413b1150-ca38-1907-ea5d-b68ad2f75710@websitemanagers.com.au>
 <5796F4E0.9070206@suddenlinkmail.com> <57971D3C.8040602@suddenlinkmail.com>
 <ff6872cd-98eb-aad2-a71a-7af52050ff30@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ff6872cd-98eb-aad2-a71a-7af52050ff30@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, "David C. Rankin" <drankinatty@suddenlinkmail.com>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi David, Adam,

On 07/26/2016 05:52 AM, Adam Goryachev wrote:
> On 26/07/2016 18:20, David C. Rankin wrote:
>>>> # cat /proc/mdstat
>>> Personalities : [raid1]
>>> md4 : active raid1 sdc[0]
>>>        2930135488 blocks super 1.2 [2/1] [U_]
>>>        bitmap: 0/22 pages [0KB], 65536KB chunk

> No, I'm saying that is an excellent idea, and it is exactly what I
> always do. The problem is that you created the single large primary
> partition, and then used the raw drive for the raid array instead of
> using the partition.

The drive probably came with a single large partition in a GPT table.
mdadm was created using the whole disk, which neither needs nor expects
there to be a partition table.  (I do not use partitions for my big
arrays -- whole disks only.)

When mdadm created the array, it probably wiped out the starting table,
but not the GPT backup.  Which may or may not be outside the used data
area of the array.  So you allowed a partition tool to "fix" a partition
table that isn't being used.  The simplest solution is to zero the first
4k of the disk and zero the GPT backup partition table location.

I suggest re-adding /dev/sdd to the array (not /dev/sdd1, and not
--add), whether you delete the table or not.  A --re-add will probably
be nearly instant, since there is a bitmap.

Phil
