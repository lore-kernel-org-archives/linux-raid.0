From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: mdadm striped parity RAID with Advanced Format drives
Date: Thu, 21 Jul 2011 05:26:22 -0500
Message-ID: <4E27FECE.8010201@hardwarefreak.com>
References: <201107211011.40151.polhallen@fuckaround.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201107211011.40151.polhallen@fuckaround.org>
Sender: linux-raid-owner@vger.kernel.org
To: Pol Hallen <polhallen@fuckaround.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 7/21/2011 3:11 AM, Pol Hallen wrote:
> Hello and sorry if I write you in private..

No worries.  I'm taking this back on list as others have more experience
with this than me.

> about 2Tb wd and 4Kb size, is there a howto to check and correct the size of 
> these disks?
> 
> Can you tell me how?

> 	Model Number:       WDC WD20EARS-00MVWB0                    

1. Can one create a RAID5 from bare (partition-less) AF drives and avoid
the read-modify-write problem?

2. Or is one required to assemble the array from properly aligned
partitions created on each drive?

Pol, *IF* the answer to #1 is yes, creating the array properly becomes
easier.  Simply create the array with raw device names and no partition
numbers, for example, sd[a,b,c,d,e,f].  If you've already created
partitions on the drives, wipe everything off all drives, including the
partitions tables.

If the answer to #1 is 'no', and to #2 is 'yes', then you need to follow
the instructions posted by Erwan Leroux.

-- 
Stan
