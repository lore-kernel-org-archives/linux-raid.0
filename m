From: Ian Pilcher <arequipeno@gmail.com>
Subject: Can running array device name change? - Was: Detecting that an array
 has been stopped
Date: Thu, 10 Oct 2013 23:48:50 -0500
Message-ID: <l37vv9$p4b$1@ger.gmane.org>
References: <l1ss60$fun$1@ger.gmane.org> <CAGqmV7pYMcupTobbbSW0D-Ykgwu5a4GyVAu8TCC9T9d08FbxOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7pYMcupTobbbSW0D-Ykgwu5a4GyVAu8TCC9T9d08FbxOg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

TL;DR: Is there any way that the kernel device name of a running MD RAID
       array (as shown in /proc/mdstat) can be changed without stopping
       the array?

On 09/27/2013 06:00 PM, CoolCold wrote:
> I'm a bit confused by what you mean with "swap names" - if you have
> proper mdadm.conf , you will get consistent array names even after
> stop/start cycle . Keeping mdadm.conf within initrd (many distros do
> this by default), will make you happy in case of reboot too.

Sorry for the delay in responding to this.  I've been off on a journey
to the darkest depths of pthreads, signals, and child processes.  Uugh!

Anyway ... The background to my original question is that I want my
monitoring daemon to deal is intelligently as is (reasonably) possible
with whatever the OS throws at it.  So while it's true that arrays that
are listed in mdadm.conf won't suffer from "unstable" device names, it's
also possible that not every array will always be listed.

In fact, my workstation currently shows the following in /proc/mdstat:

Personalities : [raid1] [raid10]
md126 : inactive dm-13[0] dm-12[4](F) dm-11[3] dm-10[2] dm-9[1](F)
      6288384 blocks super 1.2

md9 : active raid1 sda13[0] sdb13[1]
      81234872 blocks super 1.2 [2/2] [UU]
      bitmap: 0/1 pages [0KB], 65536KB chunk
...

It turns out that my host OS auto-detected the RAID array from my test
VM (which is why the component devices are logical volumes).  It
initially showed up as md127, and I've since changed its name by
stopping and reassembling it.

It's also possible that I (or someone else who wants to use the program)
may decide that worrying about array device numbers is simply
unnecessary.  Everything is on LVM anyway, so why do I really care what
device name is assigned to a particular array?

Here's what I've come up with:

1. My program maintains a list of known arrays, including each array's
   UUID (always) and last known kernel device name (if any).

2. At program startup, I read the UUIDs of "static" arrays from
   /etc/mdadm.conf.  static arrays are supposed to always be running;
   the program will alert if a static array is not present in
   /proc/mdstat.

3. When parsing an array in /proc/mdstat, I search the list for an array
   with a matching device name.  (The first time through, I obviously
   won't find any because I only read the UUIDs from mdadm.conf.)

4. If no array with a matching device name is found, I do the following:

   a. Open a file descriptor to the array's array_state file in sysfs.
   b. Use mdadm to read the UUID of the array.
   c. Search the list for array with a matching UUID.
   d. If I find an array with a matching UUID, I update its device name
      and replace its old file descriptor with the new one.
   e. If I don't find an array with a matching UUID, I add the new
      array to my list, marking it as "transient" (i.e. the program
      won't alert if it goes away).

5. If I found an array with a matching device name in step #3, I use
   lseek/read on its associated file descriptor to attempt to read the
   first byte of its array_state file.  I have found that the read will
   result in an ENODEV if the array has been stopped at any time since
   the file descriptor was originally opened (even if the same array or
   a different array has subsequently been started with the same device
   name).

6. If the read in step #5 succeeds, then I know that the array has not
   been stopped since I opened the file descriptor.  AFAIK, this means
   that it's kernel device name has not changed, since I do not believe
   that there is any that the device name of a running array can change.

7. If the read in step #5 causes an ENODEV error, then I know that the
   array that was using this device name at my last scan of /proc/mdstat
   has been stopped.  The array that is now using the device name may or
   may not be the same array, so I do the following:

   a. Close its (now useless) file descriptor.
   b. Clear the array's device name in my list.  (The UUID is the
      canonical identifier, not the name.)
   c. Treat the array as if its device name were newly encountered;
      goto step 4a.

At a higher level, this allows me to do the following:

1. Read /proc/mdstat.

2. Parse /proc/mdstat, checking for any potential device name changes or
   or new arrays since the last scan.

3. If any potential name changes or new arrays are encountered, go back
   to step #1.

Once this loop completes (which will almost always be in a single pass),
I can be confident that the /proc/mdstat contents that I'm parsing
correspond to a known device name <--> UUID mapping.

Of course this all only works if my assumption that the kernel device
name of an array can't change while the array is running is correct.

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
Sometimes there's nothing left to do but crash and burn...or die trying.
========================================================================

