From: Daniel Santos <daniel.dlds@gmail.com>
Subject: Re: problem killing raid 5
Date: Mon, 01 Oct 2007 19:20:27 +0100
Message-ID: <47013A6B.30302@gmail.com>
References: <4700D454.7020607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4700D454.7020607@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I retried rebuilding the array once again from scratch, and this time 
checked the syslog messages. The reconstructions process is getting 
stuck at a disk block that it can't read. I double checked the block 
number by repeating the array creation, and did a bad block scan. No bad 
blocks were found. How could the md driver be stuck if the block is fine ?

Supposing that the disk has bad blocks, can I have a raid device on 
disks that have badblocks ? Each one of the disks is 400 GB.

Probably not a good idea because if a drive has bad blocks it probably 
will have more in the future. But anyway, can I ?
The bad blocks would have to be known to the md driver.


Daniel Santos wrote:
> Hello,
>
> I had a raid 5 array on three disks. Because of a hardware problem two 
> disks dissapeared one after the other. I have since been trying to 
> create a new array with them.
>
> Between the degradation of the two disks I tryied removing one of the 
> failed disks and re-adding it to the array. When the second disk 
> failed I noticed the drive numbers on the broken array, and 
> misteriously a fourth drive appeared on it. Now I have numbers 0,1 and 
> 3, but no number 2.
> mdadm tells me that number 3 is a spare.
>
> Now I want to start all over again, but even after zeroing the 
> superblocks on all three disks, and creation of a new array, 
> /proc/mdstat shows the same drive numbers, while reconstructing the 
> third drive.
> What should I do ?
>
> Daniel Santos
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

