From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: RAID5 losing initial synchronization on restart when one disk is spare
Date: Tue, 10 Jun 2008 15:56:21 -0700
Message-ID: <e9c3a7c20806101556q6315f4c1u67bf8879b66d81a9@mail.gmail.com>
References: <48466AD9.5@free.fr> <484E6C3F.4090204@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <484E6C3F.4090204@free.fr>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Hubert Verstraete <hubskml@free.fr>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Tue, Jun 10, 2008 at 4:57 AM, Hubert Verstraete <hubskml@free.fr> wr=
ote:
> Hubert Verstraete wrote:
>>
>> Hello
>>
>> According to mdadm's man page:
>> "When creating a RAID5 array, mdadm will automatically create a degr=
aded
>> array with an extra spare drive. This is because building the spare
>> into a degraded array is in general faster than resyncing the parity=
 on
>> a non-degraded, but not clean, array. This feature can be over-ridde=
n
>> with the --force option."
>>
>> Unfortunately, I'm seeing a kind of bug when I create a RAID5 array =
with
>> an internal bitmap, then stop the array before the initial synchroni=
zation
>> is done and restart the array.
>>
>> 1=B0 When I create the array with an internal bitmap:
>> mdadm -C /dev/md_d1 -e 1.2 -l 5 -n 4 -b internal -R /dev/sd?
>> I see the last disk as a spare disk. After the restart of the array,=
 all
>> disks are seen active and the array is not continuing the aborted
>> synchronization!
>> Note that I did not use the --assume-clean option.
>>
>> 2=B0 When I create the array without a bitmap:
>> mdadm -C /dev/md_d1 -e 1.2 -l 5 -n 4 -R /dev/sd?
>> I see the last disk as a spare disk. After the restart of the array,=
 the
>> spare disk is still a spare disk and the array continues the synchro=
nization
>> where it had stopped.
>>
>> In the case 1=B0, is this a bug or did I miss something?
>> Secondly, what could be the consequences of this non-performed
>> synchronization ?
>>
>> Kernel version: 2.6.26-rc4
>> mdadm version: 2.6.2
>>
>> Thanks,
>> Hubert
>
> For the record, the new stable kernel 2.6.25.6 has the same issue.
> I thought maybe the patch "md: fix prexor vs sync_request race" could=
 have
> fixed this, unfortunately not.
>

I am able to reproduce this here, and I notice that it does not happen
with v0.90 superblocks.  In the v0.90 case when the array is stopped
the last disk remains marked as spare.  The following hack seems to
achieve the same effect for v1 arrays, but I wonder if it is
correct... Neil?

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e9380b5..c38425f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1234,6 +1234,7 @@ static int super_1_validate(mddev_t *mddev,
mdk_rdev_t *rdev)
 		role =3D le16_to_cpu(sb->dev_roles[rdev->desc_nr]);
 		switch(role) {
 		case 0xffff: /* spare */
+			set_bit(NeedRebuild, &rdev->flags);
 			break;
 		case 0xfffe: /* faulty */
 			set_bit(Faulty, &rdev->flags);
@@ -1321,7 +1322,8 @@ static void super_1_sync(mddev_t *mddev, mdk_rdev=
_t *rdev)
 			sb->dev_roles[i] =3D cpu_to_le16(0xfffe);
 		else if (test_bit(In_sync, &rdev2->flags))
 			sb->dev_roles[i] =3D cpu_to_le16(rdev2->raid_disk);
-		else if (rdev2->raid_disk >=3D 0 && rdev2->recovery_offset > 0)
+		else if (rdev2->raid_disk >=3D 0 && rdev2->recovery_offset > 0 &&
+			 !test_bit(NeedRebuild, &rdev2->flags))
 			sb->dev_roles[i] =3D cpu_to_le16(rdev2->raid_disk);
 		else
 			sb->dev_roles[i] =3D cpu_to_le16(0xffff);
diff --git a/include/linux/raid/md_k.h b/include/linux/raid/md_k.h
index 3dea9f5..79201d6 100644
--- a/include/linux/raid/md_k.h
+++ b/include/linux/raid/md_k.h
@@ -87,6 +87,10 @@ struct mdk_rdev_s
 #define Blocked		8		/* An error occured on an externally
 					 * managed array, don't allow writes
 					 * until it is cleared */
+#define NeedRebuild	9		/* device needs to go through a rebuild
+					 * cycle before its 'role' can be saved
+					 * to disk
+					 */
 	wait_queue_head_t blocked_wait;

 	int desc_nr;			/* descriptor index in the superblock */
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
