From: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>
Subject: Re: I'm about ready to do SW-Raid5 - pointers needed
Date: Tue, 28 Oct 2003 09:39:41 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310280939.41974.dusty@strike.wu-wien.ac.at>
References: <Pine.LNX.4.44.0310281610290.11061-100000@gw.luko.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0310281610290.11061-100000@gw.luko.org>
Content-Disposition: inline
To: Luke Rosenthal <luke@luko.org>, maarten van den Berg <maarten@vbvb.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 28 October 2003 06:37, Luke Rosenthal wrote:
> On Tue, 28 Oct 2003, maarten van den Berg wrote:
> > One of the cheapest "backup" mediums right now are harddisks themselves
> > (weird, isn't it?) so it stands to reason some people try to build
> > something that is foolproof (at least against hardware failure) using
> > that, just disks.
>
> Ok, most folks would argue that hard disk failure is a byproduct of them
> being run continuously.  Especially in the case of IDE disks, which are
> usually cheaper than their SCSI counterparts on a cost-per-MB ratio, but
> consequently have a much shorter MTBF.
>
> So here's my question - would it be possible to use a very large IDE disk
> in a system purely for backups, eg one of those new 300GB behemoths - but
> with one caveat - leave it "asleep".  Ie. leave it "spun down", and only
> activate it once a day at backup time, run the backup, verify it, then
> unmount it, and put it to sleep in a cron job.  Feasible?

I think that would be o.k. The system normally deals good with spun down 
disks.

> I know there's the appropriate commands to do it, but are they risky?  If
> a drive's not mounted, but powered off, it should present no problems or
> lock up the OS, correct?

No, many laptop users are spinning down they root disk, so I don't think there 
are problems.

> Everyone's got a horror story.. :)  and most people learn from it :)

Some more thoughts to the backup problem:
- When a system gets very reliable (with RAID etc.) the possibility that a 
user does a "rm *" gets more likely than a hardware/software failure.

- Most users only have very little data that's worth backing up. When looking 
at myself, there is not much more than 300MB of data and this is compressable 
to ~ 150MB. But my homedir is filled up with a *lot* of junk that sums up to 
~ 2GB. One possibility to deal with this is that the user denotes the 
directories he wants to backup in a text file (or maybe web interface).

		Best Regards,
		Hermann

-- 
x1@aon.at
GPG key ID: 299893C7 (on keyservers)
FP: 0124 2584 8809 EF2A DBF9  4902 64B4 D16B 2998 93C7

