From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: array doesn't run even with --force
Date: Mon, 21 Jan 2008 01:27:01 -0200
Message-ID: <18324.4357.127449.627031@fisica.ufpr.br>
References: <18323.53416.900135.357320@fisica.ufpr.br>
	<18323.61892.577574.287408@notabene.brown>
	<18324.2330.580360.676531@fisica.ufpr.br>
	<18324.3296.548839.160381@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18324.3296.548839.160381@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown (neilb@suse.de) wrote on 21 January 2008 14:09:
 >As you note, sda4 says that it thinks slot 1 is still active/sync, but
 >it doesn't seem to know which device should go there either.
 >However that does indicate that slot 3 failed first and slot 1 failed
 >later.  So if we have candidates for both, slot 1 is probably more
 >uptodate.

I was going home (it's 1h20 past midnight) when I remembered and came
back to write that assembling with
/dev/sda4 /dev/sdb4 /dev/sdc4 missing /dev/sde4

"works", which confirms what you say. Adding sdd4 back it
starts resyncing, however since sdb4 has errors, a double fault
happens again and the array fails.

 >You need to tell mdadm what goes where by creating the array.
 >e.g. if you think that sdb4 is adequately reliable and that it was in
 >slot 1, then
 >
 > mdadm -C /dev/md3 -l5 -n5 -c 128 /dev/sda4 /dev/sdb4 /dev/sdc4 missing /dev/sde4
 >
 >alternately if you think it best to use sdd, and it was in slot 3,
 >then
 >
 > mdadm -C /dev/md3 -l5 -n5 -c 128 /dev/sda4 missing /dev/sdc4 /dev/sdd4 /dev/sde4
 >
 >would be the command to use.
 >
 >Note that this command will not touch any data.  It will just
 >overwrite the superblock and assemble the array.
 >You can then 'fsck' or whatever to confirm that the data looks good.

I have two possibilities: use sdd4 in slot 3 or the dump of sdb4 in
another disk in slot 1. This copy is more recent but has errors. Is it
possible to know which would be "less bad" before I fsck?
