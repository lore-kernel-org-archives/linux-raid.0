From: Casey Boone <caseyboone@gmail.com>
Subject: raidtools to mdadm
Date: Sun, 01 Apr 2007 18:13:15 -0500
Message-ID: <46103C8B.4030001@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

ok so i am trying to recover some data for a friend.  what i am wanting 
to do is forcibly set up /dev/mdN to be a raid0 of /dev/sda and /dev/sdb

i do not want to actually change any of the contents of these drives, 
just mount very simply as a raid0.  the raid was originally created 
using an onboard nvidia raid on the motherboard these drives used to be 
hooked to.  my friend thought he could shove them into another windows 
box (that is what he was running on them) and have windows recover the 
raid.  all this did was totally destroy the superblock on one of the two 
drives.  dmraid now wont see them as a matched pair so that is out.  the 
actual data areas of both drives seems to be intact, but unless i can 
get them into raid0 i dont know how i can recover the data.  it figures 
he gives me the drives after he makes it a notch or two more of a pain :\


now before the advent of mdadm i would use /etc/raidtab and have no 
issues setting up the raid device.


as best i can tell i am using the correct commands for what i want but i 
pretty much get nothing but errors:

root@Knoppix:/media# mdadm --build /dev/md1 --chunk=128 --level=0 
--raid-devices=2 /dev/sda /dev/sdb
mdadm: error opening /dev/md1: No such device or address
root@Knoppix:/media# mdadm --build -n 2 -c 128 -l 0 /dev/md1 /dev/sda 
/dev/sdb
mdadm: error opening /dev/md1: No such device or address


when i run those commands i do get /dev/mdN entries created, but they do 
not point to a valid block device (as tested with fdisk -l and with 
dmraid -b)


for the life of me i dont understand why anyone would put important data 
on a raid0, but that is what happened in this case.


If i have to i will drop down to an older knoppix release to get 
raidtools back, as i have never had any issues in recovering crap 
onboard raid arrays nor windows software raid arrays under it.  i am 
sure it can be done with mdadm but for the life of me i cannot seem to 
figure out exactly how.

any help on this would be greatly appreciated

Casey
