From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Question about ADMA + RAID5 in the event of disk failure
Date: Tue, 5 Jan 2010 18:25:35 -0700
Message-ID: <e9c3a7c21001051725w20b243f9me6e1114fd8f79ab6@mail.gmail.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C08882F60@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C08882F60@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tirumala Reddy Marri <tmarri@amcc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 4, 2010 at 10:16 AM, Tirumala Reddy Marri <tmarri@amcc.com>=
 wrote:
>
> Hi Dan,
> =A0 I have question about what ADMA + RAID-5 and disk failure. In the=
 event of disk failure what would happen to the descriptors which are q=
ueued up the DMA engine for XOR operation ?
> This is what I am trying.
> 1. Create RAID-5 using 4 disks.
> 2. Install xfs file system and mount it.
> 3. Force the disk failure using mdadm -f /dev/md0 /dev/sdc
> 4. Then hot remove the drive mdadm -r /dev/md0 /dev/sdc
> 5. Un-mount the /dev/md0. Then run file system check using xfs_repair=
 -L /dev/md0.
>
>
> I see messages as shown below. These messages doesn't show up if I do=
n't use ADMA. But there seem to be no data loss. But still I there seem=
 to be a some kind of data inconsistency.

Yes, presumably the adma driver as it does not look like parity is
being correctly written to the disks.  Does this driver survive
extended testing with dmatest?  Check that after creating the array
you can run "echo check > /sys/block/md0/md/sync_action" and end up
with zero errors in /sys/block/md0/md/mismatch_cnt.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
