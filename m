From: starlight.2012q4@binnacle.cx
Subject: Re: question: no-bitmap RAID1 with off-site drive
Date: Mon, 12 Nov 2012 12:26:25 -0500
Message-ID: <6.2.5.6.2.20121112122534.05dfec78@binnacle.cx>
References: <6.2.5.6.2.20121111163935.05df8b18@binnacle.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6.2.5.6.2.20121111163935.05df8b18@binnacle.cx>
References: <6.2.5.6.2.20121111163935.05df8b18@binnacle.cx>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After some pondering, think I've figure it out.

Best way to go is to set it up with

  --create --level=1 --raid-devices=2

for the initial pair of drives, then

  --fail --remove

the rotate-out drive, then

  --add

the alternate drive.  Now there will be
three drive slots with one "removed" and two
"active".

To rotate a drive off-site

   --fail --remove

go to the off-site, swap the drives and on return

   --re-add

the rotate-in drive.

This way the 'mdadm' UUID labels will stay on the
drives and 'mdadm' will warn against mistakes
such as trying to use the wrong drive for
a mirror pair.  Will always have one "removed"
drive.

The

   --grow --raid-devices=1 --force

and

   --grow --raid-devices=2 --add

would be used only if a drive fails and needs to
be replaced.

If anyone disagrees please advise.

