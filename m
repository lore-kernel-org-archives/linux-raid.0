From: "Mark Cuss" <mcuss@cdlsystems.com>
Subject: Re: RAID - mdadm Help. (Newbie in Linux)
Date: Thu, 16 Jun 2005 13:02:12 -0600
Message-ID: <00ec01c572a5$e7407a60$ab0e10ac@pinchy>
References: <20050616183235.RLBV1725.tomts27-srv.bellnexxia.net@i8600>
Reply-To: "Mark Cuss" <mcuss@cdlsystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: pluk@impressio.ca, cknowlton@science.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You need to make the filesystem on your new /dev/md0 device...  You have 
many choices as to which filesystem to use, but ext3 is the most common in 
Linux.

Doing a mkfs.ext3 /dev/md0 should do the trick.  All of the parameters are 
listed in the man page for mkfs / mkfs.ext3.

This is the same as formatting a disk under Windows - all data is torched 
from that device, so make sure there isn't already a filesystem or valuable 
data on it.  If you've just made the RAID device, then there won't be.

To automount it, add a line to fstab...  You've got it essentially right 
with the line you have below....  If you choose to use ext3 as the 
filesystem, just change vfat to ext3.

Mark

----- Original Message ----- 
From: "Patrick Luk" <pluk@impressio.ca>
To: <cknowlton@science.edu>
Cc: <linux-raid@vger.kernel.org>
Sent: Thursday, June 16, 2005 12:32 PM
Subject: RE: RAID - mdadm Help. (Newbie in Linux)


> Sorry to say this,  but since I'm new to the Linux world, I've followed 
> few
> steps but can't get it mounted and to be used on Samba. Bascially trying 
> to
> make a simple SOHO server inraid for file system.
>
> 1) I might have made few errors on Druid disk at the beginning of the
> installation (I will redo tonight - I think I've found a good doc to help)
>
> 2) Regardless of the above, this is what I did...
>
> mdamd --create --verbose /dev/md0 --level1 --raid-devices=2
> /dev/sda1 /dev/sdb1
> cat /proc/mdstat (it said compeled pretty quickly since I,ve
> made partitions of 5 gigs out of both 250 gig sata drives for raid 
> purpose.
> The main drive is for the OS, these 2 are extra storage.)
> Tried to configure automount but don't know how (vi
> /etc/fstab adding /dev/md0 /home vfat defaults 1 2).
>
> I think I'm missing a step in filesystem they say on some
> doc...
> "Now, you can create a filesystem, just like you would on
> any other device, mount it, include it in your /etc/fstab and so on." What
> are the procedures ???
>
> Thanks for reading my question. Can you help you think?
>
>
>
>
> -----Original Message-----
> From: Carlos Knowlton [mailto:cknowlton@update.fsix.com]
> Sent: June 16, 2005 2:14 PM
> To: pluk@impressio.ca
> Cc: linux-raid@vger.kernel.org
> Subject: Re: RAID - mdadm Help. (Newbie in Linux)
>
> Need more data.  What problems are you having?
>
>
> I had a little difficulty getting used to the new syntax of the mdadm
> utility after using the old raidtools pkg on the 2.2 and 2.4 kernel.
> However, after studying the  man pages for  mdadm(8) and mdadm.conf(5)
> (glossing over them didn't help me much, there is a lot of important 
> detail
> there!), I finally got the hang of it.  mdadm is a powerful tool!  I've
> grown to really like it.  (after my growing pains, that is :)
>
>
> Regards,
> Carlos
>
> Patrick Luk wrote:
>
>>Hi there,
>>
>>    I'm trying to setup a raid system using RedHat Enterprise ES 4.
>>I've looked through alot of web info and still can't make it work. Any
>>where I can get some help on how-to do this and make it work consistenly?
>>
>>    Thanks!
>>
>>Patrick
>>
>>-
>>To unsubscribe from this list: send the line "unsubscribe linux-raid"
>>in the body of a message to majordomo@vger.kernel.org More majordomo
>>info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


