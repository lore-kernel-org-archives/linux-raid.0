From: Steve Carlson <stevengcarlson@gmail.com>
Subject: RAID0 partition set to spare
Date: Fri, 30 Dec 2011 02:21:25 -0600
Message-ID: <CA+q4O7N5D7c-dDYtW_BH3tUPK2NdAnq0agMAczTXQKji=QH3dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm an enthusiast and don't have any experience managing raids.  I got
here through a series of steps starting out in basic linux help on
IRC, so bear with me if I don't know how to do something and please
try to be verbose/explicit in responses.

I have a Synology DS207 2 drive NAS that I set up in RAID0 using their
automated tools back in 2008.  I didn't manually set the raid up, so I
have no implicit knowledge on how it's all held together.  I had an
electrician over and went through a series of power cycles, and the
disks were in their current state when he had left (Dec 21ish).  MD2
refuses to assemble without adding SDB3 as swap.

Syonology uses a slimmed down embedded BusyBox install.  I have photos
on the disk that aren't backed up, so I'd really prefer to keep the
data intact, but completely understand I took the risk of losing the
data with RAID0.

I didn't want a 20 page email, so hopefully http links with the
pertinent info will be acceptable.

Marble> uname -a
Linux Marble 2.6.24 #1594 Fri Feb 25 19:00:24 CST 2011 ppc GNU/Linux
synology_ppc824x_207

cat /proc/mdstat
http://dl.dropbox.com/u/2776371/raid/cat_proc_mdstat.txt

mdadm --examine
http://dl.dropbox.com/u/2776371/raid/mdadm_examine_all_drives.txt

smartctl -a /dev/sda
http://dl.dropbox.com/u/2776371/raid/smartctl_a_sda.txt

smartctl -a /dev/sdb
http://dl.dropbox.com/u/2776371/raid/smartctl_a_sdb.txt

cat /var/log/messages | grep 'error'
http://dl.dropbox.com/u/2776371/raid/cat_var_log_messages_pipe_grep_error.txt

mdadm --stop /dev/md2 && mdadm --assemble /dev/md2 /dev/sd[ab]3
http://dl.dropbox.com/u/2776371/raid/stop_assemble_md2_dmesg.txt

mdadm --stop /dev/md2 && mdadm --assemble --force /dev/md2 /dev/sd[ab]3
http://dl.dropbox.com/u/2776371/raid/stop_assemble_force_md2_dmesg.txt

dmesg from boot
http://dl.dropbox.com/u/2776371/raid/boot_dmesg.txt

Please let me know if there's any other info I can provide to help
diagnose the issue.

Thanks in advance.
