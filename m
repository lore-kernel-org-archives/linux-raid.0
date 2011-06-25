From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: raid upgrade form 1.5T to 3T drives with 0.90 superblock
Date: Fri, 24 Jun 2011 19:15:29 -0500
Message-ID: <4E0528A1.10608@hardwarefreak.com>
References: <1308854595.23175.65.camel@oxygen.netxsys.com>	 <4E04220E.3080201@hardwarefreak.com> <1308918217.23175.85.camel@oxygen.netxsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1308918217.23175.85.camel@oxygen.netxsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Adamski <k@adamski.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/24/2011 7:23 AM, Krzysztof Adamski wrote:
> On Fri, 2011-06-24 at 00:35 -0500, Stan Hoeppner wrote:
>> On 6/23/2011 1:43 PM, Krzysztof Adamski wrote:
>>> Hi All,
>>>
>>> I have a raid6 array made out of 8 1.5T drives and I wanted to change to
>>> use 3T drives. The array is 0.90. After reading the wiki I see that 0.90
>>> superblock will not work with any device larger then 2T.
>>>
>>> What are my options for a live upgrade (backup/restore is not possible)?
>>
>> The best way to do this, given that you have no backup, is to add a
>> known-to-work-with-Linux SAS/SATA HBA and build a new md array and
>> format it with a fresh filesystem.  Let the 8 new drives spin for a
>> couple of days.  If all 8 drives are still kicking, copy everything over
>> from the current filesystem with a 'cp -a' or similar method.  If you
>> have NFS/Samba shares or other filesystem specific mappings, rsync, etc,
>> edit your conf files to point to the new filesystem/device.  Run in
>> production with the new array for a few days or a week to make sure it's
>> working correctly, then remove the old array at your leisure.
> 
> I was afraid of this. I only have 4 empty drive bays in my Norco 4220
> case, I will have to shut down the second array and remove it during the
> time I'm upgrading. I will also have to get an HBA that supports 3T
> drives.
> 
>> This staged multi step approach gives you the best chance to avoid data
>> loss during the migration as even after it's complete you still have the
>> existing array fully intact until you decide to remove it.  It is much
>> safer than rebuilding an 8 disk array one disk at a time.  It also puts
>> much less wear and tear on the new drives.  Another benefit is that
>> after copying the files over, the new filesystem will be much less
>> fragmented than in the case of rebuilding the existing array one drive
>> at a time.
> 
> I have before upgrade a 5 drive array one drive at a time without
> problems, but the new drives were only 2T.
> 
>> If you don't have 16 disk bays and sufficient SAS/SATA ports in your
>> current chassis, and you can't leave a side panel off with the 8 new
>> drives simply sitting on a desk during the transition, then you should
>> grab an external enclosure, either desktop or rackmount, whichever fits
>> your needs, and an external version of the HBA.  Some options are:
>>
>> If you have 16 bays or can sit the new 8 drives on the desk next to the
>> server during the upgrade just grab one of these cheap LSI based Intel 8
>> port HBAs:
>>
>> http://www.newegg.com/Product/Product.aspx?Item=N82E16816117157
> 
> This card is based on 1068E chip, it does not support drives larger then
> 2T. I already have 2 LSI cards based on the same chip and I will need to
> upgrade.

Good point.  Sorry for the oversight.  Now knowing that you have the 20
bay 4220 chassis, I'd suggest moving to a single LSI PCIe 2.0 x8 6Gb/s
HBA and an Intel SAS expander, to control all 20 bays and allowing 3TB
drives in all bays.

http://www.lsi.com/products/storagecomponents/Pages/MegaRAIDSAS9240-4i.aspx

http://www.intel.com/Products/Server/RAID-controllers/re-res2sv240/RES2SV240-Overview.htm

You can power the expander via the PCIe x4 edge connector or via a
standard 4 pin Molex PSU power plug if you mount the expander PCB to the
side or floor of the chassis with stand offs, which is the method I use
to save all my PCIe slots.

This combo will give you 2.4GB/s (4.8 bidirectional) throughput to all
20 bays, or 120MB/s per drive.  You plug one SFF8087 from the HBA into
the expander and 5 such cables from the expander to each backplane.  You
probably already have all the cables you need but for the HBA to
expander cable.

After transitioning the system from the current HBAs to the new single
HBA and expander, and verifying functionality, add 4 of your eight 3TB
drives to the 4 empty bays.  Create an md RAID5 array of the 4 disks and
create your filesystem.  You will have ~9TB usable space, about the same
as your eight 1.5TB drive RAID6.  Copy all files over to the new array
as previously discussed, verify functionality.

Now take the existing eight 1.5TB drive RAID6 array offline.  Pull all 8
drives of that array from the chassis.  Insert the remaining four 3TB
drives and reshape the new RAID5 array to include the 4 new disks.  I'm
not sure if you can reshape with the new drives straight to RAID6 at
this point in one step.  If it's possible do so, go for it.  If not,
reshape the RAID5 with the new drives, and when that completes
successfully then reshape again to RAID6.

If anything goes wrong, you still have the original 8 1.5TB drives
stashed in a cabinet somewhere if you need to revert back.

Hope this was helpful.

-- 
Stan
