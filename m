From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Linux RAID setup
Date: Sat, 9 Oct 2004 22:37:47 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16743.56219.900975.111562@cse.unsw.edu.au>
References: <20041009122106.650.qmail@web60410.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Poonam Dalya on Saturday October 9
To: poonamsbox@yahoo.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday October 9, poonamsbox@yahoo.com wrote:
>  
>  3. Then I worrked with the following command.
>        I got the following error.
>  
>  bash2-2.05b# mdadm --create /dev/md0 --level=0
>  --chunk=128 --raid-disks=2 /dev/hda5 /dev/hda4
>  mdadm: /dev/hda5 appears to contain an ext2fs file
>  system size=10241404K  mtime=Sat Oct  9 17:06:24 2004
>  Continue creating array? y
>  mdadm: ADD_NEW_DISK for /dev/hda5 failed: Invalid
>  argument

Are there any messages from the kernel at this time.  
The command
   dmesg

would show them..

However my guess is that you only recently created these partitions.
You might need to reboot before they are recognised.

>  
>  --------------------------------------------------
> 
>  4. When i again tried with that command, it showed
>  the following error.
>  
>  bash2-2.05b# mdadm --create /dev/md0 --level=0
>  --chunk=128 --raid-disks=2 /dev/hda5 /dev/hda4
>  mdadm: /dev/hda5 appears to contain an ext2fs file
>  system size=10241404K  mtime=Sat Oct  9 17:06:24 2004
>  Continue creating array? y
>  mdadm: SET_ARRAY_INFO failed for /dev/md0: File
>  exists

Yes, you need to stop the array
  mdadm --stop /dev/md0
because it is half-created.  But a reboot will achieve the same
effect.

>  
>         Please if you could solve my problem, it
>  would be of very great help for me. I have a deadline
> as sunday and today is saturday. So, sir please do
>  reply.
>          Thank you.

If the above doesn't help, send us the complete output
of 
   dmesg
immediately after failing to create the array.

NeilBrown
