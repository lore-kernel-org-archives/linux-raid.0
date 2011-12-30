From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: RAID0 partition set to spare
Date: Fri, 30 Dec 2011 11:58:30 +0100
Message-ID: <4EFD9956.5050703@redhat.com>
References: <CA+q4O7N5D7c-dDYtW_BH3tUPK2NdAnq0agMAczTXQKji=QH3dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+q4O7N5D7c-dDYtW_BH3tUPK2NdAnq0agMAczTXQKji=QH3dw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Carlson <stevengcarlson@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/30/11 09:21, Steve Carlson wrote:
> I'm an enthusiast and don't have any experience managing raids.  I got
> here through a series of steps starting out in basic linux help on
> IRC, so bear with me if I don't know how to do something and please
> try to be verbose/explicit in responses.
> 
> I have a Synology DS207 2 drive NAS that I set up in RAID0 using their
> automated tools back in 2008.  I didn't manually set the raid up, so I
> have no implicit knowledge on how it's all held together.  I had an
> electrician over and went through a series of power cycles, and the
> disks were in their current state when he had left (Dec 21ish).  MD2
> refuses to assemble without adding SDB3 as swap.
> 
> Syonology uses a slimmed down embedded BusyBox install.  I have photos
> on the disk that aren't backed up, so I'd really prefer to keep the
> data intact, but completely understand I took the risk of losing the
> data with RAID0.
> 
> I didn't want a 20 page email, so hopefully http links with the
> pertinent info will be acceptable.
> 
> Marble> uname -a
> Linux Marble 2.6.24 #1594 Fri Feb 25 19:00:24 CST 2011 ppc GNU/Linux
> synology_ppc824x_207
> 
> cat /proc/mdstat
> http://dl.dropbox.com/u/2776371/raid/cat_proc_mdstat.txt
> 
> mdadm --examine
> http://dl.dropbox.com/u/2776371/raid/mdadm_examine_all_drives.txt
> 
> smartctl -a /dev/sda
> http://dl.dropbox.com/u/2776371/raid/smartctl_a_sda.txt
> 
> smartctl -a /dev/sdb
> http://dl.dropbox.com/u/2776371/raid/smartctl_a_sdb.txt
> 
> cat /var/log/messages | grep 'error'
> http://dl.dropbox.com/u/2776371/raid/cat_var_log_messages_pipe_grep_error.txt
> 
> mdadm --stop /dev/md2 && mdadm --assemble /dev/md2 /dev/sd[ab]3
> http://dl.dropbox.com/u/2776371/raid/stop_assemble_md2_dmesg.txt
> 
> mdadm --stop /dev/md2 && mdadm --assemble --force /dev/md2 /dev/sd[ab]3
> http://dl.dropbox.com/u/2776371/raid/stop_assemble_force_md2_dmesg.txt
> 
> dmesg from boot
> http://dl.dropbox.com/u/2776371/raid/boot_dmesg.txt
> 
> Please let me know if there's any other info I can provide to help
> diagnose the issue.

Hi Steve,

Posting the error messages like this is great - certainly works for me.

Looking at your error messages, I am not overly optimistic for you
unfortunately :( It looks to me like your sdb has some bad sectors on it
(even though smart claims it passed), and it therefore is unable to read
the raid metadata on /dev/sdb3 :( Note that the error counts on both
drives are *very* high, at least compared to the drives I have here.

Could you try and run this:

mdadm --stop /dev/md2
dmesg -c (this clears the dmesg log)
mdadm --assemble /dev/md2 /dev/sd[ab]3

then post the output from dmesg? I'd like to see if you get read errors
at this exact point.

Unless there is a secondary backup of the metadata elsewhere on the
partition, or you can force/trick mdadm into ignoring the metadata on
sdb3 and rely solely on the info found on sda3 (however I am not sure if
this is possible), then I suspect you are out of luck.

Neil may have some ideas for this.

I presume you tried letting the system shut down and cool off completely
before trying to bring it back up? Just in case it has been running very
hot for a long time?

Cheers,
Jes
