From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: Raid1 where Event Count off my 1 cannot assemble --force
Date: Sun, 08 Dec 2013 20:38:45 -0600
Message-ID: <52A52D35.7060909@suddenlinkmail.com>
References: <52A44778.8040502@suddenlinkmail.com> <alpine.DEB.2.02.1312081157100.24602@uplift.swm.pp.se> <52A4B311.6040204@suddenlinkmail.com> <52A51122.3030604@suddenlinkmail.com> <52A51442.1000903@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52A51442.1000903@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/08/2013 06:52 PM, Adam Goryachev wrote:
> Have you tried this:
> 
> mdadm --verbose --assemble /dev/md1 /dev/sdb5
> mdadm --manage /dev/md1 --run
> 
> Being raid1, you should be able to use only a single device....
> 
> 
> BTW, chances to recover your data should be exceptional, as long as you don't do
> anything too silly. You should even be able to mount the device directly
> (read-only):
> mount -o ro /dev/sdb5 /mnt
> 
> (Depending on the content is a filesystem).
> Then you can just backup the data, create a new array, and restore the data.
> Depending on data and size this might even be a better option...


Adam,

  Thank you for your suggestions. Here is the output attempting what you
suggested. The version is old (2.6.4), it is on the openSuSE install DVD for 11.0:

nemtemp:/mnt # mdadm --verbose --assemble /dev/md1 /dev/sdb5
mdadm: looking for devices for /dev/md1
mdadm: /dev/sdb5 is identified as a member of /dev/md1, slot 1.
mdadm: no uptodate device for slot 0 of /dev/md1
mdadm: added /dev/sdb5 to /dev/md1 as 1
mdadm: /dev/md1 assembled from 1 drive - need all 2 to start it (use --run to
insist).

nemtemp:/mnt # cat /proc/mdstat
Personalities : [raid1]
md2 : active raid1 sda7[0] sdb7[1]
      221929772 blocks super 1.0 [2/2] [UU]
      bitmap: 0/424 pages [0KB], 256KB chunk

md1 : inactive sdb5[1](S)
      20972752 blocks super 1.0

md0 : active raid1 sda1[0] sdb1[1]
      104376 blocks super 1.0 [2/2] [UU]
      bitmap: 0/7 pages [0KB], 8KB chunk

unused devices: <none>

nemtemp:/mnt # mdadm --run --verbose /dev/md1
mdadm: failed to run array /dev/md1: Input/output error
nemtemp:/mnt # tail /var/log/messages

Dec  9 02:30:20 Rescue kernel: raid1: raid set md1 active with 1 out of 2 mirrors
Dec  9 02:30:20 Rescue kernel: md1: bitmap file is out of date (148 < 149) --
forcing full recovery
Dec  9 02:30:20 Rescue kernel: md1: bitmap file is out of date, doing full recovery
Dec  9 02:30:20 Rescue kernel: md1: bitmap initialisation failed: -5
Dec  9 02:30:20 Rescue kernel: md1: failed to create bitmap (-5)
Dec  9 02:30:20 Rescue kernel: md: pers->run() failed ...

  I could boot with a newer recovery disk and see if a newer version of mdadm
would do things differently. I was using the original just to make sure I didn't
outsmart myself using a never version of mdadm than I would be running with
after repairing /dev/md1

  Hooray! I can mount the thing as -t ext3:

mdadm: stopped /dev/md1
nemtemp:/mnt # mount -o ro /dev/sdb5 /mnt/sdb/
mount: unknown filesystem type 'linux_raid_member'
nemtemp:/mnt # mount -t ext3 -o ro /dev/sdb5 /mnt/sdb/
nemtemp:/mnt # l sdb
total 116
drwxr-xr-x  21 root root  4096 2013-01-25 17:06 ./
drwxr-xr-x   7 root root   140 2013-12-08 06:38 ../
drwxr-xr-x   2 root root  4096 2010-12-05 06:43 bin/
drwxr-xr-x   2 root root  4096 2008-08-21 06:48 boot/
drwxr-xr-x   2 root root  4096 2008-08-22 01:54 data/
drwxr-xr-x   5 root root  4096 2008-08-21 06:48 dev/
drwxr-xr-x 129 root root 12288 2013-11-16 13:23 etc/
drwxr-xr-x   2 root root  4096 2008-08-21 06:48 home/
drwxr-xr-x  14 root root 12288 2011-01-14 20:13 lib/
drwx------   2 root root 16384 2008-08-21 06:43 lost+found/
drwxr-xr-x   2 root root  4096 2009-07-28 22:39 media/
drwxr-xr-x   8 root root  4096 2010-12-21 18:05 mnt/
drwxr-xr-x   5 root root  4096 2008-07-03 21:16 opt/
drwxr-xr-x   3 root root  4096 2008-08-21 06:48 proc/
drwx------  24 root root  4096 2013-10-01 20:58 root/
drwxr-xr-x   3 root root 12288 2010-12-27 23:15 sbin/
drwxr-xr-x   4 root root  4096 2008-09-11 07:26 srv/
drwxr-xr-x   3 root root  4096 2008-08-21 06:48 sys/
drwxrwxrwt   7 root root  4096 2013-11-19 15:15 tmp/
drwxr-xr-x  12 root root  4096 2010-01-24 01:41 usr/
drwxr-xr-x  15 root root  4096 2009-07-02 06:37 var/

  Now since I can mount it, how in the heck do I get the raid put back together.
Seems really simple, but I'm stuck... Try with a newer mdadm?


> BTW, the bitmap location looks.... strange...

  I thought so too, but checking the other arrays, /dev/md2 has a negative
number as well:

nemtemp:/mnt # mdadm -E /dev/sda7
/dev/sda7:
<snip>
Internal Bitmap : -213 sectors from superblock
    Update Time : Mon Dec  9 02:14:18 2013



-- 
David C. Rankin, J.D.,P.E.
