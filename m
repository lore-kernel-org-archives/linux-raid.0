From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: very strange (maybe) raid1 testing results
Date: Tue, 29 May 2007 21:52:32 -0500 (CDT)
Message-ID: <Pine.LNX.4.64.0705292135200.4266@gheavc.wnzcbav.cig>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I assembled a 3-component raid1 out of 3 4GB partitions.
After syncing, I ran the following script:

for bs in 32 64 128 192 256 384 512 768 1024 ; do \
 let COUNT="2048 * 1024 / ${bs}"; \
 echo -n "${bs}K bs - "; \
 dd if=/dev/md1 of=/dev/null bs=${bs}k count=$COUNT iflag=direct 2>&1 | 
 grep 'copied' ; \
done

I also ran 'dstat' (like iostat) in another terminal. What I noticed was 
very unexpected to me, so I re-ran it several times.  I confirmed my 
initial observation - every time a new dd process ran, *all* of the read 
I/O for that process came from a single disk. It does not (appear to) 
have to do with block size -  if I stop and re-run the script the next 
drive in line will take all of the I/O - it goes sda, sdc, sdb and back 
to sda and so on.

I am getting 70-80MB/s read rates as reported via dstat, and 60-80MB/s 
as reported by dd. What I don't understand is why just one disk is being 
used here, instead of two or more. I tried different versions of 
metadata, and using a bitmap makes no difference. I created the array 
with (allowing for variations of bitmap and metadata version):

mdadm --create --level=1 --raid-devices=3 /dev/md1 /dev/sda3 /dev/sdb3 /dev/sdc3

I am running 2.6.18.8-0.3-default on x86_64, openSUSE 10.2.

Am I doing something wrong or is something weird going on?

--
Jon Nelson <jnelson-linux-raid@jamponi.net>
