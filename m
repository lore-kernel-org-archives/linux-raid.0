From: Laurent CARON <lcaron@apartia.fr>
Subject: Expanding array by changing disks (one by one)
Date: Thu, 14 Apr 2005 12:11:20 +0200
Message-ID: <425E41C8.7050704@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

We are in the process of increasing the size our RAID Arrays as our 
storage needs increase.

I've got 2 solutions for this:

- Copy the data over a new array and replace the disks

- Replace each disk (one after the other(after resync)) of the existing 
array with a bigger one.

Start:
    - Array is ok
- Remove 1 disk
    - Array is degraded
- Add a bigger disk
    - Resync
- Remove another disk
    - Array is degraded
- Add a bigger disk
    - Resync
.....

Would this be the 'state of the art' way ?

Will the filesystem cope with it?

Is my mind completely broken?

Thanks for your help.

Laurent


