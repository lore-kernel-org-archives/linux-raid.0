From: Ross Vandegrift <ross@willow.seitz.com>
Subject: Re: Couldn't umount on /mnt/md0-device busy???
Date: Thu, 18 Jul 2002 13:47:20 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020718174720.GD4712@willow.seitz.com>
References: <Pine.LNX.4.33.0207161515560.29547-100000@pandora.is.bizsystems.com> <15668.41627.988382.451061@notabene.cse.unsw.edu.au> <003c01c22db8$57b86590$5701a8c0@bomoon> <3D35BCD6.7030300@cfht.hawaii.edu> <06d001c22def$eaa10510$5701a8c0@bomoon> <009d01c22e54$54d968a0$f6de11cc@black> <073d01c22e7e$299d8020$5701a8c0@bomoon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <073d01c22e7e$299d8020$5701a8c0@bomoon>
To: bo <bo@sosnetwork.net>
Cc: Mike Black <mblack@csi-inc.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jul 18, 2002 at 10:11:31AM -0700, bo wrote:
> Mike,
> 
> It does not matter with the order in /etc/exports.
> This "umount" problem goes away when I remove "/mnt/md0" entry from
> /etc/exports.  I have 3 more;/mnt/md1, /mnt/md2, /mnt/md3 without any
> problem.
> 
> I think system has a special meaning with "/mnt/md0".  What does it do???

Perhaps:

1) A remote machine has a mount of /mnt/md0
2) Your server has a stale mount record for /mnt/md0
3) Something has wacked out lockd, which is keeping stuff locked

Try "showmount" and see if any machines have your filesystems mounted
when you think they shouldn't.

If some machine has a stale NFS mount, you may need to clear out the
saved statd information.

Ross Vandegrift
ross@willow.seitz.com
