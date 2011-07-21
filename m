From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: mdadm striped parity RAID with Advanced Format drives
Date: Thu, 21 Jul 2011 06:18:07 -0500
Message-ID: <4E280AEF.4020801@hardwarefreak.com>
References: <201107211011.40151.polhallen@fuckaround.org> <4E27FECE.8010201@hardwarefreak.com> <alpine.DEB.2.00.1107211226540.20159@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1107211226540.20159@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Pol Hallen <polhallen@fuckaround.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 7/21/2011 5:27 AM, Mikael Abrahamsson wrote:
> On Thu, 21 Jul 2011, Stan Hoeppner wrote:
> 
>> 1. Can one create a RAID5 from bare (partition-less) AF drives and
>> avoid the read-modify-write problem?
> 
> Yes, that's what I always do.

Ok, good.

>> 2. Or is one required to assemble the array from properly aligned
>> partitions created on each drive?
> 
> No.

Great.

Ok. Pol, keep in mind that all drives must be identical size when
creating an array on raw disks.  You said you're now working with 6
identical WD drives so this shouldn't be an issue.

After you shutdown and delete the current array, wipe all existing
partitions and partition tables from these drives before creating the
raw disk array.  Use:

~$ dd if=/dev/zero of=/dev/sdX bs=512 count=1

Do this once for each drive, replacing 'X' with the proper letter.  Then
create your new RAID5 array using sd[a,b,c,d,e,f].

Good luck.

-- 
Stan
