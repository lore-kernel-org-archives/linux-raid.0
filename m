From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: Question on RAID-5 rmw & rcw(read modify write & read construct write)
Date: Mon, 20 Jul 2009 10:39:06 -0700
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C07BC55B3@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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
