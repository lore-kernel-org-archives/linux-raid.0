From: "Michael Schwarz" <mschwarz@multitool.net>
Subject: Behavior of mdadm depending on user
Date: Mon, 2 Jul 2007 21:10:04 -0500 (CDT)
Message-ID: <4168.72.21.237.163.1183428604.squirrel@www.multitool.net>
Reply-To: mschwarz@multitool.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This ia just a couple of quick questions.

I'm charged with developing a prototype application that will assemble and
mount a hot-swapped drive array, mount it, transfer files to it, unmount it,
and stop the array. And it is an application delivered by a local webserver
(don't ask).

I don't want to do any of the incredibly stupid acts of making madadm and
mount/umount setuid root, nor do I want to run the webserver as root.

Instead, I took the slightly less stupid approach of invoking madadm and
mount/umount with a hardcoded C application that is setuid root. (We can
debate the stupidity of this -- I know it isn't best, but it is fast and less
stupid than the alternatives presented above).

An important part of the functionality uses the array's UUID to recognize the
owner and account of the array. (Yes, a password not stored on the array is
still required).

Anyways, my little C wrapper works. But to get the UUID of the array I thought
I could just run "mdadm" as an unprivledged user, provided that user had rw
access to the md device. This turns out not to be the case. If I run:

mdadm -D /dev/md5

as the non-priv user, it tells me /dev/md5 doesn't appear to be an MD device.
The user has group rw permission on the device.

Run the same thing as root and you get all the info, including UUID.

So: Two quick questions:

1) Is it possible for a non-root user to get the UUID of an active MD drive
array with "mdadm."

2) If not, is there another way (or better way) to get the UUID of an active
MD drive array? I did a cursory poke around /proc but didn't see anything.

Obviously, feel free to tell me to RTFM or RTFC, but a direction to the
appropriate FM or FC (effing code) would be most welcome.

In any case, a big "thank you" to everyone who works on Linux software RAID. I
have had a complete BLAST using the feature. I now routinely make 2-3 USB
drive RAID 0 arrays just for fun (and faster write speed!).

It is a very nice feature and set of tools!

-- 
Michael Schwarz


