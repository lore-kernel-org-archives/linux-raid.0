From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: raid 5 to raid 6 reshape gone bad
Date: Sat, 12 Nov 2011 19:33:24 -0800
Message-ID: <4dq3p8xsef.ln2@goaway.wombat.san-francisco.ca.us>
References: <E427BB45-7AA7-422C-AAFE-9778286BF64C@jetcom.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2011-11-13, Travis Brown <teb@jetcom.org> wrote:
> I was reshaping my 5 drive raid 5 with spare to a raid 6 array when the drive I was using for my backup went offline.  If that's not murphy's law, I don't know what is.  The array is still up and usable, but I'm afraid to reboot or doing anything to it, really.  Suggestions on getting this thing back to usable are very welcome. 

> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
> md126 : active raid6 sde3[0] sdf3[3] sdb3[1] sdd3[4] sdc3[2]
>       5856728064 blocks super 0.91 level 6, 512k chunk, algorithm 18 [5/4] [UUUU_]

Do you have hot-swap drives?  If so, simply mark sdd3 as faulty with
mdadm, remove it from the array, then physically remove and replace it
and use mdadm to add the new drive.  The raid6 should start to rebuild
automatically.

If you don't have hot-swap drives, you should still be able to use mdadm
to set faulty and remove sdd3, shut down, replace sdd, and reboot.  Make
sure your /etc/mdadm.conf file is up to date and accurate before
shutting down.  Alternatively, make sure mdadm *won't* probe for raid
arrays, and instead assemble it manually after booting; that might be a
more sure way to do it.  Either way, with four working disks your new
raid6 can still suffer one more drive failure and still be usable.

Of course, insert the standard disclaimer about RAID not being a
replacement for backups.  :)  If it won't take too long, you might
consider doing and/or refreshing your backups before attempting
anything.  (The hot-swap method is reasonably safe as long as you're
*positive* you're removing the correct disk.)

--keith



-- 
kkeller@wombat.san-francisco.ca.us


