From: Albert Pauw <albert.pauw@gmail.com>
Subject: Re: More ddf container woes
Date: Wed, 23 Mar 2011 20:18:24 +0100
Message-ID: <4D8A4780.2030401@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  Hi Neil,

I noticed on your 3.1.5 announcement that there were ddf fixes as well.

I tried the stuff I mentioned before (see below), but those issues 
weren't fixed.

I hope you will have some time to look into this.

Regards,

Albert Pauw

-------- Original Message --------

  Hi Neil,

I updated to the git version (devel) and tried my "old" tricks:

- Create a container with 5 disks
- Created two raid sets (raid 1 md0 and raid 5 md1) in this container

mdadm -E  /dev/md127 shows all disks active/Online

- Failed one disk in md0

mdadm -E /dev/md127 shows this disk as active/Offline, Failed

- Failed one disk in md1

mdadm -E /dev/md127 shows this disk as active/Offline, Failed

- Added a new spare disk to the container

mdadm -E /dev/md127 shows this new disk as active/Online, Rebuilding

this looks good, but although the container has six disks, the lastly failed
disk is missing, mdadm -E /dev/md127 only shows five disks (including
the rebuilding one).

This time however, only one of the failed raid sets is rebuilding, so
that fix is ok.

Here is another scenario with strange implications:

- Created a container with 6 disks

mdadm -E /dev/md127 shows all 6 disks as Global-Spare/Online

- Removed one of the disks, as I only needed 5

This time mdadm -e /dev/md127 shows six physical disks, one of which has
no device

- Created two raid sets (raid 1 md0 and raid 5 md1) in this container

mdadm -E  /dev/md127 shows all disks active/Online, except the "empty
entry" which stays
Global-Spare/Online

- I fail two disks, one in each raid array

mdadm -E /dev/md127 shows these two disks as active/Offline, Failed

- I add back the disk I removed earlier, it should fit into the empty
slot of mdadm -E

mdadm -E /dev/md127 shows something very strange, namely
->  All disks are set to Global-Spare/Online
->  All device files are removed from the slots in mdadm -E, except the
newly added one,
which shows the correct device

Albert



