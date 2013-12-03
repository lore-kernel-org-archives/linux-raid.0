From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Growing array, duplicating data, shrinking array questions.
Date: Wed, 04 Dec 2013 09:36:13 +1100
Message-ID: <529E5CDD.9030702@websitemanagers.com.au>
References: <BLU0-SMTP1655B70AE4DF50100E9817198E10@phx.gbl>	 <BLU0-SMTP228AF830EE9F7252DAE2AFF98E80@phx.gbl> <BLU0-SMTP122E4AB9F76CD51C2F7AD5A98D50@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP122E4AB9F76CD51C2F7AD5A98D50@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Wilson Jonathan <piercing_male@hotmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/12/13 05:15, Wilson Jonathan wrote:
>> Now here is where I know/think I have a big problem with a 3tb drive in
>> a "bios" system and need confirmation before going any further...
>>
>> ___question 2___
>> I'm guessing that as the bios can only see the tail end of the hard
>> drive it would not be able to load the data from the "mbr" (still there
>> despite being a GPT formatted disk) and proceed to load the first stage
>> boot loader because it will think the "mbr" should be at the start of
>> the "700GB" which in reality is 2.2TB into the disk, would this be a
>> correct assumption? (
>>
>> Actually I could probably test this by installing
>> (grub-install /dev/sdX) then going into the bios and telling it to boot
>> from that disk while the original boot drives (containing
>> biosboot /boot /root) were still pluged in, if it failed then I know its
>> not going to work.
> I've concluded that I'm going to have to create some form of work around
> as the bios cannot load the mbr from the 3tb drive, and then the grub2
> stuff in the bios boot partition which can then load additional grub2
> stuff from the /boot partition.

I don't know why you seem to have an issue here... IME (limited), the 
only thing I had to do was create a small 1M partition at the beginning 
of the disk, from memory the OS installer did this automatically for me. 
Then grub can get installed to the drive and it all works magically. I'm 
really not sure of all the technical details, and I can't actually find 
the machine I did this on right now, but I do remember that is how I 
made it work.....

BTW, I'd suggest that if grub can "see" the partitions/etc properly, 
then just install grub to the USB, and leave the kernel/initrd/etc on 
the raid on the hard drives. Keep a image of the USB (or at least the 
first few MB that grub is using), so if the USB dies you can boot from a 
live CD, mount the hard drives, and use dd to write the grub image to a 
new USB.

Personally, I'd try and get grub working from the HDD, I don't like to 
find out that I have a problem *after* a reboot for either an upgrade or 
as part of recovering from another problem.

Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
