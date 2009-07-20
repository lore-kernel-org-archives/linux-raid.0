From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: RE: Question on RAID-5 rmw & rcw(read modify write & read construct write)
Date: Mon, 20 Jul 2009 11:00:05 -0700
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C07BC55C5@SDCEXCHANGE01.ad.amcc.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07BC55B3@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C07BC55B3@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tirumala Reddy Marri <tmarri@amcc.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,
  I am reading following lines from "raid5.h" , not clear what they
mean. If some DMA engines doesn't support what should we do ?


 * 1/ Parity check operations destroy the in cache version of the parity
block,
 *    so we prevent parity dependent operations like writes and
compute_blocks
 *    from starting while a check is in progress.  Some dma engines can
perform
 *    the check without damaging the parity block, in these cases the
parity
 *    block is re-marked up to date (assuming the check was successful)
and is
 *    not re-read from disk.

Regards,
Marri

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Tirumala Reddy
Marri
Sent: Monday, July 20, 2009 10:39 AM
To: linux-raid@vger.kernel.org
Subject: Question on RAID-5 rmw & rcw(read modify write & read construct
write)

Hi,
 I am trying to understand read-modify-write & read-construct-write as
part of my HW accelerated RAID-5 driver debugging.  How it is decided on
stripe to be rmw/rcw ? 
Is this happen every time when application try to write to disks with
bio of less than a chunk size ?


  I am seeing file system inconsistencies while raid-5 recovery is
happening and writing data to /dev/md0 with ext3/ext2  installed and
mounted on a directory.

Thanks in advance,
Marri
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
