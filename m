From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID SCSI binding
Date: Sat, 1 Mar 2003 07:49:58 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15967.52086.864201.674739@notabene.cse.unsw.edu.au>
References: <015d01c2df23$9c22f020$f6de11cc@black>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Black on Friday February 28
To: Mike Black <mblack@csi-inc.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Friday February 28, mblack@csi-inc.com wrote:
> Linux 2.4.20 (but not unique to this kernel -- been this way for over a year):
> I have a RAID5 array that doesn't startup properly during boot (I have to stop it and restart after the system is up).  I've had
> this problem forever and have been trying to fix it.
> Here's what it looks like when it's up and running:
> md4 : active raid5 sdn1[0] sdt1[6] sds1[5] sdr1[4] sdq1[3] sdp1[2] sdo1[1]
>      216490752 blocks level 5, 128k chunk, algorithm 0 [7/7] [UUUUUUU]
> The partitions types are set to 0x83 and the array is being manually
> started in rc.local instead of doing auto-start.

What tool are you using to start the array? raidstart or mdadm?
There doesn't seem to be enough noise in the logs for it to be
raidstart (no "md: autorun ...") so I assume mdadm.

What do you get if you add "-v" to the mdadm running from rc.local?
Can you show me
  mdadm -E /dev/sda1 /dev/sdo1

NeilBrown

> 
> So it looks to me like the md driver doesn't like the raid system crossing the major device boundary for some odd reason.
> Although I'm not sure why I can stop and restart after the system is totally up but not start it in rc.local using the same
> commands:

I suspect this is just a co-incidence.  I cannot imagine how the major
device number could affect things at all.

NeilBrown
