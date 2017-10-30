From: Ron Leach <ronleach@tesco.net>
Subject: Additional RAID1 not assembling on reboot
Date: Mon, 30 Oct 2017 10:50:13 +0000
Message-ID: <59F703E5.6030105@tesco.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

List, good morning,

A RAID1 array that we recently created is not assembling automatically 
on system restart (other RAID1 arrays are assembling correctly).  I 
can re-assemble it using

# mdadm --assemble md5 -u <- the long hex uid ->

mdadm.conf does not list this additional ARRAY, and I wondered whether 
this might be why the array is not automatically assembling.  May I 
ask whether it would be safe to add an ARRAY line in mdadm.conf for 
this new RAID1?  mdadm.conf appears to have been automatically created 
and I am concerned whether any manual entries I make might 
subsequently be overwritten.

In case the answer is either 'it depends', or 'no', I'll add the 
background and detail here, but please skip it if the answer is 'yes'.

Background

We added another disk pair to a machine that already had a disc pair 
(sda, sdc) providing RAID1 arrays (md0, md1, md2) for mounting on 
boot, /, and /srv.  Another RAID1 array was created (md5) on a new 
disc pair (sdb, sdd; 2 x 4TB) which is mounted as /4T and used purely 
for our information (no system programs, logs, etc).  Both the 
existing disk contents and the new disk contents are regularly backed 
up.  So far, so good, but -

The new RAID1 array, md5, does not 'appear' when the machine is 
restarted (eg, reboot, or cold boot after extended power outage). 
(The original RAID1 arrays do appear on restart, so the system has 
/boot, /, and /srv.)  If we login and execute:

# mdadm --assemble md5 -u <- the long hex uid ->

md5 does 'appear', and we can then mount /dev/md5 on /4T.

I've checked /proc/partitions, and mdadm.conf.

/proc/partitions contains

all the sd[abcd]
all the sda[12345] (not all of these are RAID)
all the sdb[12345] (not all RAID)
all the sdc[12345] (not all RAID)
all the sdd[12345] (not all RAID)
md[012] (the 'original' RAID1 arrays for /boot, /, and /srv)
md5 (but is not being assembled automatically)

So, /proc/partitions seems to mention everything.

mdadm.conf contains a comment that it was auto-generated in April 2017 
by mkconf 3.2.5-5.  More to the point, that was when the server's 
first 3 RAID1 arrays were created; the additional RAID1 array (which 
is not being auto-assembled) was only created during September 2017, 5 
months after that.  Incidentally, this machine is running Debian Wheezy.

mdadm.conf appears to be mostly 'standard' other than for a stanza 
where it lists the definitions of existing MD arrays.  The list of 
existing arrays only includes
/dev/md0
/dev/md1
/dev/md2
(all are metadata 1.2)

/dev/md5 is not listed.  So I wondered whether it would be safe to 
simply add an ARRAY statement for /dev/md5?

Grateful for any opinions,

regards, Ron
