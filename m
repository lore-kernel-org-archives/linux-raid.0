From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Can not start md0 after upgrade.
Date: Wed, 25 May 2011 09:54:32 -0500
Message-ID: <4DDD1828.2020306@hardwarefreak.com>
References: <201105250819.27372.johnm@advocap.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201105250819.27372.johnm@advocap.org>
Sender: linux-raid-owner@vger.kernel.org
To: John McMonagle <johnm@advocap.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/25/2011 8:19 AM, John McMonagle wrote:
> Just upgraded a poweredge 1850 server from Debian lenny to squeeze and can not 
> boot with the new 2.6.32 kernel.
> 
> From lspci  have this controller:
> SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT 
> Dual Ultra320 SCSI (rev 08)
> 
> 
> Running mdadm raid with root on md0.
> 
> Normally run xen but all  info is for when running without xen.
> 
> I can still boot with the 2.6.26 kernel but not with the new 2.6.32 kernel.
> Under 2.6.32 it fails to start md0.
> in the busy box console 
> Can see all the needed partitions.
> What was sda and sdb are now sdb and sdc that should not matter??
> mdadm.conf is:
> DEVICE partitions
> CREATE owner=root group=disk mode=0660 auto=yes
> HOMEHOST <system>
> MAILADDR xxxxx@advocap.org
> ARRAY /dev/md0 level=raid1 num-devices=2 
> UUID=6f744c89:d2578f95:c150b018:d9f789b1
> ARRAY /dev/md1 level=raid1 num-devices=2 
> UUID=7938d59c:28a69e5e:3facbdc2:12974557

This is probably due to udev changes.  What device is now sda?

Using drive UUIDs instead of /dev/sdx in your arrays should fix this.

-- 
Stan
