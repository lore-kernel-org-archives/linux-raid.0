From: Hubert Verstraete <hubskml@free.fr>
Subject: first partition on partitionable RAID-5 array
Date: Wed, 12 Mar 2008 16:21:27 +0100
Message-ID: <47D7F4F7.3040006@free.fr>
References: <47AC7463.7000502@free.fr> <20080208081649.rfx07p98ckcgc0sg@estone.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080208081649.rfx07p98ckcgc0sg@estone.ca>
Sender: linux-raid-owner@vger.kernel.org
To: michael@estone.ca
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

michael@estone.ca wrote:
> My symptons were similar that any partitionable Raid 5 array would be 
> slower, but ony on the first partition.
> mdadm version 2.5.6
> kernel 2.6.18
>
> Mike

Regarding the slow write performance on the first partition of a 
partitionable RAID-5 array, actually this is not linked with the first 
partition. This issue happens when the partition does not start on a 
cylinder, and this is almost always the case for the first partition 
which does not start on the first sector of the first cylinder (some 
space is reserved for the partition table).

This symptom doesn't exist on RAID-1.

Does anyone know why ?

Hubert
