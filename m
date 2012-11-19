From: starlight.2012q4@binnacle.cx
Subject: Re: question: no-bitmap RAID1 with off-site drive
Date: Sun, 18 Nov 2012 19:11:56 -0500
Message-ID: <6.2.5.6.2.20121118185613.05e63580@binnacle.cx>
References: <6.2.5.6.2.20121111163935.05df8b18@binnacle.cx>
 <6.2.5.6.2.20121112122534.05dfec78@binnacle.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6.2.5.6.2.20121112122534.05dfec78@binnacle.cx>
References: <6.2.5.6.2.20121111163935.05df8b18@binnacle.cx>
 <6.2.5.6.2.20121112122534.05dfec78@binnacle.cx>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Started playing with the third drive
and my invented approach may not
be correct.  That, as recommended,
using --grow to eliminate the offsite
"removed" drive and put back the
rotate-in drive is right.

It looks like MD re-initializes the
superblock (different UUID) when
something like

  mdadm --grow --add --raid-devices=3 /dev/md3 /dev/sde

is run, even if /dev/sde has a previous
superblock from the same array.  However
I only tested it with a drive image that
had not been fully synced and from the
same (not different) array.  Running

   mdadm --re-add /dev/md3 /dev/sde

results 'mdadm' refusing the
drive that had been from the
same array (though not fully synced).

Appears then that 'mdadm' may not
check the superblock to see if the
drive came from a different array
and should not be overwritten, and
instead prefers to just zap it.

Can anyone confirm or deny the
possibility?  I can manually run
an --examine and check the array
name as a precaution when rotating
drives if 'mdadm' doesn't perform
the check.  Want to avoid inserting
a offsite drive in the wrong array.




At 12:26 PM 11/12/2012 -0500, starlight.2012q4@binnacle.cx wrote:
>After some pondering, think I've figure it out.
>
>Best way to go is to set it up with
>
>  --create --level=1 --raid-devices=2
>
>for the initial pair of drives, then
>
>  --fail --remove
>
>the rotate-out drive, then
>
>  --add
>
>the alternate drive.  Now there will be
>three drive slots with one "removed" and two
>"active".
>
>To rotate a drive off-site
>
>   --fail --remove
>
>go to the off-site, swap the drives and on return
>
>   --re-add
>
>the rotate-in drive.
>
>This way the 'mdadm' UUID labels will stay on the
>drives and 'mdadm' will warn against mistakes
>such as trying to use the wrong drive for
>a mirror pair.  Will always have one "removed"
>drive.
>
>The
>
>   --grow --raid-devices=1 --force
>
>and
>
>   --grow --raid-devices=2 --add
>
>would be used only if a drive fails and needs to
>be replaced.
>
>If anyone disagrees please advise.

