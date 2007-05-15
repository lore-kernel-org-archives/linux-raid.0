From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: how to synchronize two devices (RAID-1, but not really?)
Date: Tue, 15 May 2007 12:36:36 +0200
Message-ID: <46498D34.1060901@wpkg.org>
References: <4649760A.1060805@wpkg.org> <17993.34959.150157.200536@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17993.34959.150157.200536@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown schrieb:

(...)

> You will want to test this of course - I cannot guarantee that I have
> that command exactly right.
> 
> If the remote device fails (link breaks) it should get marked faulty
> in the array.  Once you have it working again you can use mdadm to
> remove (--remove) and re-add (--re-add) the device.  It should
> complete the copy correctly.   You should test that this actually
> works as expected. 
> 
> Feel free to ask questions if you choose to attempt this route.

Interesting lecture, thanks a lot. I'm gonna take that path.

I have one more question, though.

I want to migrate:
- from 4x400GB HDD RAID-10
- to 4x400GB HDD RAID-5

Obviously, I need 8 disks for that, but I have only 6.

So my idea was to kick one disk from RAID-10, and use it for RAID-5 for 
the time of migration.

This means, I would have only 3 disks out of 4 in RAID-5 array.


Is it possible to create a degraded, 4 disk RAID-5 array with just 3 
drives? I would add the 4th drive once migration from RAID-10 is done.


(I'm aware of the risks - that my degraded RAID-10 will be "vulnerable" 
during the migration).


-- 
Tomasz Chmielewski
http://wpkg.org
