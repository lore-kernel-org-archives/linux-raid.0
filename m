From: Carlos Knowlton <cknowlton@mail.fsix.com>
Subject: booting from a HW RAID volume
Date: Wed, 26 Jan 2005 11:46:03 -0600
Message-ID: <41F7D75B.1040806@mail.fsix.com>
Reply-To: cknowlton@science.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,


I'm using a 3Ware 9500 12 Hardware RAID controller that has 12 of 250GB 
S-ATA drives (total storage = 2.75TB).  To my 64bit FC3 box, this looks 
like a single huge SCSI disk (/dev/sda).  I used parted to create GPT 
partitions on it, (because nothing else would work on a volume that 
big).  This seems to work fine, except that grub doesn't seem to 
recognize GPT partitions.
So here's my question:  Does anyone know a way to boot from huge volumes 
(where "huge" =  >2TB)?   even if it doesn't involve grub, or GPT, I'm 
open to suggestions.  Any clues?


Thanks!
-Carlos Knowlton
