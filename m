From: =?UTF-8?B?Vm9qdMSbY2ggS2xldGXEjWth?= <vojta.kletecka@gmail.com>
Subject: Data recovery
Date: Thu, 21 Sep 2017 02:08:22 +0200
Message-ID: <CAEmSg0_=5ni2mA1Q_A1DjZmvjG9u8tKXOQHmnmT33=12yJwYqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear linux-raid subscribers,

may I humbly request your assistance?

I have three disks connected over usb from which I have made raid10
array with two far coppies. Ocasionally when connecting all three
disks to another computer one or two of the disks are not visible when
creating array due to bad contacts on usb port. Sometimes also one of
the disks suddenly disconnects from the array.
So far I always managed to solve the problems caused by these (very
poor, I am fully aware of that now) conditions by readding disk and
letting it synchronize with other disks. But now I apparently caused a
bigger issue because I am not able to assemble the raid at all.

As far as I remember when I connected the disks today, linux detected
only one. After few tries I found right usb ports for all three disks
and they were indeed shown in output of fdisk -l. But device was not
assembled at first. I have waited a little bit and mdadm finally
assembled the device (although I am not sure if there were two or
three devices). Strangely "cat /proc/mdstat" reported that devices are
99.something synchronized but supposedly with all blocks synchronized
(I mean both numbers were exactly the same) and 0kb speed. Weird I
thought and I issued mdadm --stop /dev/md127 because I wasn't able to
mount /dev/md127 to filesystem.

That was last thing I was able to do with the array. After that I have
tried all possible combinations of disks, assembling and incremental
assembling with/without --force and/or --run but everything without
any results. All commands just failed, in most cases with these two
errors:

sudo mdadm --assemble /dev/md127 /dev/sd[cde]1
mdadm: /dev/md127 assembled from 2 drives - need all 3 to start it
(use --run to insist).
(this command caused "kicking non-fresh sdd1 from array!" in dmesg)

sudo mdadm --assemble /dev/md127 /dev/sd[cde]1 --run
mdadm: failed to RUN_ARRAY /dev/md127: Input/output error
(this command caused "not enough operational mirrors." in dmesg)

From various examining commands (see archive for all commands
requested in "asking for help" part of wiki here:
http://mysharegadget.com/328200519) I have concluded, that one of
disks is far behind others in synchronization and other two disks
strangely don't have enough mirrors (although I though there are
exactly two disks where each block of data is written, at least in
this case).

sudo mdadm --examine /dev/sd[c-e]1 | egrep 'Event|/dev/sd'
/dev/sdc1:
         Events : 44607
/dev/sdd1:
         Events : 36570
/dev/sde1:
         Events : 44607

Is there any possibility of data recovery? For example by forcing
mdamd to think that the disks are synchronized?
As far as I know the disks should be synchronized because last time my
brother used the array he let it synchronize afterwards. Also I
haven't used "mdadm --create" yet as it might be dangerous and I am
not sure if all data saved in array are backed up.

Thank you for your time and any suggestions.

With kind regards,

Vojt=C4=9Bch Klete=C4=8Dka
