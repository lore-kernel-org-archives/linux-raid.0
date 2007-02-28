From: jahammonds prost <gmitch64@yahoo.com>
Subject: Re: trouble creating array
Date: Wed, 28 Feb 2007 13:26:06 -0800 (PST)
Message-ID: <80117.11551.qm@web55812.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jahammonds prost <gmitch64@yahoo.com>, Neil Brown <neilb@suse.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So anyways, I created my RAID device, and waited about 4 hours for it to sync, and all was happy with the world, so I went to bed. This morning, I made an ext3 file system on it, set up some directories, set the acls, added to my smb.conf file, mapped a drive, and after about 4Gb copied onto it, I got an error. Checking in the logs, there was an error about trying to access past the physical extent.

I did a quick check of mdstat, and one of the array disks was down, and an dm device had shown up in the array configuration. A quick dmsetup -C info again shows that mpath0p1 has returned again.

Does anyone know why it keeps appearing, and more importantly, is there any way of persuading it not to...?

Thanks again for any help and pointers people can give...


Graham


----- Original Message ----
From: jahammonds prost <gmitch64@yahoo.com>
To: Neil Brown <neilb@suse.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>; linux-raid@vger.kernel.org
Sent: Tuesday, 27 February, 2007 8:10:36 PM
Subject: Re: trouble creating array


Just an update for everyone on this (and for the archives), Did some digging, and had a look at the device mapper config

# dmsetup -C info

Name             Maj Min Stat Open Targ Event  UUID
mpath0           253   0 L--w    1    1      0 
VolGroup00-LogVol01 253   3 L--w    1    1      0 LVM-2sahQifzg9s9k0xSkpnzpGCYd7JNVXzUof6XmQ0fhzJ6jIbQLciAbm6lJLwK0Aex
VolGroup00-LogVol00 253   2 L--w    1    1      0 LVM-2sahQifzg9s9k0xSkpnzpGCYd7JNVXzUt3sJ3nwvJF8cr6ebv5AdnY0j4Ajl6U0I
mpath0p1         253   1 L--w    0    1      0 


Those 2 multipath devices shouldn't have been there, and indeed mpath0p1 were my 2 recalcitrant disks.

# dmsetup -C remove mpath0p1
# dmsetup -C remove mpath0

And they were both gone (you need to start at the bottom of the tree when removing them).

A quick fdisk of my disks to create sdb1 and sdc1 partitions, and my array will be synched in 204 mins...:)

Thanks to everyones help for pointing me in the right direction.. It was a trip I would have preferred not to have made, but like all trips like that, it's been illuminating.

Thanks again.


Graham



----- Original Message ----
From: Neil Brown <neilb@suse.de>
To: jahammonds prost <gmitch64@yahoo.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>; linux-raid@vger.kernel.org
Sent: Sunday, 25 February, 2007 11:40:26 PM
Subject: Re: trouble creating array


On Sunday February 25, gmitch64@yahoo.com wrote:
> 
> 
> Any ideas how to find out what has it open? I can happily write all over the disk with dd... I can create and delete the partition, and it's all good... I will try deleting the sd{b,c}1 partitions, reboot, and see what happens.
> 

ls -l /sys/block/*/holders/* ??

NeilBrown


    
    
        
___________________________________________________________ 
New Yahoo! Mail is the ultimate force in competitive emailing. Find out more at the Yahoo! Mail Championships. Plus: play games and win prizes. 
http://uk.rd.yahoo.com/evt=44106/*http://mail.yahoo.net/uk 
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


		
___________________________________________________________ 
Copy addresses and emails from any email account to Yahoo! Mail - quick, easy and free. http://uk.docs.yahoo.com/trueswitch2.html
