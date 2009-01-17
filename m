From: Iain Rauch <groups@email.iain.rauch.co.uk>
Subject: Re: RAID 6 recovery (it's not looking good) *Even More problems*
Date: Sat, 17 Jan 2009 14:10:57 +0000
Message-ID: <C5979771.C0E4%groups@email.iain.rauch.co.uk>
References: <921ca19c0901170547u57f394d9kd7b9a736bc57da67@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <921ca19c0901170547u57f394d9kd7b9a736bc57da67@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sujit Karataparambil <sjt.kar@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


>> After cloning the partition of the 1.5TB disk to a replacement 500, it
>> wouldn't assemble as it had a different UUID.
> 
> Is this new Drive 500TB of data.
> 
I cloned a failing 500GB drive to 1.5TB drive using dd rescure and then to
clone it back to a 500GB drive I dd'd the partition because it was a smaller
drive.
>> 
>> So I tried assembling with assume clean and the first time I got
>> mount: /dev/md0: can't read superblock
> 
> How did you copy the super block.
> 
Not sure what you mean there? Which superblock?
>> 
>> So I tried a different order and got
>> mount: Structure needs cleaning
>> 
>> And then trying the first order again I got
>> mdadm: failed to open /dev/sdp1 after earlier success - aborting
> 
> did you run fsck after booting you could set up that.
> 
> http://www.cyberciti.biz/faq/linux-force-fsck-on-the-next-reboot-or-boot-seque
> nce/
Not sure why this will be helpful? There's not an independent file system on
each md device is there?


Iain


