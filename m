From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: Converting system to raid
Date: Sat, 11 Apr 2009 11:47:39 -0700
Message-ID: <007001c9bad6$2525c610$0a00a8c0@vorg>
References: <003801c9b96d$21a0f420$0a00a8c0@vorg> <49DF0D06.8030705@musmo.com> <20090410195303.GB21242@cthulhu.home.robinhill.me.uk> <00cc01c9ba1d$3aefecf0$0a00a8c0@vorg> <20090410205942.GC21242@cthulhu.home.robinhill.me.uk> <00f301c9ba23$032025f0$0a00a8c0@vorg> <20090410215129.GD21242@cthulhu.home.robinhill.me.uk> <019701c9ba66$aeed5630$0a00a8c0@vorg> <f19d625d0904110729y30e8bc80m41fcd8f2c3298d49@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yes, the default setup. But that is because the supplied kernel builds raid as modules. I build a new kernel with stuff needed for
my system ecept for dvb stuf which I get by building v4l tree to get newest drivers. And I build raid into the kernel. Since I
havn't needed ramdisk for anything up till now and you are not suposed to need it when raid is built it, ramdisk is not compiled in
or as a module.

----- Original Message ----- 
From: "CoolCold" <coolthecold@gmail.com>
To: "Timothy D. Lenz" <tlenz@vorgon.com>
Cc: <linux-raid@vger.kernel.org>
Sent: Saturday, April 11, 2009 7:29 AM
Subject: Re: Converting system to raid


On Sat, Apr 11, 2009 at 9:29 AM, Timothy D. Lenz <tlenz@vorgon.com> wrote:
> From: "CoolCold" <coolthecold@gmail.com>
>
>> Yes, he should provide correct /etc/mdadm/mdadm.conf and
>> update-initramfs -u on md boot, smth like
>> chroot /mnt/md0
>> update-initramfs -u
>
> How would this help in a system that doesn't ramdisk built in to the kernel or as a module? Or does it change some other stuff?
Looking into "I have 2 computers that I am trying to convert to raid.
Both where setup with debian netinst cd to hda" - debian has initrd
support within their kernels.
>
>
> I started looking at the stuff that was copied to md0 and /md0/dev is empty. Looking through the guides I found a few things. One
> said that using cp had to be from root or not everything would get coppied. I used sudo but I know some things require you to
root.
> Also this:
> ===============================
> # rsync -avHhx --progress / /mnt/raid-md0
>
> * If the system wasn't previously in single user mode, move to single user mode and update the data that changed during the
> first copy:
> (--delete flag tells rsync to delete files from the destination which do not exist on the source):
>
> # rsync -avHhx --progress --delete / /mnt/raid-md0
>
> * Create needed device nodes:
>
> # cd /mnt/raid-md0/dev/ && MAKEDEV generic
> ===============================
> Using rsync from single user mode still left /mnt/md0/dev empty. I read up in "makedev generic" and it seems to be a shotgun fix
> adding way more then is needed. Is there a way to create just what is in /dev?
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>



-- 
-- 
Best regards,
[COOLCOLD-RIPN]

