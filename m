From: Mauricio <raub@afn.org>
Subject: Re: raid is read-only? (debian/sarge)
Date: Fri, 26 Mar 2004 08:15:18 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <a06002007bc89dae1b559@[10.0.0.10]>
References: <a06002005bc89ce38bb27@[10.0.0.10]>
 <Pine.LNX.4.56.0403261224250.14553@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0403261224250.14553@lion.drogon.net>
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

At 12:32 +0000 3/26/04, Gordon Henderson wrote:
>On Fri, 26 Mar 2004, Mauricio wrote:
>
>>	I have 2 120GB IDE drives in the second IDE controller of a
>>  P4 debian/sarge box that I would like to set up as a raid1 array.
>>  Using info from the following links,
>
>Are you aware that using 2 disks on the same controller is generally
>regarded as a "bad thing"[tm]?
>
>I had personally lost access to a 2nd drive when one drive on the same bit
>of cable failed. Fortunately in my case, I didn't lose data on the good
>drive, but I wasunable to access it until I powered the PC down and
>removed the failed drive.
>
>Read the paragraph under "Fault Survival" at:
>
>   http://en.tldp.org/HOWTO/Software-RAID-HOWTO-4.html
>
>I'm sure you know this... Just checking....

	Actually, I was not aware of that.  Thanks for scaring me! =)

That said, hopefully this setup will not stay long like that; it is 
almost a validation/test setup.

>  > <after rebooting...>
>>  laurel:/# mount -o rw /dev/md0 /mnt
>
>Looks like you forgot to mkfs the new md0 device..

	I did forget that indeed!  Thanks!  Now all is well. =)
