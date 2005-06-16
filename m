From: "Patrick Luk" <pluk@impressio.ca>
Subject: RE: RAID - mdadm Help. (Newbie in Linux)
Date: Thu, 16 Jun 2005 14:32:37 -0400
Message-ID: <20050616183235.RLBV1725.tomts27-srv.bellnexxia.net@i8600>
References: <42B1C15C.7080801@update.fsix.com>
Reply-To: <pluk@impressio.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42B1C15C.7080801@update.fsix.com>
Sender: linux-raid-owner@vger.kernel.org
To: cknowlton@science.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry to say this,  but since I'm new to the Linux world, I've followed few
steps but can't get it mounted and to be used on Samba. Bascially trying to
make a simple SOHO server inraid for file system.

1)	I might have made few errors on Druid disk at the beginning of the
installation (I will redo tonight - I think I've found a good doc to help)

2)	 Regardless of the above, this is what I did...

		mdamd --create --verbose /dev/md0 --level1 --raid-devices=2
/dev/sda1 /dev/sdb1
		cat /proc/mdstat (it said compeled pretty quickly since I,ve
made partitions of 5 gigs out of both 250 gig sata drives for raid purpose.
The main drive is for the OS, these 2 are extra storage.)
		Tried to configure automount but don't know how (vi
/etc/fstab adding /dev/md0 /home vfat defaults 1 2). 

		I think I'm missing a step in filesystem they say on some
doc... 
		"Now, you can create a filesystem, just like you would on
any other device, mount it, include it in your /etc/fstab and so on." What
are the procedures ???

	Thanks for reading my question. Can you help you think?


	

-----Original Message-----
From: Carlos Knowlton [mailto:cknowlton@update.fsix.com] 
Sent: June 16, 2005 2:14 PM
To: pluk@impressio.ca
Cc: linux-raid@vger.kernel.org
Subject: Re: RAID - mdadm Help. (Newbie in Linux)

Need more data.  What problems are you having?


I had a little difficulty getting used to the new syntax of the mdadm
utility after using the old raidtools pkg on the 2.2 and 2.4 kernel. 
However, after studying the  man pages for  mdadm(8) and mdadm.conf(5)
(glossing over them didn't help me much, there is a lot of important detail
there!), I finally got the hang of it.  mdadm is a powerful tool!  I've
grown to really like it.  (after my growing pains, that is :)


Regards,
Carlos 

Patrick Luk wrote:

>Hi there,
> 
>    I'm trying to setup a raid system using RedHat Enterprise ES 4. 
>I've looked through alot of web info and still can't make it work. Any 
>where I can get some help on how-to do this and make it work consistenly?
> 
>    Thanks!
> 
>Patrick
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" 
>in the body of a message to majordomo@vger.kernel.org More majordomo 
>info at  http://vger.kernel.org/majordomo-info.html
>  
>



