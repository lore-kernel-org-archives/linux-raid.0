From: Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH] need read reshape_groress from sys
Date: Wed, 20 May 2015 23:35:14 -0400 (EDT)
Message-ID: <1125480493.2141369.1432179314388.JavaMail.zimbra@redhat.com>
References: <1431673637-10817-1-git-send-email-xni@redhat.com> <592729481.1396196.1432089335521.JavaMail.zimbra@redhat.com> <20150520152042.407313f9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150520152042.407313f9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



----- Original Message -----
> From: "NeilBrown" <neilb@suse.de>
> To: "Xiao Ni" <xni@redhat.com>
> Cc: linux-raid@vger.kernel.org
> Sent: Wednesday, May 20, 2015 1:20:42 PM
> Subject: Re: [PATCH] need read reshape_groress from sys
> 
> On Tue, 19 May 2015 22:35:35 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:
> 
> > Hi all
> > 
> >    Send the patch again. Because I don't see them at
> >    http://www.spinics.net/lists/raid/
> > 
> > 
> > ----- Forwarded Message -----
> > From: "Xiao Ni" <xni@redhat.com>
> > To: linux-raid@vger.kernel.org
> > Cc: "Xiao Ni" <xni@redhat.com>
> > Sent: Friday, May 15, 2015 3:07:17 PM
> > Subject: [PATCH] need read reshape_groress from sys
> > 
> > 
> 
> 
> Please actually explain the purpose of the patch.
> Then  re-read it to ensure it makes sense and remove obvious typos.
> 
> and don't just remove unrelated blank lines.
> Only include in the patch things that need to be in the patch.
> 
> 
Hi Neil

  I messed the mails, sorry for this. I have sent a mail which subject is "raid5 reshape is stuck" and 
two patch mails several days before. But I can't find them so I sent them again yesterday. 

  And I try to reproduce this with newest kernel and newest mdadm. The problem is fixed already. But I
still have a question which is below the steps I did.

  Now I paste the reason here:

  I encounter the problem when I reshape a 4-disks raid5 to 5-disks raid5. It just can
appear with loop devices.

   The steps are:

[root@dhcp-12-158 mdadm-3.3.2]# mdadm -CR /dev/md0 -l5 -n5 /dev/loop[0-4] --assume-clean
mdadm: /dev/loop0 appears to be part of a raid array:
       level=raid5 devices=6 ctime=Fri May 15 13:47:17 2015
mdadm: /dev/loop1 appears to be part of a raid array:
       level=raid5 devices=6 ctime=Fri May 15 13:47:17 2015
mdadm: /dev/loop2 appears to be part of a raid array:
       level=raid5 devices=6 ctime=Fri May 15 13:47:17 2015
mdadm: /dev/loop3 appears to be part of a raid array:
       level=raid5 devices=6 ctime=Fri May 15 13:47:17 2015
mdadm: /dev/loop4 appears to be part of a raid array:
       level=raid5 devices=6 ctime=Fri May 15 13:47:17 2015
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
[root@dhcp-12-158 mdadm-3.3.2]# mdadm /dev/md0 -a /dev/loop5
mdadm: added /dev/loop5
[root@dhcp-12-158 mdadm-3.3.2]# mdadm --grow /dev/md0 --raid-devices 6
mdadm: Need to backup 10240K of critical section..
[root@dhcp-12-158 mdadm-3.3.2]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 loop5[5] loop4[4] loop3[3] loop2[2] loop1[1] loop0[0]
      8187904 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/6] [UUUUUU]
      [>....................]  reshape =  0.0% (0/2046976) finish=6396.8min speed=0K/sec
      
unused devices: <none>

   It because the sync_max is set to 0 when run the command --grow

[root@dhcp-12-158 mdadm-3.3.2]# cd /sys/block/md0/md/
[root@dhcp-12-158 md]# cat sync_max
0

   I tried reproduce with normal sata devices. The progress of reshape is no problem. Then
I checked the Grow.c. If I use sata devices, in function reshape_array, the return value
of set_new_data_offset is 0. But if I used loop devices, it return 1. Then it call the function
start_reshape.

   In the function start_reshape it set the sync_max to reshape_progress. But in sysfs_read it
doesn't read reshape_progress. So it's 0 and the sync_max is set to 0. Why it need to set the
sync_max at this? I'm not sure about this.


> 
> 
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >  Grow.c  |   18 ++++++++++++------
> >  mdadm.h |    1 +
> >  sysfs.c |   15 +++++++++++++++
> >  3 files changed, 28 insertions(+), 6 deletions(-)
> > 
> > diff --git a/Grow.c b/Grow.c
> > index 568e399..44ee8a7 100644
> > --- a/Grow.c
> > +++ b/Grow.c
> > @@ -710,11 +710,17 @@ int start_reshape(struct mdinfo *sra, int
> > already_running,
> >  	err = sysfs_set_num(sra, NULL, "suspend_hi", sra->reshape_progress);
> >  	err = err ?: sysfs_set_num(sra, NULL, "suspend_lo",
> >  				   sra->reshape_progress);
> > -	if (before_data_disks <= data_disks)
> > -		sync_max_to_set = sra->reshape_progress / data_disks;
> > -	else
> > -		sync_max_to_set = (sra->component_size * data_disks
> > -				   - sra->reshape_progress) / data_disks;
> > +
> > +	if (sra->reshape_progress == UINT64_MAX) {
> > +		err = err ?: sysfs_set_str(sra, NULL, "sync_max", "max");
> > +	} else {
> > +		if (before_data_disks <= data_disks)
> > +			sync_max_to_set = sra->reshape_progress / data_disks;
> > +		else
> > +			sync_max_to_set = (sra->component_size * 2 * data_disks
> > +										- sra->reshape_progress) / data_disks;
> > +	}
> > +
> >  	if (!already_running)
> >  		sysfs_set_num(sra, NULL, "sync_min", sync_max_to_set);
> >  	err = err ?: sysfs_set_num(sra, NULL, "sync_max", sync_max_to_set);
> > @@ -3075,7 +3081,7 @@ static int reshape_array(char *container, int fd,
> > char *devname,
> >  	}
> >  	sra = sysfs_read(fd, NULL,
> >  			 GET_COMPONENT|GET_DEVS|GET_OFFSET|GET_STATE|GET_CHUNK|
> > -			 GET_CACHE);
> > +			 GET_CACHE|GET_RESHAPE_PROGRESS);
> >  	if (!sra) {
> >  		pr_err("%s: Cannot get array details from sysfs\n",
> >  			devname);
> > diff --git a/mdadm.h b/mdadm.h
> > index 141f963..6fb17e1 100644
> > --- a/mdadm.h
> > +++ b/mdadm.h
> > @@ -526,6 +526,7 @@ enum sysfs_read_flags {
> >  	GET_DEGRADED	= (1 << 8),
> >  	GET_SAFEMODE	= (1 << 9),
> >  	GET_BITMAP_LOCATION = (1 << 10),
> > +	GET_RESHAPE_PROGRESS = (1 << 11),
> >  
> >  	GET_DEVS	= (1 << 20), /* gets role, major, minor */
> >  	GET_OFFSET	= (1 << 21),
> > diff --git a/sysfs.c b/sysfs.c
> > index 18f3df9..09b0c93 100644
> > --- a/sysfs.c
> > +++ b/sysfs.c
> > @@ -26,6 +26,7 @@
> >  #include	"mdadm.h"
> >  #include	<dirent.h>
> >  #include	<ctype.h>
> > +#include	<stdint.h>
> >  
> >  int load_sys(char *path, char *buf)
> >  {
> > @@ -210,6 +211,19 @@ struct mdinfo *sysfs_read(int fd, char *devnm,
> > unsigned long options)
> >  		msec = (msec * 1000) / scale;
> >  		sra->safe_mode_delay = msec;
> >  	}
> > +
> > +	if (options & GET_RESHAPE_PROGRESS) {
> > +
> > +		strcpy(base, "reshape_progress");
> > +		if (load_sys(fname, buf))
> > +			goto abort;
> > +
> > +		if (strncmp(buf, "max", 3) == 0)
> > +			sra->reshape_progress = UINT64_MAX;
> > +		else
> > +			sra->reshape_progress = strtol(buf, NULL, 10);
> > +	}
> > +
> >  	if (options & GET_BITMAP_LOCATION) {
> >  		strcpy(base, "bitmap/location");
> >  		if (load_sys(fname, buf))
> > @@ -224,6 +238,7 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned
> > long options)
> >  			goto abort;
> >  	}
> >  
> > +
> >  	if (! (options & GET_DEVS))
> >  		return sra;
> >  
> 
> 
