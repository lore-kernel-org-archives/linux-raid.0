From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: Manually fail a disk?
Date: Mon, 20 Jan 2003 11:46:05 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D56E@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'Robert L. Harris'" <Robert.L.Harris@rdlg.net>, Derek Vadala <derek@cynicism.com>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Robert,

I'm not surprised that raidsetfaulty and raidhotremove wouldn't do the job,
that's why mdadm is needed.  

Andy

-----Original Message-----
From: Robert L. Harris [mailto:Robert.L.Harris@rdlg.net] 
Sent: Sunday, January 19, 2003 4:09 PM
To: Derek Vadala
Cc: Linux-Raid
Subject: Re: Manually fail a disk?




raidsetsetfaulty gave back an error (scrolled off the screen and the
machine has since seized up.  raidhotremove pretty much hung up trying
to get disk access.  I was hoping I could tell the kernel or the md
driver to mark it bad and take it out of the array.


Thus spake Derek Vadala (derek@cynicism.com):

> >   I've got a disk that's starting to fail hard.  It's generating alot of
> > errors in dmesg and /var/log/messages.  If the raid disk gets any usage
> > it'll lock up the box it's spewing errors so fast.  I can't get out to
> > physically yank the disk until Tues but need it off-lined now.  Is there
> > a way to tell mdtools (version 0.42-33) to mark a disk faulty and not
> > use it?
> 
> I'll assume this is a RAID-1 or RAID-5 and that you're not trying this on
> a non-redundant array...
> 
> 
> # mdadm /dev/md0 --fail /dev/sda1
> # mdadm /dev/md0 --remove /dev/sda1
> 
> The first command fails /dev/sda1 (a member of /dev/md0) and the second
> command removes it from /dev/md0.
> 
> If you are using raidtools try:
> 
> # raidsetfaulty /dev/md0 /dev/sda1
> # raidhotremove /dev/md0 /dev/sda1
> 
> --
> Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



:wq!
---------------------------------------------------------------------------
Robert L. Harris                     | PGP Key ID: FC96D405
                               
DISCLAIMER:
      These are MY OPINIONS ALONE.  I speak for no-one else.
FYI:
 perl -e 'print $i=pack(c5,(41*2),sqrt(7056),(unpack(c,H)-2),oct(115),10);'

