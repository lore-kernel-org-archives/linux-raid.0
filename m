From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Fail to assemble raid4 with replaced disk
Date: Tue, 25 Oct 2016 18:50:32 +0100
Message-ID: <580F9B68.9010105@youngman.org.uk>
References: <CAJh8RqUjr7L_Of0fbW_mAXshmmgcPdXvhtsvhFXKF+XxjOTrFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJh8RqUjr7L_Of0fbW_mAXshmmgcPdXvhtsvhFXKF+XxjOTrFw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Santiago DIEZ <santiago.diez@caoba.fr>, Linux Raid LIST <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 25/10/16 18:08, Santiago DIEZ wrote:
> Hi Raiders,

This looks like a fairly simple recovery job - but you will probably
lose a little data - fsck will moan about a few new files being corrupted.

Firstly, DON'T DO ANYTHING WITH THE RAID.

Secondly, go to the linux raid wiki
https://raid.wiki.kernel.org/index.php/Linux_Raid and read section 4
"When things go wrogn". You've messed up replacing the failed drive, and
are now at "My raid won't assemble/run". But as I say, it doesn't look
particularly serious.
> 
> I had a raid5 array md10 with sd[abcd]10.
> Eventually, sdd10 failed.
> 
> I did NOT do any mdadm --fail NOR mdadm --remove command.
> What I did is comment out the line "ARRAY /dev/md10 ..." in
> /etc/mdadm/mdadm.conf.

mdadm.conf is somewhat of a relic from a bygone age, I believe. It used
to be necessary, in the new world of raid superblocks it is mostly
ignored and redundant.
> 
> Then I powered off the server, replaced the disk sdd with a new one
> and booted the system.
> 
> I examined the status with:
> # cat /proc/mdstat
> md10 : inactive sdb10[1]
>       1926247296 blocks
> 
> I stopped the array with:
> # mdadm --stop /dev/md10
> 
> I tried to assemble the array with the 3 original disks like this
> # mdadm --assemble /dev/md10 --verbose /dev/sda10 /dev/sdb10 /dev/sdc10
> mdadm: looking for devices for /dev/md10
> mdadm: /dev/sda10 is identified as a member of /dev/md10, slot 0.
> mdadm: /dev/sdb10 is identified as a member of /dev/md10, slot 1.
> mdadm: /dev/sdc10 is identified as a member of /dev/md10, slot 2.
> mdadm: added /dev/sda10 to /dev/md10 as 0 (possibly out of date)
> mdadm: added /dev/sdc10 to /dev/md10 as 2 (possibly out of date)
> mdadm: no uptodate device for slot 3 of /dev/md10
> mdadm: added /dev/sdb10 to /dev/md10 as 1
> mdadm: /dev/md10 assembled from 1 drive - not enough to start the array.

Okay. It's got three drives. When you've done what "Asking for help"
says, you should have event counts for all those three drives -
sd[abc]10. Hopefully they're all pretty much the same. If they are, a
simple "--assemble --force" should get your array up and running again.

The complaint about slot 3 is because you haven't removed the old sdd10,
and the new sdd10 isn't part of the array, it has no superblock.
> 
> I examined the status again with:
> # cat /proc/mdstat
> md10 : inactive sdb10[1](S) sdc10[2](S) sda10[0](S)
>       5778741888 blocks
> 
> Now I'm SCARED!
> What does the (S) mean?
> How do I reassemble my array and add the new sdd10 partition?
> 
> Thanks for your help
> 
Okay. That leaves your recovery path neatly mapped out. Get the event
count of the three remaining drives and post them here. Wait for an
expert to muck in and say it all looks good. Then

Assemble the array with --force
Remove the old sdd10
Add the new sdd10
Run a fsck.

And your array should all be back fine. One thing - the wiki bangs on
about the timeout problem. Is that your problem? Because if it is you
will have grief trying to get the array back unless you fix that as your
very first step.

Cheers,
Wol

