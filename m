From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID5 Shrinking array-size nearly killed the system
Date: Sat, 12 Mar 2011 12:58:58 -0500
Message-ID: <4D7BB462.5030706@turmel.org>
References: <AANLkTimrq904HRZfx6RpPrVNd0EJ5AkUZtytY7TqcFYv@mail.gmail.com>	<AANLkTikQ5_xm3+JKP8pR=oYO5xi6Qk1=VrSsiBkgtB6q@mail.gmail.com>	<alpine.DEB.1.10.1103120655370.7942@uplift.swm.pp.se>	<4D7B85EB.60505@turmel.org>	<AANLkTik2qk2ep7fsQPjAesnjur-0AB-Xx7EeZ5YfeCSA@mail.gmail.com> <AANLkTikRdqZ4nAdLcUuYz17KeWb54ES_sNYzzW-u1R0x@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikRdqZ4nAdLcUuYz17KeWb54ES_sNYzzW-u1R0x@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Rory Jaffe <rsjaffe@gmail.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[CC restored]

On 03/12/2011 12:37 PM, Rory Jaffe wrote:
> This is my plan now--did I get this right? -- thanks --
> 
> shutdown -r now # go to live cd
> umount /dev/md0 #just to make sure
> e2fsck /dev/md0
> resize2fs /dev/md0 3800G #3.2T currently in use
> shutdown -r now # go back to main system
> mdadm --grow /dev/md0 --array-size 4000000000
> mdadm -G -n 4 -x 2 --backup-file=/path/to/file.bak /dev/md0
> resize2fs /dev/md0

I would do everything in the LiveCD environment, and I would add an fsck after the resize, and again at the end.

In the LiveCD, there's a good chance the array will be assembled for you, but as a different number.  That shouldn't cause any problems, but it affects the commands you'll type.  "cat /proc/mdstat" will give you a quick summary of where you stand.

I can't comment on the size figures you've chosen, as you haven't shared the output of "mdadm -D /dev/md0" and "mdadm -E" for each of the component devices.

Also note that the backup file needed by mdadm cannot be *inside* the array you are resizing.  You *must* have another storage device for it.  I use a thumb drive with my LiveCD for this kind of task.

Phil
