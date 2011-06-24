From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: raid upgrade form 1.5T to 3T drives with 0.90 superblock
Date: Fri, 24 Jun 2011 00:35:10 -0500
Message-ID: <4E04220E.3080201@hardwarefreak.com>
References: <1308854595.23175.65.camel@oxygen.netxsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1308854595.23175.65.camel@oxygen.netxsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Adamski <k@adamski.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/23/2011 1:43 PM, Krzysztof Adamski wrote:
> Hi All,
> 
> I have a raid6 array made out of 8 1.5T drives and I wanted to change to
> use 3T drives. The array is 0.90. After reading the wiki I see that 0.90
> superblock will not work with any device larger then 2T.
> 
> What are my options for a live upgrade (backup/restore is not possible)?

The best way to do this, given that you have no backup, is to add a
known-to-work-with-Linux SAS/SATA HBA and build a new md array and
format it with a fresh filesystem.  Let the 8 new drives spin for a
couple of days.  If all 8 drives are still kicking, copy everything over
from the current filesystem with a 'cp -a' or similar method.  If you
have NFS/Samba shares or other filesystem specific mappings, rsync, etc,
edit your conf files to point to the new filesystem/device.  Run in
production with the new array for a few days or a week to make sure it's
working correctly, then remove the old array at your leisure.

This staged multi step approach gives you the best chance to avoid data
loss during the migration as even after it's complete you still have the
existing array fully intact until you decide to remove it.  It is much
safer than rebuilding an 8 disk array one disk at a time.  It also puts
much less wear and tear on the new drives.  Another benefit is that
after copying the files over, the new filesystem will be much less
fragmented than in the case of rebuilding the existing array one drive
at a time.

If you don't have 16 disk bays and sufficient SAS/SATA ports in your
current chassis, and you can't leave a side panel off with the 8 new
drives simply sitting on a desk during the transition, then you should
grab an external enclosure, either desktop or rackmount, whichever fits
your needs, and an external version of the HBA.  Some options are:

If you have 16 bays or can sit the new 8 drives on the desk next to the
server during the upgrade just grab one of these cheap LSI based Intel 8
port HBAs:

http://www.newegg.com/Product/Product.aspx?Item=N82E16816117157

If you must go external, take a look at these.  A bit more costly, but a
better solution in the long run.  It'll also allow you to keep your
existing array instead of replacing it.  If you go with the rackmount
unit adding a 4 port HBA in the future will allow you to add 4 more
drives.  Each row of 4 drives has its own SFF8088 port on the back.

http://www.newegg.com/Product/Product.aspx?Item=N82E16816118116
http://www.newegg.com/Product/Product.aspx?Item=N82E16816111092
http://www.newegg.com/Product/Product.aspx?Item=N82E16816133044

-- 
Stan
