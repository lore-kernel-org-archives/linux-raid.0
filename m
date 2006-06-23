From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: Is shrinking raid5 possible?
Date: Fri, 23 Jun 2006 20:16:58 +0200
Message-ID: <bb145bd20606231116g7808e467w29a9bf273ba0df52@mail.gmail.com>
References: <44960C45.9050407@anu.edu.au>
	 <17558.10906.59066.196870@cse.unsw.edu.au> <449B3A80.4070602@tmr.com>
	 <17563.17224.85968.572754@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17563.17224.85968.572754@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Why would you ever want to reduce the size of a raid5 in this way?

A feature that would have been useful to me a few times is the ability
to shrink an array by whole disks.

Example:

8x 300 GB disks -> 2100 GB raw capacity

shrink file system, remove 2 disks =

6x 300 GB disks --> 1500 GB raw capacity

Why?

If you're not backed up by a company budget, moving data to an new
array (extra / larger disks) is extremely difficult. A lot of cases
will hold 8 disks but not 16, never mind the extra RAID controller.
Building another temporary server and moving the data via Gigabit is
slow and expensive as well.

Shrinking the array step-by-step and unloading data onto a regular
filesystem on the freed disks would be a cheap (if time consuming) way
to migrate, because the data could be copied back to the new array a
disk at a time.

Thanks,

C.
