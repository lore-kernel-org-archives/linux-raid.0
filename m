From: Paul Schriever <paul@non-creative.com>
Subject: raid5 failed logical and physically; how to reconstruct?
Date: Wed, 3 Dec 2008 21:51:50 +0100
Message-ID: <06FA127F-E560-4D16-BF86-560F9ED82006@non-creative.com>
Mime-Version: 1.0 (Apple Message framework v926)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

having used mdadm and linux for slightly over a year now to great  
pleasure I came to face a problem. My raid5 got degraded due to hard  
disc failure. After this some form of logical damage also occurred.

Everytime I wish to mount md0 I get an error from the system telling  
it's unable to mount, something wrong with the superblock.

I tried to rebuild the array, without formatting the discs, and using  
a windows based tool I can still see that data is available, but  
garbled.

Is there any way of recovering the array, and to recover my data? I am  
not a big linux guru and any tutorial / steps to take would be very  
much appreciated!

yours

Paul

