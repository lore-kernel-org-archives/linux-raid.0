From: "Guy" <bugzilla@watkins-home.com>
Subject: Minor bugs in "mdadm --monitor --scan &"
Date: Mon, 10 Jan 2005 00:27:41 -0500
Message-ID: <200501100527.j0A5Rn919868@www.watkins-home.com>
References: <200501100324.j0A3OZ919388@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501100324.j0A3OZ919388@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have mdadm configured to run a script when an event occurs.

I start mdadm like this:
mdadm --monitor --scan&

That is from a script in /etc/init.d

My /etc/mdadm.conf file has this:
PROGRAM /root/bin/handle-mdadm-events
Other lines not related.

The script has these 2 lines:
echo '$1'=$1 '$2'=$2 '$3'=$3 '$4'=$4 >> /root/bin/handle-mdadm-events.log
(date;cat /proc/mdstat;mdadm --detail $2)|mail -s "md event: $1 $2 $3"
bugzilla@watkins-home.com 

I have a test array with 8 disks, /dev/ram[0-7]

I ran this command:

# mdadm /dev/md3 -f /dev/ram0
mdadm: set /dev/ram0 faulty in /dev/md3

I waited, I got 1 email:
Fail /dev/md3 /dev/ram0

I ran these 2 commands:
# mdadm /dev/md3 -a /dev/ram8
mdadm: hot added /dev/ram8
# mdadm /dev/md3 -a /dev/ram9
mdadm: hot added /dev/ram9

Now I have 2 spares.
I waited, I got this email:
SpareActive /dev/md3 /dev/ram8

The Fail event and 4 others were missed.
Examples from a slower array:
$1=Fail $2=/dev/md2 $3=/dev/sdq1 $4=
$1=Rebuild20 $2=/dev/md2 $3= $4=
$1=Rebuild40 $2=/dev/md2 $3= $4=
$1=Rebuild60 $2=/dev/md2 $3= $4=
$1=Rebuild80 $2=/dev/md2 $3= $4=
$1=SpareActive $2=/dev/md2 $3=/dev/sdc1 $4=


I ran this command:
# mdadm /dev/md3 -f /dev/ram1
mdadm: set /dev/ram1 faulty in /dev/md3

No emails were generated.  About 6 events were missed.
The Fail and SpareActive events were missed, and the 4 Rebuild events.

I think, since the state changed, then changed back, within 60 seconds, the
events were missed.

For me, I don't recall ever missing an event on a "real" array, but with the
faster disks and very small /boot partitions I believe it could easily
happen.  My small partitions don't have spares.

Also, adds and removes don't generate events.

Also, if there is no spare, the console display an extra warning:
"md3: no spare disk to reconstruct array! -- continuing in degraded mode"
Maybe this event should also generate an email.

If there is a spare, the console displays this message:
"md3: resyncing spare disk [dev 01:0e] to replace failed disk"

Maybe both of the above should generate emails.  Otherwise you must wait
until the Rebuild20 event to know that there is a spare.  Or I wait forever
if there is not a spare.

Just noticed while playing!
If I use MAILADDR and don't use PROGRAM, like this:
MAILADDR bugzilla@watkins-home.com
# PROGRAM /root/bin/handle-mdadm-events

I don't get Fail events, but I do get some events, like SpareActive.
No!  Another test I got the Fail event, but not the SpareActive.
With the above I did wait 60 seconds or more!

And when I start monitor mode using PROGRAM I get these:
$1=SparesMissing $2=/dev/md2 $3= $4=
$1=SparesMissing $2=/dev/md3 $3= $4=
$1=SparesMissing $2=/dev/md1 $3= $4=
$1=SparesMissing $2=/dev/md0 $3= $4=

But when using MAILADDR I don't get them!
And they are wrong!  /dev/md2 does have a spare, and sometimes md3 has one.

Also, if I use both, PROGRAM and MAILADDR I get some events from MAILADDR
and some from PROGRAM, I don't always get all events from both.  I have not
tried this much, so no details.

Maybe md could save events in a queue, and mdadm --monitor could access the
queue.  Maybe something like /proc/mdevents could be usefull.

I am using kernel 2.4.28 and mdadm 1.8.0.

Guy

