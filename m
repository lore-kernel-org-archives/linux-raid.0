From: Neil Brown <neilb@suse.de>
Subject: Re: array doesn't run even with --force
Date: Mon, 21 Jan 2008 14:09:20 +1100
Message-ID: <18324.3296.548839.160381@notabene.brown>
References: <18323.53416.900135.357320@fisica.ufpr.br>
	<18323.61892.577574.287408@notabene.brown>
	<18324.2330.580360.676531@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Carlos Carvalho on Monday January 21
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday January 21, carlos@fisica.ufpr.br wrote:
> 
> The command is
> 
> mdadm -A --verbose -f -R /dev/md3 /dev/sda4 /dev/sdc4 /dev/sde4 /dev/sdd4
> 
> The failed areas are sdb4 (which I didn't include above) and sdd4. I
> did a "dd if=/dev/sdb4 of=/dev/hda4 bs=512 conv=noerror" and it
> complained about roughly 10 bad sectors. I did "dd if=/dev/sdd4
> of=/dev/hdc4 bs=512 conv=noerror" and there were no errors, that's why
> I used sdd4 above. I tried to substitute hdc4 for sdd4, and hda4 for
> sdb4, to no avail.
> 
> I don't have kernel logs because the failed area has /home and /var.
> The double fault occurred during the holidays, so I don't know which
> happened first. Below are the output of the command above and of
> --examine.
> 
> mdadm: looking for devices for /dev/md3
> mdadm: /dev/sda4 is identified as a member of /dev/md3, slot 0.
> mdadm: /dev/sdc4 is identified as a member of /dev/md3, slot 2.
> mdadm: /dev/sde4 is identified as a member of /dev/md3, slot 4.
> mdadm: /dev/sdd4 is identified as a member of /dev/md3, slot 5.
> mdadm: no uptodate device for slot 1 of /dev/md3
> mdadm: added /dev/sdc4 to /dev/md3 as 2
> mdadm: no uptodate device for slot 3 of /dev/md3
> mdadm: added /dev/sde4 to /dev/md3 as 4
> mdadm: added /dev/sdd4 to /dev/md3 as 5
> mdadm: added /dev/sda4 to /dev/md3 as 0
> mdadm: failed to RUN_ARRAY /dev/md3: Input/output error
> mdadm: Not enough devices to start the array.

So no device claim to be member '1' or '3' of the array, and as you
cannot start an array with 2 devices missing, there is nothing that
mdadm can do.  It has no way of knowing what should go in as '1' or
'3'.

As you note, sda4 says that it thinks slot 1 is still active/sync, but
it doesn't seem to know which device should go there either.
However that does indicate that slot 3 failed first and slot 1 failed
later.  So if we have candidates for both, slot 1 is probably more
uptodate.

You need to tell mdadm what goes where by creating the array.
e.g. if you think that sdb4 is adequately reliable and that it was in
slot 1, then

 mdadm -C /dev/md3 -l5 -n5 -c 128 /dev/sda4 /dev/sdb4 /dev/sdc4 missing /dev/sde4

alternately if you think it best to use sdd, and it was in slot 3,
then

 mdadm -C /dev/md3 -l5 -n5 -c 128 /dev/sda4 missing /dev/sdc4 /dev/sdd4 /dev/sde4

would be the command to use.

Note that this command will not touch any data.  It will just
overwrite the superblock and assemble the array.
You can then 'fsck' or whatever to confirm that the data looks good.

good luck.

NeilBrown
