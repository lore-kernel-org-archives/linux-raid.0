From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: recovery question?
Date: Thu, 16 Oct 2003 13:57:53 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16270.5953.932583.400340@notabene.cse.unsw.edu.au>
References: <6.0.0.22.2.20031013111015.032c1a58@englishmail.fsu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Scott Kopel on Monday October 13
To: Scott Kopel <skopel@english.fsu.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday October 13, skopel@english.fsu.edu wrote:
> I have a raid1 with two disks /dev/hda and /dev/hdc ... three md devices
> /dev/md0 made up of hda1 and hdc1
> /dev/md1 made up of hda2 and hdc2
> /dev/md2 made up of hda3 and hdc3
> 
> --I accidently formatted hda1 using #mke2fs -vj /dev/hda1 ... bonehead move 
> number 1
> --then I booted from a backup drive and resynced the raid

Exactly how did you "resync the raid".

doing "mke2fs" would not have been visible to the md driver so it wont
have known that the data was bad.

The thing to do at this point would be

  mdadm /dev/md0 -f /dev/hda1  # fail the drive
  mdadm /dev/md0 -r /dev/hda1  # and remove it
  mdadm /dev/md0 -a /dev/hda1  # and re-add it.

some of the corruption caused by mke2fs might have leaked into hdc1,
so a fsck would have been the next thing to do.



> --when I tried to boot from the /dev/md0 I couldn't boot because of 
> filesystem errors
> --so then I ran e2fsck /dev/md0 and several errors were noted and fixed.. I 
> didn't write down the error messages because I was too harried, bonehead 
> move number 2, however I think the errors were files without inodes... the 
> errors were fixed and a bunch of files and directories were put in 
> lost&found ... mostly they were a recently installed phpmyadmin directory 
> in /var/www/html/phpmyadmin and the only other file I've found missing so 
> far is /usr/bin/info..
> --I am curious what happened.. did the format remove the superblock and 
> resyncing rewrote the superblock using the inodes for  these files?
> any info would be appreciated

format would have zeroed all the inodes as seen on hda1
Any attempt to load an inode from md0 might have found a zeroed one on
hda1.  It if was written back the md0, that would have corrupted hdc1.

NeilBrown
