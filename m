From: Jesse Molina <jmolina@tgen.org>
Subject: Re: Failed RAID5 array grow after reboot interruption; mdadm:
 Failed to restore critical section for reshape, sorry.
Date: Mon, 16 Jun 2008 18:08:55 -0700
Message-ID: <C47C5CB7.9078%jmolina@tgen.org>
References: <C47BE76A.9030%jmolina@tgen.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C47BE76A.9030%jmolina@tgen.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jesse Molina <jmolina@tgen.org>, Ken Drummond <ken.drummond@kendrummond.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Thanks for the help.  I confirm success at recovering the array today.

Indeed, replacing the mdadm in the initramfs from the original v2.6.3 to
2.6.4 fixed the problem.

As noted by Richard Scobie, please avoid versions 2.6.5 and 2.6.6.  Either
v2.6.4 or v2.6.7 will fix this issue.  I fixed it with v2.6.4.



For historical purposes, and to help others, I was able to fix this as
follows;

Since the mdadm binary was in my initramfs, and I was unable to get the
working system up to mount it's root file system, I had to interrupt the
initramfs "init" script, replace mdadm with an updated version, and then
continue the process.

To do this, pass your Linux kernel an option such as "break=mount" or maybe
"break=top", to stop the init script just before it is about to mount the
root file system.  Then, get your new mdadm file and replace the existing
one at /sbin/mdadm.

To get the actual mdadm binary, you will need to use a working system to
extract it from a .deb, .rpm, or otherwise download and compile it.  In my
case, for debian, you can do an "ar xv <file.deb>" on the package, and then
tar -xzf on the data file.  For Debian, I just retrieved the file from
http://packages.debian.org

Then, stick the new file on a CD/DVD disk, USB flash drive, or other media
and somehow get it onto your system while it's still at the (initramfs)
busybox prompt.  I was able to mount from a CD, so "mount -t iso9660 -r
/dev/cdrom /temp-cdrom", after a "mkdir /temp-cdrom".

After you have replaced the old mdadm file with the new one, unmount your
temporary media and then type "mdadm --assemble /dev/md0" for whichever
array was flunking out on you.  Then "vgchange -a -y" if using LVM.

Finally, do ctrl+D to exit the initramfs shell, which will cause the "init"
script to try and continue with the boot process from where you interrupted
it.  Hopefully, the system will then continue as normal.

Note that you will eventually want to update your mdadm file and replace
your initramfs.



Thanks for the help Ken.

As for why my system died while it was doing the original grow, I have no
idea.  I'll run it in single user and let it finish the job.



On 6/16/08 9:48 AM, "Jesse Molina" <jmolina@tgen.org> wrote:

> 
> Thanks.  I'll give the updated mdadm binary a try.  It certainly looks
> plausible that this was a recently fixed mdadm bug.
> 
> For the record, I think you typoed this below.  You meant to say v2.6.4,
> rather than v2.4.4.  My current version was v2.6.3.  The current mdadm
> version appears to be v2.6.4, and Debian currently has a -2 release.
> 
> My system is Debian unstable, just as FYI.  It's been since January 2008
> since v2.6.4-1 was released, so I guess I've not updated this package since
> then.
> 
> Here is the changelog for mdadm;
> 
> http://www.cse.unsw.edu.au/~neilb/source/mdadm/ChangeLog
> 
> Specifically;
> 
> "Fix restarting of a 'reshape' if it was stopped in the middle."
> 
> That sounds like my problem.
> 
> I will try this here in an hour or two and see what happens...
> 
> 
> 
> On 6/16/08 3:00 AM, "Ken Drummond" <ken.drummond@kendrummond.com> wrote:
> 
>> There was an announcement on this
>> list for v2.4.4 which included fixes to restarting an interrupted grow.

-- 
# Jesse Molina
# The Translational Genomics Research Institute
# http://www.tgen.org
# Mail = jmolina@tgen.org
# Desk = 1.602.343.8459
# Cell = 1.602.323.7608


