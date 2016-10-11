From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: growing a RAID-10 array with mdadm 3.3.1+ ?
Date: Tue, 11 Oct 2016 19:29:26 +0100
Message-ID: <a09a7ce1-8adf-e00c-7787-eb7ccc1a9e63@youngman.org.uk>
References: <1476206815.989242.752665505.6525EE00@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1476206815.989242.752665505.6525EE00@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: moft@fmailbox.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Okay, this is a first response, so you'll probably need more experienced 
people to chime in, but

FIRST - BACKUP BACKUP!! BACKUP!!!!

Growing an array is pretty safe, but like anything here, it does have 
its dangers.

Second, what distro are you running? Is it a systemd-based distro?

There are a few problems with resizing arrays at the moment, and my gut 
feeling is that systemd is "to blame". It's very unlikely you'll lose 
data, but you might well find the resize fails and you have copy to a 
new array anyway.

More notes inline ...

On 11/10/16 18:26, moft@fmailbox.com wrote:
> Hi
>
> I have a 4-disk RAID10 array
>
> 	md0 : active raid10 sda1[4] sdb1[3] sdc1[2] sdd1[1]
> 	      1953259520 blocks super 1.2 512K chunks 2 far-copies [4/4] [UUUU]
> 	      bitmap: 0/15 pages [0KB], 65536KB chunk
>
> It was created with this command
>
> 	mdadm --create /dev/md0 --level=raid10 --raid-devices=4 \
> 	 --name=md0 --homehost="<none>" \
> 	 --metadata=1.2 --bitmap=internal --layout=f2 --chunk=512  \
> 	 /dev/sd[abcd]1
>
> It's running on a linux machine
>
> 	uname -rm
> 		4.8.1-2.g4861355-default x86_64
> 	mdadm --version
> 		mdadm - v3.3.1 - 5th June 2014
>
> I need to add storage to the array.
>
> I'd like to grow it by adding two disks (/dev/sd[ef]), to end up with a 6-disk array.
>
> I know I can completely wipe it out and recreate it with 6-disks.
>
> But I'd rather grow/extend it, Instead.
>
> *CAN* I safely grow/expand it?

Bugs excepted - yes you should be able to, without problems.
>
> The ChangeLog for mdadm 3.3.1 says
>
> 	Changes Prior to release 3.3
> 	- Some array reshapes can proceed without needing backup file.
> 	  This is done by changing the 'data_offset' so we never need to write
> 	  any data back over where it was before.  If there is no "head space"
> 	  or "tail space" to allow data_offset to change, the old mechanism
> 	  with a backup file can still be used.

If you're growing the array, you shouldn't need a backup file. You might 
need a backup for the first second or so, but then it's no longer 
necessary. And mdadm can probably use the space in the two new disks to 
store the backup data.

(What I understand happens, is that mdadm will read old stripes 1 & 2. 
It then writes new stripe 1 and sets the watermark to stripe 1. That 
says that the new array is complete up to 1, and if the data isn't 
there, fetch it from the old array. It then reads old stripe 3 and 
writes new stripe 2, then sets the watermark to 2. Old 4 & 5 become new 
3, then old 6 makes new 4. Etc etc. Plus, of course, all the locking and 
safeguards to make sure nothing reads the stripe that's actively being 
updated ... :-)

Anyways, if it needs a backup file, it will tell you.

> 	- RAID10 arrays can be reshaped to change the number of devices,
> 	  change the chunk size, or change the layout between 'near'
> 	  and 'offset'.
> 	  This will always change data_offset, and will fail if there is no
> 	  room for data_offset to be moved.
>
> So far I haven't found any specific "how to" for this process.

mdadm /dev/md0 --add /dev/sde1 /dev/sdf1
mdadm --grow /dev/md0 --raid-devices=6

The first command will add your two drives as spares. The second will 
make them part of the array. It's the second command that's the risky 
one... and bearing in mind I don't know raid10, it might just add them 
on the end and not need any reconstruction at all ...
>
> (1) The changelog refers to 'near' and 'offset' layouts, but doesn't mention 'far'.
>
> CAN I safely grow this layout=f2 array ?
>
> (2) If I can, what's the detailed procedure to do it?
>
I'll be interested in knowing how this pans out, too, so I can add it to 
the wiki :-)

Cheers,
Wol
