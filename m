From: joystick <joystick@shiftmail.org>
Subject: Re: want-replacement got stuck?
Date: Wed, 21 Nov 2012 20:21:24 +0100
Message-ID: <50AD29B4.9050004@shiftmail.org>
References: <20121121163300.30697.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121121163300.30697.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/21/12 17:33, George Spelvin wrote:
> Just to follow up to that earlier complaint, ext4 is now noticing some errors:
>

The following procedure MIGHT provide additional information (but might 
also change the state of the array so I'm not 100% sure I'm suggesting 
the best thing to do)

cat /sys/block/md5/md/mismatch_cnt
---> record it somewhere because it will be cleared

echo check > /sys/block/md5/md/sync_action
(wait for resync to finish)
(note that this should not alter the data on the disks, it's a read-only 
procedure)

cat /sys/block/md5/md/mismatch_cnt
---> record it again now

this is relevant because if the hot replace procedure wrote wrong data 
on one disk, it should be possible to determine that from parity as 
described.

Another thing you can try, less invasive, is:

for i in /dev/sd[abcde]2 ; do echo $i ; mdadm -X /dev/sdY ; done

this should tell you various things including which flags are on the 
metadata of each disk, and which disks believe to be in the array and 
which ones believe to be out.


