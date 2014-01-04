From: Ron Leach <ronleach@tesco.net>
Subject: 'resync=PENDING', 'auto-read-only' on raid1 creation
Date: Sat, 04 Jan 2014 13:28:33 +0000
Message-ID: <52C80C81.3040004@tesco.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

List, good afternoon,

I've recently needed to create a new raid1 array in an existing 
(non-raid) Debian Wheezy system.  The array has been created 
read-only, and resync is PENDING; I didn't expect either of these 
conditions.

Objective is to have an LVM built initially on mirrored unused 2TB 
drives, with a view to growing the LVM with mirrored 3TB drives in the 
future.  The Logical volume will be exported over NFS, and will serve 
as a repository for backups of other machines.  The approach I am 
following is, first, to create a raid1 array then, second, install an 
LVM over that array, making sure that I create the LVM such that it 
can be expanded.

(I think) I've created a raid1 on two empty and unpartitioned 2TB 
drives, but am not seeing the results that the wiki 
(https://raid.wiki.kernel.org/index.php/RAID_setup) seems to suggest.

# cat /proc/mdstat
reports

md0 : active (auto-read-only) raid1 sdc[1] sdb [0]'
1953383360 blocks super 1.2 [2/2] [UU]
resync=PENDING

This was the create command I used:

# mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb /dev/sdc

I've read through man mdadm but had not expected 'auto-read-only', nor 
'resync=PENDING'.  Has something gone wrong, for some reason?  Or do I 
need, simply, to set the array to be read-write?  I wondered whether 
'create' does not 'start' the array, but it's reported as 'active', so 
I think the array is started.  I have not yet put a filesystem on the 
array, because I am not sure the creation is ok.

Grateful for any comment, and apologies for what must seem a very 
basic question,

regards, Ron

