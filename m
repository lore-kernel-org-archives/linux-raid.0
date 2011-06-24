From: maurice <mhilarius@gmail.com>
Subject: Re: Looking for the best way to do this
Date: Fri, 24 Jun 2011 10:35:27 -0600
Message-ID: <4E04BCCF.9000604@gmail.com>
References: <4E00DF31.2020406@gmail.com> <4E03929A.8000503@cdf.toronto.edu> <4E03B8DB.7010607@gmail.com> <4E04B8A9.1050502@cdf.toronto.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E04B8A9.1050502@cdf.toronto.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Iordan Iordanov <iordan@cdf.toronto.edu>
Cc: maurice <mhilarius@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/24/2011 10:17 AM, Iordan Iordanov wrote:
> Hi Maurice,
> ..
> R10 has different layouts. There are two components to the layout - 
> where the chunks are located on the different devices (near, offset, 
> far), and number of copies of the data. The near/offset/far part of 
> the layout does not play a role in reliability, just in performance. 
> So, the number of copies is the only thing that matters to this 
> discussion.
>
> If you have R10 with 3 disks and 3 copies, it is equally reliable to 
> R1 with 3 disks, as they have an equal number of copies. In both R10 
> and R1 in this case, two disks can fail, and you still have 1 intact 
> copy remaining.
>
 From what I read, assuming I want to optimize this for READ 
performance, I would want "R10 far".
As I understand this, if I wanted the R10, I could set aside one disk of 
the R1 with my existing data,
and use on of the old disks, along with the new one, to create the R10 ?


I believe the way to accomplish this is as follows:

Set aside (disconnect) 1 of the existing 2 disks.
Boot from emergency recovery media, making sure the md version is 
relatively current ( newer than 3.0 ?)

Create the R10 with the other 2 disks ( 1 old and 1 new) with 1 of the 3 
disks missing.
I think I have to wipe the superblock on the disk that was formerly part 
of the RAID1 set.

Reconnect the old R1 reserved disk.
Copy the data from the single member of the old R1 to the new R10
On the old disk of the R1 set wipe the superblock.
Lastly add the 3rd disk to the R10 set.
Run grub to put the boot block on all 3 of the disks.
Assuming that this sequence is correct, what I need now is the correct 
syntx for these steps.

Or, perhaps, I have it wrong!

-- 
Cheers,
Maurice Hilarius
eMail: /mhilarius@gmail.com/
