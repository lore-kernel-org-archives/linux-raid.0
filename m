From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: what does spares=1 mean  in mdadm --detail --scan for raid1
Date: Fri, 29 Apr 2005 02:38:08 -0400
Message-ID: <200504290638.j3T6cEm19128@www.watkins-home.com>
References: <200504290225.42442.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200504290225.42442.mlaks@verizon.net>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mitchell Laks' <mlaks@verizon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Mitchell Laks
> Sent: Friday, April 29, 2005 2:26 AM
> To: linux-raid@vger.kernel.org
> Subject: what does spares=1 mean in mdadm --detail --scan for raid1
> 
> Hi,
> I have multiple raid 1 devices on my system.
> 
> recently i noticed read seek errors in /var/log/kern.log from /dev/hdi1
> which
> is part of /dev/md1.
> 
> I then did a lot of work with /dev/md1 and then i noticed that /dev/hdi1
> failed in the /dev/md1 but the data was fine on remaining part of raid1.
> 
> I then shut system down and
> then i put in another device to replace /dev/hdi1 and rebooted
> 
> At this point of rebooting,  i had forgotten to edit the contents
> of /etc/mdadm/mdadm.conf and it still had the line something like
> 
>   ARRAY /dev/md1 level=raid1 num-devices=2 \
> UUID=d876333b:694e852b:e9a6f40f:0beb90f9
> devices /dev/hdc1,/dev/hdi1
> 
> then i got an error from fsck on bootup as it reached /dev/md1
> and dropped me into single user  mode
> then i changed the mdadm.conf file to
> 
>   ARRAY /dev/md1 level=raid1 num-devices=2
> UUID=d876333b:694e852b:e9a6f40f:0beb90f9
> devices /dev/hdc1
> 
> and it booted fine.
This seems very wrong to me!  I hope someone else can help here!

> 
> i then did
> mdadm /dev/md1 -a /dev/hdi1
> to add in my new drive.
> 
> Mdadm then began to recreate the array.
> 
> and then, while the raid was in the process of rebuilding
> i did
> mdadm --detail --scan
> and the line read
> 
>   ARRAY /dev/md1 level=raid1 num-devices=2 spares=1 \
> UUID=d876333b:694e852b:e9a6f40f:0beb90f9
> devices /dev/hdc1,/dev/hdi1
> 
> so my question for the group is
> 
> what is the meaning of spares=1?
When you add a disk it is a spare.
If needed, it is used to replace a missing disk.
Once the re-sync is done it will not be a spare.

> 
> does it mean to indicate that the device is still rebuilding?
> 
> On the other raid 1 devices on my system, such as
> /dev/md0 the mdadm --detail --scan  says
> 
>   ARRAY /dev/md0 level=raid1 num-devices=2
> UUID=d876333b:694e852b:e9a6f40f:0beb90f9
> devices /dev/hda1,/dev/hdg1
> 
> without the spares=1  clause.
> 
> The reason I ask is: What should I write into my new version of
> mdadm.conf?
> I am  guessing  I should write
> 
>    ARRAY /dev/md1 level=raid1 num-devices=2
> UUID=d876333b:694e852b:e9a6f40f:0beb90f9
> devices /dev/hdc1,/dev/hdi1
> 
> without the spares=1 thing.
> 
> I am confused what spares=1 is for.....
I am confused by the change you had to make!
But you should not add "spares=1".

> 
> Thanks!!!
> Mitchell Laks

Guy

