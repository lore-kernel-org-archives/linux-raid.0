From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: error during raid config
Date: Fri, 16 Jan 2004 15:39:03 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401162039.i0GKdBi14959@dns1.watkins-home.com>
References: <011620042019.25061.7bce@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <011620042019.25061.7bce@comcast.net>
To: gannan10@comcast.net, 'Steven Ihde' <sihde@cs.stanford.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

md1-4 all have 1 disk missing!  Maybe that is a clue!
Is your disk hda bad?

Most people say mkraid is bad.  You should use mdadm.  I agree.

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of gannan10@comcast.net
Sent: Friday, January 16, 2004 3:19 PM
To: Steven Ihde
Cc: linux-raid@vger.kernel.org
Subject: Re: error during raid config

the command worked for other md(1 - 4) and the cat /proc/mdstat looks like
the following:

# cat /proc/mdstat
Personalities : [raid1]
read_ahead 1024 sectors
md4 : active raid1 hdb7[0]
      9687040 blocks [2/1] [U_]

md3 : active raid1 hdb6[0]
      9679040 blocks [2/1] [U_]

md2 : active raid1 hdb5[0]
      9679040 blocks [2/1] [U_]

md1 : active raid1 hdb3[0]
      2996032 blocks [2/1] [U_]

md0 : inactive
unused devices: <none>


Now when I use mkraid for md0 I get the following error:

# mkraid --really-force /dev/md0
DESTROYING the contents of /dev/md0 in 5 seconds, Ctrl-C if unsure!
handling MD device /dev/md0
analyzing super-block
disk 0: /dev/hdb1, 489951kB, raid superblock at 489856kB
disk 1: /dev/hda1, failed
mkraid: aborted, see the syslog and /proc/mdstat for potential clues.

the syslog shows this:

---Jan 16 14:16:17 adobea kernel: md: array md0 already exists!

I alos tried mounting it and I get the following error:

~# mount -t ext2 /dev/md0 /mnt
mount: wrong fs type, bad option, bad superblock on /dev/md0,
       or too many mounted file systems
       (could this be the IDE device where you in fact use
       ide-scsi so that sr0 or sda or so is needed?)


Please help..   I am using procedure at:
http://tldp.org/HOWTO/Boot+Root+Raid+LILO-4.html

Thanks
Gordon.


> On Fri, Jan 16, 2004 at 06:18:07PM +0000, gannan10@comcast.net wrote:
> > Hello,
> > 
> > I get the following error when I tried to setup my raid:
> > 
> > # mkraid /dev/md0
> > handling MD device /dev/md0
> > analyzing super-block
> > disk 0: /dev/hda1, 489951kB, raid superblock at 489856kB
> > /dev/hda1 is mounted
> > mkraid: aborted, see the syslog and /proc/mdstat for potential clues.
> 
> I use mdadm, not mkraid, but it appears the problem is right there:
> "/dev/hda1 is mounted".  Probably if you have a mounted filesystem on
> /dev/hda1, you cannot add it to the raid array.  Once you've created
> the raid array you can mount /dev/md0 instead of /dev/hda1.
> 
> -Steve
> 
> 
> 

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


