From: bugzilla@watkins-home.com
Subject: Read error causes a drive to go off-line
Date: Wed, 12 Nov 2003 00:52:45 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200311120552.hAC5qjT28598@dns1.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a RAID-5 with 7 18 Gig disks.
When I have a read error or write error the disk is failed by md.
I have an Adaptec SCSI card.  When I run the verify on the "bad" disk
it "corrects" the bad spot.  I can then boot and it will re-build the disk.

I have done this 3 or 4 times in the last 1-2 years.

The drives are Seagete SX118202LS (18 Gig).

I have Seagate's SeaTools.  The tools allow me to adjust some drive
parameters, 2 of which I think I should change.

Automatic Write Reallocation Enable (AWRE):
  On, drive automatically relocates bad blocks detected during write operations.
  Off, drive creates Check Condition status with sense key of Medium Error if
       bad blocks are detected during write operations.

Automatic Read Reallocation Enable (ARRE):
  On, drive automatically relocates bad blocks detected during read operations.
  Off, drive creates Check Condition status with sense key of Medium Error if
       bad blocks are detected during read operations.

Both are off.
I think MD would not know that a bad block exists if these were on.
I think ARRE is somewhat wrong in the discription.  I bet it will generate
a sense key of Medium Error if it can't read a block, unless it is a
correctable error.

Anyway, does anyone know what would be best?

Thanks.
