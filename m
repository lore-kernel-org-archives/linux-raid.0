From: Neil Brown <neilb@suse.de>
Subject: Re: How to remove non-existant device
Date: Fri, 24 Sep 2010 07:54:49 +1000
Message-ID: <20100924075449.26c7e59d@notabene>
References: <20100923073029.GD19538@scavenger.homeip.net>
	<4C9B5323.3020201@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C9B5323.3020201@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Benjamin Schieder <blindcoder@scavenger.homeip.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 23 Sep 2010 14:16:19 +0100
John Robinson <john.robinson@anonymous.org.uk> wrote:

> On 23/09/2010 08:30, Benjamin Schieder wrote:
> > Hi all.
> >
> > On a SLES 10 SP 3 x86_64 version I'm encountering the following problem:
> >
> > Two disks sda and sdb are in a RAID 1 configuration. When pulling one
> > disk and replacing it it becomes sdc instead of sda. The RAID is now
> > degraded:
> >
> > kblhbe101:~ # cat /proc/mdstat
> > Personalities : [raid1] [raid0] [raid5] [raid4] [linear]
> > md2 : active raid1 sda8[2](F) sdb8[1]
> >        286125568 blocks [2/1] [_U]
> >
> > md0 : active raid1 sda5[2](F) sdb5[1]
> >        529984 blocks [2/1] [_U]
> >
> > md3 : active raid1 sda7[2](F) sdb7[1]
> >        4200896 blocks [2/1] [_U]
> >
> > md1 : active raid1 sda6[2](F) sdb6[1]
> >        2104384 blocks [2/1] [_U]
> >
> > unused devices:<none>
> >
> > But now I can't remove the sda partitions from the RAID:
> > kblhbe101:~ # mdadm /dev/md0 -r /dev/sda5
> > mdadm: cannot find /dev/sda5: No such file or directory
> > kblhbe101:~ # mdadm /dev/md0 -r sda5
> > mdadm: cannot find sda5: No such file or directory
> >
> > What am I doing wrong here?
> > kblhbe101:~ # mdadm --version
> > mdadm - v2.6 - 21 December 2006
> 
> Try `mdadm /dev/md0 -r missing`.

Close.  "missing" is only meaningful with --re-add.
You really want  "-r faileded" or "-r detached"

NeilBrown


> 
> Cheers,
> 
> John.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

