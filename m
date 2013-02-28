From: Oliver Schinagl <oliver+list@schinagl.nl>
Subject: Expanding array with multiple devices
Date: Thu, 28 Feb 2013 21:27:15 +0100
Message-ID: <512FBDA3.7080501@schinagl.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello list,

I've looked online a bit, but didn't really find the answer to the 
following question.

While expanding an existing raid is as simple as mdadm --add, followed 
by an mdadm --grow, How would you go about this when expanding it with 
multiple devices.

A little bit of background. I have 8 2TB disks, 4 in a current raid5 
array, which will be the donor disks en 4 'new' disk going to form the 
basis of a new array. I want to change chunk size and re-format to ext4 
to a) optimize the new array according to the new parameters 
(stride,stripe-width) and (possibly) a new ondisk ext4 disk format (new 
features added since last time). The old array was 4 disk raid5, the new 
array will be 8 disk raid6.

So far, I have created a new raid6 array with the 4 'new' disks + 2 
'missing' for the parity. I have done it this way, so that I would have 
enough space to copy (and verify) files. having done a 4 disk raid6 
without any missing devices, there would simply have not been enough 
space. True I could have used 3 data disks, 1 parity and 1 missing.

Anyway, my plan next, is to expand the array. I can think of the 
following options.

a) Remove 1 disk at a time from the old array, and add it to the new 
array, first 2 disks would be parity, after that --growing the last two. 
Big disadvantage is of course that there will be almost a week or two of 
re-syncing going on.

b) Would be to somehow add all 'extra' disks at once, and have it rsync 
it all in one go.

Any idea's how best to expand all this?

Oliver
