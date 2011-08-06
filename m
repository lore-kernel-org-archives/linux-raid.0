From: NeilBrown <neilb@suse.de>
Subject: Re: Need help recovering RAID5 array
Date: Sat, 6 Aug 2011 11:29:10 +1000
Message-ID: <20110806112910.332d450a@notabene.brown>
References: <4E3C0BCA.9000407@uml.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E3C0BCA.9000407@uml.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Stephen Muskiewicz <stephen_muskiewicz@uml.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 5 Aug 2011 11:27:06 -0400 Stephen Muskiewicz
<stephen_muskiewicz@uml.edu> wrote:

> Hello,
> 
> I'm hoping to figure out how I can recover a RAID5 array that suddenly 
> won't start after one of our servers took a power hit.
> I'm fairly confident that all the individual disks of the RAID are OK 
> and that I can recover my data (without having to resort to asking my 
> sysadmin to fetch the backup tapes), but despite my extensive Googling 
> and reviewing the list archives and mdadm manpage, so far nothing I've 
> tried has worked.  Hopefully I am just missing something simple.
> 
> Background: The server is a Sun X4500 (thumper) running CentOS 5.5.  I 
> have confirmed using the (Sun provided) "hd" utilities that all of the 
> individual disks are online and none of the device names appear to have 
> changed from before the power outage.  There are also two other RAID5 
> arrays as well as the /dev/md0 RAID1 OS mirror on the same box that did 
> come back cleanly (these have ext3 filesystems on them, the one that 
> failed to come up is just a raw partition used via iSCSI if that makes 
> any difference.)  The array that didn't come back is /dev/md/51, the 
> ones that did are /dev/md/52 and /dev/md/53.  I have confirmed that all 
> three device files do exist in /dev/md.  (/dev/md51 is also a symlink to 
> /dev/md/51, as are /dev/md52 and /dev/md53 for the working arrays).  We 
> also did quite a bit of testing on the box before we deployed the arrays 
> and haven't seen this problem before now, previously all of the arrays 
> came back online as expected.  Of course it has also been about 7 months 
> since the box has gone down but I don't think there were any major 
> changes since then.
> 
> When I boot the system (tried this twice including a hard power down 
> just to be sure), I see "mdadm: No suitable drives found for /dev/md51". 
>   Again the other 2 arrays come up just fine.  I have checked that the 
> array is listed in /etc/mdadm.conf
> 
> (I will apologize for a lack of specific mdadm output in my details 
> below, the network people have conveniently (?) picked this weekend to 
> upgrade the network in our campus building and I am currently unable to 
> access the server until they are done!)
> 
> "mdadm --detail /dev/md/51" does (as expected?) display: "mdadm: md 
> device /dev/md51 does not appear to be active"
> 
> I have done an "mdadm --examine" on each of the drives in the array and 
> each one shows a state of "clean" with a status of "U" (and all of the 
> other drives in the sequence shown as "u").  The array name and UUID 
> value look good and the "update time" appears to be about when the 
> server lost power.  All the checksums read "correct" as well.  So I'm 
> confident all the individual drives are there and OK.
> 
> I do have the original mdadm command used to construct the array. 
> (There are 8 active disks in the array plus 2 spares.)  I am using 
> version 1.0 metadata with the -N arg to provide a name for each array.
> So I used this command with the assemble option (but without the -N or 
> -u) options:
> 
> mdadm -A /dev/md/51 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 
> /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1
> 
> But this just gave the "no suitable drives found" message.
> 
> I retried the mdadm command using -N <name> and -u <UUID> options but in 
> both cases saw the same result.
> 
> One odd thing that I noticed was that when I ran an:
> mdadm --detail --scan
> 
> The output *does* display all three arrays, but the name of the arrays 
> shows up as "ARRAY /dev/md/<arrayname>" rather than the "ARRAY 
> /dev/md/NN" that I would expect (and that is in my /etc/mdadm.conf 
> file).  Not sure if this has anything to do with the problem or not. 
> There are no /dev/md/<arrayname> device files or symlinks on the system.

So maybe the only problem is that the names are missing from /dev/md/ ???

When you can access the server again, could you report:

  cat /proc/mdstat
  grep md /proc/partitions
  ls -l /dev/md*

and maybe
  mdadm -Ds
  mdadm -Es
  cat /etc/mdadm.conf

just for completeness.


It certainly looks like your data is all there but maybe not appearing
exactly where you expect it.



> 
> I *think* my next step based on the various posts I've read would be to 
> try the same mdadm -A command with --force, but I'm a little wary of 
> that and want to make sure I actually understand what I'm doing so I 
> don't screw up the array entirely and lose all my data!  I'm not sure if 
> I should be giving it *all* of the drives as an arg, including the 
> spares or should I just pass it the active drives?  Should I use the 
> --raid-devices and/or --spare-devices options?  Anything else I should 
> include or not include?

When you do a "-A --force" you do give it all they drives that might be part
of the array so it has maximum information.
--spare-devices and --raid-devices are not meaningful with --assemble.


NeilBrown


> 
> Thanks in advance to any advice you can provide.  I won't be able to 
> test until Monday morning but it would be great to be armed with things 
> to try so I can hopefully get back up and running soon and minimize all 
> of those "When will the network share be back up?" questions that I'm 
> already anticipating getting.
> 
> Cheers,
> -steve
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

