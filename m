From: Pol Hallen <raid1@fuckaround.org>
Subject: Re: mdadm striped parity RAID with Advanced Format drives
Date: Thu, 21 Jul 2011 12:46:40 +0200
Message-ID: <201107211246.40829.raid1@fuckaround.org>
References: <201107211011.40151.polhallen@fuckaround.org> <4E27FECE.8010201@hardwarefreak.com>
Reply-To: polhallen@fuckaround.org
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E27FECE.8010201@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Pol, *IF* the answer to #1 is yes, creating the array properly becomes
> easier.  Simply create the array with raw device names and no partition
> numbers, for example, sd[a,b,c,d,e,f].  If you've already created
> partitions on the drives, wipe everything off all drives, including the
> partitions tables.
> If the answer to #1 is 'no', and to #2 is 'yes', then you need to follow
> the instructions posted by Erwan Leroux.

Thanks for your courtesy :-)

tonight I disasseble whole raid and check again disks, next I'll create a raid 
and will do performance test, that I'll post to list.

Thanks again :-)
 
Pol
