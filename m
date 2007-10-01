From: Daniel Santos <daniel.dlds@gmail.com>
Subject: problem killing raid 5
Date: Mon, 01 Oct 2007 12:04:52 +0100
Message-ID: <4700D454.7020607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I had a raid 5 array on three disks. Because of a hardware problem two 
disks dissapeared one after the other. I have since been trying to 
create a new array with them.

Between the degradation of the two disks I tryied removing one of the 
failed disks and re-adding it to the array. When the second disk failed 
I noticed the drive numbers on the broken array, and misteriously a 
fourth drive appeared on it. Now I have numbers 0,1 and 3, but no number 2.
mdadm tells me that number 3 is a spare.

Now I want to start all over again, but even after zeroing the 
superblocks on all three disks, and creation of a new array, 
/proc/mdstat shows the same drive numbers, while reconstructing the 
third drive.
What should I do ?

Daniel Santos
