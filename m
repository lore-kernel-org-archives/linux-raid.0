From: Jim Schatzman <james.schatzman@futurelabusa.com>
Subject: Re: Why does MD overwrite the superblock upon temporary
  disconnect?
Date: Tue, 21 Sep 2010 07:16:23 -0600
Message-ID: <20100921131656.73CD2E3096C@mail.futurelabusa.com>
References: <20100921025058.79B24E3096C@mail.futurelabusa.com>
 <20100921140914.6a92e794@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100921140914.6a92e794@notabene>
References: <20100921025058.79B24E3096C@mail.futurelabusa.com>
 <20100921140914.6a92e794@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, richard@sauce.co.nz
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil and Richard-

Thanks for your responses.  My environment.

OS:  Linux l1.fu-lab.com 2.6.34.6-47.fc13.i686.PAE #1 SMP Fri Aug 27 09:29:49 UTC 2010 i686 i686 i386 GNU/Linux

MDADM: mdadm - v3.1.2 - 10th March 2010

SATA controller:   SiI 3124 PCI-X Serial ATA Controller

Drive cages: 8 drive chassis with 4x port multipliers.

More details:  I tried reassembling the array with mdadm -A --force /dev/mdX
 and also by specifying all the devices explicitly. I tried this multiple times. This did not work. A couple of things happened

a) mdadm always reported that there weren't enough drives to start the array

b) about 75% of the time, it would complain that one of the drives was busy, so that the result was 4 active; 3 spare

c) there was no reason that I could see why it would report one busy drive - the drive wasn't part of another array, mounted separately, bad, or marked anything other than "spare".
 I had no trouble copying data from the "busy" drive with dd.

As I originally reported, I could not get "assemble" to work, with the above symptoms.


Also, I noticed that the "events" counter was messed up on the "spare" drives. The 4 "active" drives had values of 90, the spare drives had varying events values - most were 0 but as I recall one had a value around 30 or so.


I didn't note the counter values and the "spare" state until after I rebooted. The exact process was this

1) Jogged the mouse cable which jogged the eSATA cable.

2) I noticed that the array was inactive and immediate shut the system down.

3) Fixed the cables and rebooted.

4) At this point, had 4 "active" disks and 4 "spares".  Tried reassembling many different ways. Sometimes, mdadm would reduce this to 4 "active" and 3 "spares".

5) No progress with the above at all until I recreated ("mdadm -C") the array with 6 drives, checked the data, added the 2 additional drives, at which point resyncing occurred.

Re: "It marks the devices as having failed
but otherwise doesn't change the metadata.
I've occasionally thought about
leaving the metadata alone once enough devices have failed that the array
cannot work, but I'm not sure it would really gain anything."


My response: The problem with what MD does now (overwriting the metadata) is that it loses track of the slot numbers, and also apparently will not allow you to reassemble the drive (maybe based on the events counter??). If it kept the slot numbers around, and allowed you to force "spare" drives to be considered "active", that would be easier to deal with. I think you are saying that this occured when I rebooted - is that correct? 


Re: "The 'destruction' of the metadata happens later, not at the time of device
failure."

My response:  So... maybe if I had prevented initrd from trying to start the array when I rebooted, I could have diagnosed the situation and fixed it more easily than by recreating the array.  How?


Re: "How is 'check the parity' different from 'resync two disks from scratch' ??
Both require reading every block on every disk."

My response: With RAID6, it appears that MD reads all the data twice - once for each set of parity data. I added the 7th and 8th drives simultaneously, but the resyncing was done one drive at a time (according to mdadm --detail /dev/mdX).

O.k., so this wasn't catastrophic. I was just afraid to stress anything by using the array until the syncing was complete.


Re: "So here is the crux of the matter - what is over-writing the metadata and
converting the devices to spares?  So far: I don't know.
I have tried to reproduce this and cannot. "

My response: If I am able to, I will create another, similar array (with no valuable data!) and try this again. Here would be my procedure
a) Create an 8-drive RAID 6 array.

b) With the array running, unplug half of the array. Observe that the array goes inactive.

c) Reboot the system

If the same behavior repeats itself, I will end up with 4 active drives and 4 spares.  It is also possible that connectivity with the 2nd half of the array went on and off several times over the several seconds while I was pulling on the mouse cable - eSata connectors don't seem to be 100% reliable.


Another question

Do I understand correctly, that if I had added the last 2 drives with "--assume-clean", would the resync have been skipped?


Thanks!

Jim


