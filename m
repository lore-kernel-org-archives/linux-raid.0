From: Luca Berra <bluca@comedia.it>
Subject: Re: Auto Rebuild on hot-plug
Date: Thu, 25 Mar 2010 09:01:08 +0100
Message-ID: <20100325080108.GB20583@maude.comedia.it>
References: <20100325113543.0e2124c5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100325113543.0e2124c5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 25, 2010 at 11:35:43AM +1100, Neil Brown wrote:
>
>       http://blogs.techrepublic.com.com/opensource/?p=1368
>
> The most significant thing I got from this was a complain in the comments
> that managing md raid was too complex and hence error-prone.

well, i would not be upset by j. random jerk complaining in a blog
comments, as soon as you make it one click you will find another one
that complains because it is not is favorite colour :P

> I see the issue as breaking down in to two parts.
>  1/ When a device is hot plugged into the system, is md allowed to use it as
>     a spare for recovery?
>  2/ If md has a spare device, what set of arrays can it be used in if needed.
>
> A typical hot plug event will need to address both of these questions in
> turn before recovery actually starts.
>
> Part 1.
>
>  A newly hotplugged device may have metadata for RAID (0.90, 1.x, IMSM, DDF,
>  other vendor metadata) or LVM or a filesystem.  It might have a partition
>  table which could be subordinate to or super-ordinate to other metadata.
>  (i.e. RAID in partitions, or partitions in RAID).  The metadata may or may
>  not be stale.  It may or may not match - either strongly or weakly -
>  metadata on devices in currently active arrays.
also the newly hotplugged device may have _data_ on it.

>  Some how from all of that information we need to decide if md can use the
>  device without asking, or possibly with a simple yes/no question, and we
>  need to decide what to actually do with the device.
how does the yes/no question part work?

>  Options for what to do with the device include:
>    - write an MBR and partition table, then do something as below with
>      each partition
>    - include the device (or partition) in an array that it was previously
>      part of, but from which it was removed
>    - include the device or partition as a spare in a native-metadata array.
>    - add the device as a spare to a vendor-metadata array
I really feel there is much room for causing disasters with a similar
approach.

The main difference from an hw raid controller is that the hw raid
controller _requires_ full control on the individual disks.
MD does not. Trying to do things automatically without full control is
very dangerous.
this may be different when using ddf or imsm since they are usually
working on whole drives attached to a raid-like controller (even if one
of the strenghts of md is being able to activate those arrays even
without the original controller).

If you want to be user-friendly just add a simple script
/usr/bin/md-replace-drive
It will take as input either an md array or a working drive as source,
and the new drive as target.
In the first case it has examine the components of the source md
determine if they are partitions or a whole devices (sysfs), in the first
case, find the whole drive and ensure they are partitioned in the same
way.
It will examine the source drive for partition and all md arrays it is
part of. it will ensure that those arrays have a failed device,
Check the size of the components and match them to the new drive (no
sense replacing a 1T drive with a 750Gb one)

ask the user for confirmation in big understandable letters

replicate any mbr and partition table, and include the device (or all
newly created partitions) in the relevant md device.

an improvement would be not needing user to specify a source in the most
simple of cases, by checking for all arrays with a failed device.

we can also make /usr/bin/md-create-spare ...

> Part 2.
>

makes sense

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
