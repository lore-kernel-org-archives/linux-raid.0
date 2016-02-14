From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Questions
Date: Sun, 14 Feb 2016 17:34:51 +1100
Message-ID: <56C0200B.8030606@websitemanagers.com.au>
References: <CAPpdf58O+=Re1dBe1Rmj7jb=9iJkMZZBuZfEX4S32wMXcv6uWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPpdf58O+=Re1dBe1Rmj7jb=9iJkMZZBuZfEX4S32wMXcv6uWQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: o1bigtenor <o1bigtenor@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 14/02/2016 15:28, o1bigtenor wrote:
> Greetings
>
> My raid 10 array was the subject of a number of exchanges on this
> board a few months ago.
> With the generous assistance of members here things were reestablished
> and have been working well. Today I had a VirtualBox VM crater and in
> the process cause other system issues. In process to clear the mess a
> number of hard stops (shutting the system off using the button on the
> case) were used. In rebooting I found that one of the drives in the
> array is no longer responding issuing a number of clicks in the boot
> up process with nothing else happening. Even though it is a RAID 10
> array the array is no longer mounted nor available. I have removed the
> faulty drive already. I have an appropriately sized drive available
> that I could place into the machine.
>
> 1. should I reformat the drive (to be placed into the machine)?
> 2. what sequence of commands should I be using for this new drive to
> be included into the array?
> 3. what sequence of commands should I use to remount the array?

First thing I would suggest is to let everyone know the status of the 
current array, and how to get it working.

Can you send the output of cat /proc/mdstat and mdadm --misc --detail 
/dev/md?

Assuming the existing array is in a "normal" status, albeit degraded, 
then it should be pretty simple to just partition the new drive to match 
the other members, and then simply add the new partition to the array 
(mdadm --manage /dev/md? --add /dev/sdxy)

Try to take things slowly, as doing the wrong thing might make a simple 
recovery into a very sad event (loss of all the data).

Regards,
Adam

Regards,
Adam
