From: Roy Sindre Norangshol <roysn@tihlde.org>
Subject: Need help to rescue my raid5 array after bad try to add new disks.
Date: Sat, 17 Feb 2007 13:21:27 +0100
Message-ID: <45D6F347.5000205@tihlde.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear users of linux-raid mailing list.

I'm looking for some help about errors that I did when trying to add 2 
new disks to my existing 4drive *320gb array. I added the disks to the 
array and used mdadm to grow em. After it was done rebuilding I "forgot" 
to check the status of the disks. 1 of the disks added itself as a hot 
spare (never had that yet before, but was planned for next upgrade since 
I was planning more disks/controllers ETA 2 weeks later), and the other 
disk was added as removed-state. I managed then to use resize2fs on the 
/dev/md1 to increase it too full since. I think it showed some errors at 
the end, but since I was doing this in school time I was of course as 
lucky to manage to close the terminal instead of logging out of screen 
since I was running to class.

Simple case is that I managed to resize the file system to a bigger size 
then it isn't. One of the disks died too, spin up&spin down&click 
sounds. I'am afraid that it could be me who killed the drive but 
software shouldn't do that as far as I know. (2 drives actually died, so 
their in for RMA. I bought 3 new hdds, but didn't have sata-slot for the 
last hdd, so it was only powered on in the hot swap bay without even 
being connected to the motherboard - and that drive died..).

This is the log from after I've resized and activated the array and it 
failed:
http://pastebin.ca/357261

These are the disks that should be in the array: (mdadm --examine disk)
http://pastebin.ca/357284

First all 4 originally drives was in sync and the disk one was in hot 
spare and disk two removed-state.
I though I had to stop the array to be able to make them active fully in 
my array - this was quite a mistake I think.

I now ended up with all drives in removed-state, without the hot spare 
one which was now synced if I forced the array to run with -R option. (
  -R, --run
              Insist that mdadm run the array, even if some of the  
components
              appear  to  be  active in another array or file system.  
Normally
              mdadm will ask for confirmation before including such 
components
              in an array.  This option causes that question to be 
suppressed.
)

This is /proc/mdstat after I was using -R option:

sinope:/etc/mdadm# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] 
[raid4] [multipath] [faulty]
md1 : inactive sdf[6]
      312571136 blocks super 1.0

/dev/sda  (old disk)
/dev/sdb  (old disk)
/dev/sdc  (old disk)
/dev/sdd  (old disk)
/dev/sde  (new removed-state disk)
/dev/sdf  (new hot spare which at the end activated itself as synced 
after using -R)


I know I've managed to do quite odd things, but is it still possible to 
rescue my raid5 array?
I'm afraid that if I try again I might be able to crash more hdds - but 
I highly doubt it was the system's fault since one drive that wasn't 
even connected died too.
What should I do now to try rescue the array?

---
Roy Sindre Norangshol
