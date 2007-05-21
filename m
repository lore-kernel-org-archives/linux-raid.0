From: "Chris Fanning" <christopher.fanning@gmail.com>
Subject: not resyncing after power cut.
Date: Mon, 21 May 2007 17:08:47 +0200
Message-ID: <215ff4410705210808g779ba32dhee018f0bd81382d8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've got a couple of doubts.

Since more than a year ago I setup mdadm raid1 on new instalations
(thanks for your work).
On the older machines, mdadm -D shows them in a dirty state. I know
that this is/was as expected. If there is a power cut, the machine
boots and a dirty array is resynced, =BFright?

On newer installations, mdadm -D shows arrays in a clean state. I had
always thought that this was ok becuase I'd read somewhere that the
term 'dirty' was causing confusion and it got changed.
So, state: clean, is what I should expect?

Last week we had a power cut and when the machines booted all arrays
where brought up.
I'm running debian etch and got
INITRDSTART=3D'all'
AUTOSTART=3D"all"
Soon after one of the machines booted, I got users calling me saying
that documents were disappearing ar becoming corrupted. I looked at
cat /proc/mdstat and saw that nothing was being resynced.
I stopped the array, then removed and added one of the partitions to
resync it (could I have done the same using
/usr/share/mdadm/checkarray ?)
Then I ran fsck.ext3 on it (the /dev/md1) . it came back clean. so I
ran fsck.ext3 -f and got lots of errors. Anyway, things are back to
normal now.

So today I installed etch on a new box to try and learn more about this=
=2E
To test, I start copying onto the mdadm device and then hit the reset
button on the pc.
On boot, everything starts as normal. no resync, nothing.

Can someone shed some light on this for me please?
Does it have something to do with initramfs?

Thanks.
Chris.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
