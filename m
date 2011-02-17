From: NeilBrown <neilb@suse.de>
Subject: Re: File system corruption during setting new size (native/extarnal
 metatdat) after expansion
Date: Thu, 17 Feb 2011 21:03:39 +1100
Message-ID: <20110217210339.4adc1492@notabene.brown>
References: <905EDD02F158D948B186911EB64DB3D178EC32BC@irsmsx503.ger.corp.intel.com>
	<20110217153815.2212b13d@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D178EC3637@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D178EC3637@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Thu, 17 Feb 2011 08:45:36 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

> Thank you for workarounds/temporary fixes.
> 
> Regarding imsm_num_data_members() setting second_map to 0 cannot help as it is always called with this parameter set to 0.
> In this situation, when first map should be always present, we can have some race condition.
> I have no reproduction for mdmon crash you are observing, but I'll try some changes in my scripts and I'll carefully watch any signs 
> that can indicate reproduction of this problem.
> 
> If you could let me know details about changes you made to my scenario, it could help.
> 

This is the script I was using:

----------------------------------------------
export IMSM_NO_PLATFORM=1
export IMSM_DEVNAME_AS_SERIAL=1
export MDADM_EXPERIMENTAL=1
umount /mnt/vol
mdadm -Ss
rm -f /backup.bak

#create container
mdadm -C /dev/md/imsm0 -amd -e imsm -n 3 /dev/sda /dev/sdb /dev/sdc -R

#create volume
mdadm -C /dev/md/raid5vol_0 -amd -l 5 --chunk 64 --size 104857 -n 3 /dev/sda /dev/sdb /dev/sdc -R
mkfs /dev/md/raid5vol_0
mount /dev/md/raid5vol_0 /mnt/vol

#copy some files from current directory
cp * /mnt/vol

#add spare
mdadm --add /dev/md/imsm0 /dev/sdd

mdadm --wait /dev/md/raid5vol_0

#start reshape
mdadm --grow /dev/md/imsm0 --raid-devices 4 --backup-file=/backup.bak
#mdadm  --wait /dev/md/raid5vol_0
sleep 10
while grep reshape /proc/mdstat > /dev/null
do sleep 1
done
while ps axgu | grep 'md[a]dm' > /dev/null
do sleep 1
done
umount /mnt/vol
fsck -f -n /dev/md/raid5vol_0
-------------------------------------------------

I did have an 'mdadm --wait' where the 'while grep reshape' is.  I changed it
because it seemed to be causing problems, but I may have been wrong about the
cause.

This would fairly reliably result in mdmon dying.

This is the patch I applied
-------------------------------------
diff --git a/super-intel.c b/super-intel.c
index 5d39d5b..fa195c3 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1600,6 +1600,7 @@ static __u8 imsm_num_data_members(struct imsm_dev *dev, int second_map)
         */
        struct imsm_map *map = get_imsm_map(dev, second_map);
 
+       if (map == NULL) map = get_imsm_map(dev, 0);
        switch (get_imsm_raid_level(map)) {
        case 0:
        case 1:

-----------------------------------

This was on an oldish source tree (commit 152b223157), so maybe it is already
fixed.
But without that patch is crashed often, and with it in didn't crash at all.

NeilBrown
