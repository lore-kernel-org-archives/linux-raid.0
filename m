From: junk@non-creative.com
Subject: failed raid5, how to reconstruct?
Date: Mon, 1 Dec 2008 17:05:06 -0500
Message-ID: <3784296.11228169106138.JavaMail.root@wombat.diezmil.com>
Reply-To: junk@non-creative.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi everybody,

to begin with: I can create raids in linux but that is about it. I am quite inexperienced.

I had created a raid5 setup of which one drive failed. This resulted in a degraded setup. After this happend it continued to work for a while afterwards (not recommended but no possiblity to replace the drive)

After a while the whole md0 stopped working and upon rebooting I get an error that I cannot mount md0 because there is something wrong with the superblock.

I tried to reconstruct the raid by building a new raid5, this didn't help very much. I did not recreate the filesystem as I thought this would destroy the information on that disk. Using some software I did see that most data was still available on the disk, but not in the right way (windows system with a raid recovery tool on another disk)

How can I reconstruct the raid5 in such a way that I can copy all information off the disk? Can anyone please tell me how? or point me to a beginners tutorial / wiki? 

thanks!

--
This message was sent on behalf of junk@non-creative.com at openSubscriber.com
http://www.opensubscriber.com/messages/linux-raid@vger.kernel.org/topic.html
