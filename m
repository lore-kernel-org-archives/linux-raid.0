From: Bradshaw <breadlord@gmail.com>
Subject: Checking individual drive state
Date: Sun, 05 Nov 2006 15:27:42 +0000
Message-ID: <454E02EE.5030209@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've recently built a smallish RAID5 box as a storage area for my home 
network, using mdadm. However, one of the drives will not remain in the 
array for longer that around two days before it is removed. Readding it 
to the array does not throw any errors, leading me to believe that it's 
probably a problem with the controller, which is an add-in SATA card, as 
well as the other drive connected to it failing once.

I don't know how to scan the one disk for bad sectors, stopping the 
array and doing an fsck or similar throws errors, so I need help in 
determining whether the disc itself is faulty.

If the controller is to be replaced, how would I go about migrating the 
two discs to the new controller whilst maintaining the array?

Thanks in advance

Tom Bradshaw
