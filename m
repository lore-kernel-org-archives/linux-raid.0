From: Luca Berra <bluca@comedia.it>
Subject: Re: Firewire RAID bootparameters?
Date: Sat, 13 Dec 2003 13:14:48 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031213121447.GA5975@percy.comedia.it>
References: <20031213111947.99239.qmail@mail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20031213111947.99239.qmail@mail.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Dec 13, 2003 at 06:19:47AM -0500, Christer Backstrom wrote:
>Yes, this is new information for me. I never considered (or knew how
>to) manipulate the initrd loading. I got two more mails saying about
>the same thing, but they weren't cc:ed to the list. (Thanks Joe Pruett
>and David Haring) This would enable me to put even my root-filesystem
>on the firewire drive. Very nice. In my case, as I only keep my /home
>on the raid1 mirror, it was even simpler. I looked into the initrd man
>page, and found  a reference to append "noinitrd" to lilo.conf, which
>stops loading of modules by initrd altogether. The rc.sysinit will
>then, in my case (Mandrake-9.2), load the modules in the right order. I
>stiil wonder if the loading sequence should not be different when
>loading compiled-in modules. Nowadays firewire and usb2 drives are fast
>and commonplace, and an excellent way of securing the regular
>harddrive. Especially on a laptop, where the regular drives are small
>and singular. To load the raid subsystem before these systems can't be
>right. I wonder if i t should not be changed? Anyways: Me happy. Thanks
>all for the help!

uhm, you should not need to modify the initrd scripts by hand to make it
do what you need, (and mdk-9.2 initrd should not load raid modules if it
does not need it to boot, but this i already fixed).
having a correct scsi_hostadapter line in /etc/modules_conf should deal
with loading the firewire module before, or you could use --preload
<module> argument.
i don't have firewire hw to test this, and i'll never buy an usb drive
if i can avoid it :-)
would you be willing to test the alternative mkinitrd/initscripts/mdadm
packages i built for mandrake cooker and report success/failure on your
configuration?
they are found at: http://www.comedia.it/~bluca/cooker/lvm2/

Regards,
L.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
