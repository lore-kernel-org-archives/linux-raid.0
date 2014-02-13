From: Andrew Martin <amartin@xes-inc.com>
Subject: Re: Automatically drop caches after mdadm fails a drive out of an
 array?
Date: Thu, 13 Feb 2014 08:57:07 -0600 (CST)
Message-ID: <669652530.12040.1392303427052.JavaMail.zimbra@xes-inc.com>
References: <1413719638.30344.1392138285471.JavaMail.zimbra@xes-inc.com> <1090802800.32078.1392138664718.JavaMail.zimbra@xes-inc.com> <20140212065420.4643f9a1@notabene.brown> <700319865.79921.1392160257000.JavaMail.zimbra@xes-inc.com> <52FABC1A.1010804@hardwarefreak.com> <1113712961.13129.1392216288183.JavaMail.zimbra@xes-inc.com> <52FC8250.4080903@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52FC8250.4080903@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



----- Original Message -----
> From: "Stan Hoeppner" <stan@hardwarefreak.com>
> To: "Andrew Martin" <amartin@xes-inc.com>
> Cc: "NeilBrown" <neilb@suse.de>, linux-raid@vger.kernel.org
> Sent: Thursday, February 13, 2014 2:29:04 AM
> Subject: Re: Automatically drop caches after mdadm fails a drive out of an array?
> 
> > It seemed unlikely that the timing of the failure of the drive out of
> > the raid array and these filesystem-level problems was coincidental.
> > Yes, there were also filesystem errors, immediately after md dropped the
> > device. This is an ext4 filesystem:
> 
> Please show all disk/controller errors in close time proximity before
> the md fail event.
> 
> > 13:50:31 mdadm[1897]: Fail event detected on md device /dev/md2, component
> > device /dev/sdb
> > 13:50:31 smbd[3428]: [2014/02/10 13:50:31.226854,  0]
> > smbd/process.c:2439(keepalive_fn)
> > 13:50:31 smbd[13539]: [2014/02/10 13:50:31.227084,  0]
> > smbd/process.c:2439(keepalive_fn)
> > 13:50:31 kernel: [17162282.624858] EXT4-fs error (device drbd0):
> > htree_dirblock_to_tree:587: inode #148638560: block 1189089581: comm smbd:
> > bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=2004033568,
> > rec_len=29801, name_len=99
> > 13:50:31 kernel: [17162282.823733] EXT4-fs error (device drbd0):
> > htree_dirblock_to_tree:587: inode #148638560: block 1189089581: comm smbd:
> > bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=2004033568,
> > rec_len=29801, name_len=99
> > 13:50:31 kernel: [17162282.832886]
> > /build/buildd/linux-3.2.0/drivers/scsi/mvsas/mv_sas.c 1863:port 2 slot 45
> > rx_desc 3002D has error info8000000080000000.
> > 13:50:31 kernel: [17162282.832920]
> > /build/buildd/linux-3.2.0/drivers/scsi/mvsas/mv_94xx.c 626:command active
> > 30305FFF,  slot [2d].
> > 13:50:31 kernel: [17162282.991884]
> > /build/buildd/linux-3.2.0/drivers/scsi/mvsas/mv_sas.c 1863:port 3 slot 52
> > rx_desc 30034 has error info8000000080000000.
> > 13:50:31 kernel: [17162282.991892]
> > /build/buildd/linux-3.2.0/drivers/scsi/mvsas/mv_94xx.c 626:command active
> > 302FFFFF,  slot [34].
> > 13:50:31 kernel: [17162282.992072]
> > /build/buildd/linux-3.2.0/drivers/scsi/mvsas/mv_sas.c 1863:port 2 slot 53
> > rx_desc 30035 has error info8000000080000000.
> > ...
> > 13:52:03 kernel: [17162374.423961] EXT4-fs error (device drbd0):
> > htree_dirblock_to_tree:587: inode #148638560: block 1189089581: comm smbd:
> > bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=2004033568,
> > rec_len=29801, name_len=99
> > 13:52:04 kernel: [17162375.839851] EXT4-fs error (device drbd0):
> > htree_dirblock_to_tree:587: inode #148638560: block 1189089581: comm smbd:
> > bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=2004033568,
> > rec_len=29801, name_len=99
> > 13:52:08 kernel: [17162380.135391] EXT4-fs error (device drbd0):
> > htree_dirblock_to_tree:587: inode #148638560: block 1189089581: comm smbd:
> > bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=2004033568,
> > rec_len=29801, name_len=99
> > 13:52:13 kernel: [17162385.108358] EXT4-fs error (device drbd0):
> > htree_dirblock_to_tree:587: inode #148638560: block 1189089581: comm smbd:
> > bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=2004033568,
> > rec_len=29801, name_len=99
> > 13:52:17 kernel: [17162388.166515] EXT4-fs error (device drbd0):
> > htree_dirblock_to_tree:587: inode #148638560: block 1189089581: comm smbd:
> > bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=2004033568,
> > rec_len=29801, name_len=99
> > ...
> 
> Does drbd0 sit atop md2?
> 
> Also, the Marvel x8 SAS controllers are fine for Windows.  But the Linux
> driver sucks, and has historically made the HBAs unusable.  The most
> popular is probably the SuperMicro AOC-SASLP-MV8.  In the log above the
> driver is showing errors on two SAS ports simultaneously.  If not for
> the presence of mvsas I'd normally assume dirty power or a bad backplane
> due to such errors.  The errors should not propagate up the stack to
> drbd.  But the mere presence of this driver suggests it is part of the
> problem.
> 
> Swap the Marvell SAS card for something decent and I'd bet most of your
> problems will disappear.

Stan,

You are correct; this is a SuperMicro AOC-SAS2LP-MV8 card. Here is a complete
copy of the error messages in syslog:
http://pastebin.com/DJqHDPvH

Note that I added a new, replacement drive to the array at 17:09. In lieu of 
Marvel SAS cards, what would you recommend?

Yes, DRBD sits on top of the md/raid array. The complete stack is:
HDDs <-- md/raid <-- LVM <-- DRBD (drbd0) <-- ext4

Thanks,

Andrew
