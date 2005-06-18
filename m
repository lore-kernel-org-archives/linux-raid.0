From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: when does it become faulty disk
Date: Sat, 18 Jun 2005 13:47:16 +0200
Message-ID: <5d96567b05061804477325d743@mail.gmail.com>
Reply-To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have managed to make the kernel remove a disk 
from my raid even if this raid is "/" . I did it by adding a line 
in ata_scsi_error that remove the ata disk from the raid array.
This means that when the first error ocurrs on a disk It is removed 
from the array. 
Well, this is not the best thing to do..
Question is :
When does a disk become faulty ?
Is when you have N errors in T time ?
New ideas would be welcomed.

-- 
Raz
Long Live the Penguin
