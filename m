From: "bo" <bo@sosnetwork.net>
Subject: Re: Creating failed-mode RAID1 with mdadm
Date: Tue, 30 Apr 2002 15:28:47 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <07de01c1f096$64e822a0$6501a8c0@bomoon>
References: <20020430184832.GA381@willow.seitz.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Ross Vandegrift <ross@willow.seitz.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Try with
# mdadm --create /dev/md0 --level 1 --raid-disks=2 /dev/hde1 missing

It will work.


----- Original Message ----- 
From: "Ross Vandegrift" <ross@willow.seitz.com>
To: <linux-raid@vger.kernel.org>
Sent: Tuesday, April 30, 2002 11:48 AM
Subject: Creating failed-mode RAID1 with mdadm


> Hey everyone,
> 
> Creating a new array today, I decided I should probably start
> using mdadm instead of the old tools.  I've been using it a bit at home
> to do minor things, and it seemed nice.
> I've got a box with two 20G ide drives installed.  One is
> currently the root drive at /dev/hda1 and the other is one of the disks
> for the mirrored pair at /dev/hde1.  I'm trying to create the array with
> /dev/hdg1 as a failed disk, and then move /dev/hda to /dev/hde after I
> start booting the machine off of /dev/md0.
> When I do:
> 
> # mdadm --create /dev/md0 --level 1 --raid-disks=2 /dev/hde1 /dev/hdg1
> 
> I get:
> 
> mdadm: Cannot open /dev/hdg1: No such device or address
> mdadm: create aborted
> 
> This makes sense, as /dev/hdg doesn't really exist yet.  I've tried
> doing:
> 
> # mdadm --set-faulty /dev/md0 /dev/hdg1
> 
> but it doesn't seem to help.  How can I build an array like this via
> mdadm?
> 
> Ross Vandegrift
> ross@willow.seitz.com
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

