From: Dark Penguin <darkpenguin@yandex.ru>
Subject: Re: md failing mechanism
Date: Sat, 23 Jan 2016 00:44:35 +0300
Message-ID: <56A2A2C3.9000801@yandex.ru>
References: <56A26E11.2090703@yandex.ru> <56A28309.9080806@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56A28309.9080806@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Oh! Thank you! I really wanted to see a reliable "what's supposed to 
happen" sequence!

As for my case, those were indeed, um, "cheap desktop drives" - to be 
precise, some 80-Gb IDE drives in a Pentium-4 machine; "it works well 
for a small file server", I thought, oblivious to the finer details 
about the process of failure handling... But, I also have "big" file 
servers, so that timeout mismatch issue is something worth paying attention!

And also, now I understand why I probably "should have been scrubbing". 
=/ Do I understand correctly that "scrubbing" means those "monthly 
redundancy checks" that mdadm suggests? And I suppose what it does is 
just the same - read every sector and attempt to write it back upon 
failure, otherwise kicking the device?


So, I understand a common problem now: the read timeout on the "desktop" 
drives is too long, which makes sense for the desktops, but not for 
RAIDs, because the "write back attempt" fails and leads to "BOOM" and 
kick. Enterprise-grade drives, however, offer an option to change their 
timeout, which is called "TL;DR technology" (yes, that's how I'm going 
to call it! Because I can't remember the acronym no matter how may times 
I read it, and the meaning kinda fits!). And what about drives that do 
not support it?.. Do they even have some kid of huge timeout or 
something?.. Yesterday I've been checking one drive for bad blocks 
(badblocks read-only test), and it took no more than two seconds per 
block to confirm its... badness!

As I understand, one way around this problem is to change the kernel 
timeout to exceed the drive timeout by changing 
/sys/block/sd?/device/timeout to something larger than the default 30, 
but I'd have to do that after every reboot, is all that correct?


Still, I don't think it has anything to do with what has happened to my 
"small file server"... It was the opposite; for some reason, it was not 
kicked from the array. But, it happened a while ago, and I've destroyed 
the array afterwards, so I can't get any more data about that incident. 
But, I've got what I wanted: I now I know what is supposed to happen 
when a drive in a RAID fails, and it's not what happened that time. And 
I know I should set up proper TL;DR timeouts and scrubbing...


-- 
darkpenguin
