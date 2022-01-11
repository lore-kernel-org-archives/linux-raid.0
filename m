Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54732C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 11 Jan 2022 16:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238513AbiAKQyG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 11 Jan 2022 11:54:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241681AbiAKQyF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 11 Jan 2022 11:54:05 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475CCC06173F
        for <linux-raid@vger.kernel.org>; Tue, 11 Jan 2022 08:54:05 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id fo11so18917200qvb.4
        for <linux-raid@vger.kernel.org>; Tue, 11 Jan 2022 08:54:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YbpQmITcpHmCIncCI07eaSPyQWx48UYAa5aXAowcytY=;
        b=h64MZcI/Y/nvWqcPJ9vfVSHTTue5/+MDv22mgWCFWDvQaQf8T0xhAL0uUW29/nqVEU
         PemV5AFZZJ4P9/ygbBSMBOGu+htG1X/LRRQkpemBFIMXP19OGm5iZfc3zlS7P0n31aC0
         aXuI4W57f30fvNIkcz5rC9TM3queql399LdBqFcPnugC23O+csM4THZEgoyGUT9VWi49
         xCmkYFBOaLMrSo1sOSc3hriJKJFXBdY19BdO5J5Je2cLomk5vQTe0Ybij9EtF9K0eX1A
         KEpUrh9K/uVkO4Wi4cHTPXMLrXt1xwP0NDovuwp3PcaMt6joF5ZZU1Bje+0EjMosMo7Z
         435A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YbpQmITcpHmCIncCI07eaSPyQWx48UYAa5aXAowcytY=;
        b=QVTo5E2sF3KTNSFSD5a3H70bHKoPs59NXY3G9HxYH8U/NCayRjEGg9ILTGE3UGSQoT
         EebX1aq76yaTMETPIP1u1sHLs6UsLk+LPR85CnBG0waBQcKADVjzXADmaTvRv9Si2TTr
         Fd8e68kiCkeIBioQ1INQkOSUwNVpHDppyOn211xYOznKHT0J1WlA8Z+qGyNoZ7Es1R7O
         zrRs7z8j1fmsjqm3sw+HKTcs7sb1bApOkcwl1XYFr4DD7hgO8R8lET6SAa1v4/RlxMxQ
         hJiNQfNRlSoqIwxdLtOjb5eMYvFblMUsckHNfyUAA24G56GtaIMHk+VcZoAF3LCmbcYw
         k7Xg==
X-Gm-Message-State: AOAM5333GuKwkNFZ6ydzRwnHfgwle3dUcMDfUxo2RwCAPatoX3COg/9V
        dQgZmGaNY79f+VJPaRY8++aRIk4QLJvhWATaYORN6Q+XmYg=
X-Google-Smtp-Source: ABdhPJx1n699oZuc6047WxiM7GtkAbiy6Un+BkfNCIwA049Vm6PZUdrIh8+ZcbVUBTVpA1TyzBiU9FyBYZl7qfTuXG4=
X-Received: by 2002:a05:6214:f25:: with SMTP id iw5mr4347643qvb.3.1641920044311;
 Tue, 11 Jan 2022 08:54:04 -0800 (PST)
MIME-Version: 1.0
References: <Ja6.44rcR.6N3YLK}k{ZL.1XskzP@seznam.cz> <0394837e-0109-e7b7-59f9-5e90a03bc629@youngman.org.uk>
 <CAAMCDec5kcK62enZCOh=SJZu0fecSV60jW8QjMierC147HE5bA@mail.gmail.com> <KN4.44rdw.1WKWgyVtkH0.1XtLJu@seznam.cz>
In-Reply-To: <KN4.44rdw.1WKWgyVtkH0.1XtLJu@seznam.cz>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Tue, 11 Jan 2022 10:53:52 -0600
Message-ID: <CAAMCDef-bxeM0a_qS0FuviZ89a_Qn496KDsj1WQ3r7NT+t5+_Q@mail.gmail.com>
Subject: Re: Feature request: Add flag for assuming a new clean drive
 completely dirty when adding to a degraded raid5 array in order to increase
 the speed of the array rebuild
To:     =?UTF-8?B?SmFyb23DrXIgQ8OhcMOtaw==?= <jaromir.capik@email.cz>
Cc:     Linux RAID <linux-raid@vger.kernel.org>,
        Wols Lists <antlists@youngman.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I have noticed on simple tests making arrays with tmpfs that Intel
cpus seem to be able to xor about 2x the speed of AMD.   The speed may
also vary based on cpu generation.

Also, grow differs in the fact that blocks get moved around hence the write=
s.

On the raid you are building, is there other IO going on to the disks?
 This will cause seeks and the more io there is (outside of the
rebuild) the worse it will be.

Here is everything I set on my arrays
find /sys -name "*sync_speed_min*" -exec /usr/local/bin/set_sync_speed
15000 {} \;
# MB Intel controller
find /sys/devices/pci0000:00/0000:00:1f.2/ -name "*queue_depth*" -exec
/usr/local/bin/set_queue_depth 1 {} \;
find /sys/devices/pci0000:00/0000:00:1f.2/ -name "nr_requests" -exec
/usr/local/bin/set_queue_depth 4 {} \;
#
# AMD FM2 MB
find /sys/devices/pci0000:00/0000:00:11.0/ -name "queue_depth" -exec
/usr/local/bin/set_queue_depth 8 {} \;
find /sys/devices/pci0000:00/0000:00:11.0/ -name "nr_requests" -exec
/usr/local/bin/set_queue_depth 16 {} \;
echo 30000 > /proc/sys/dev/raid/speed_limit_min
  for mddev in md13 md14 md15 md16 md17 md18 ; do
  blockdev --setfra 65536 /dev/${mddev}
  blockdev --setra 65536 /dev/${mddev}
  echo 32768 > /sys/block/${mddev}/md/stripe_cache_size
  echo 30000 > /sys/block/${mddev}/md/sync_speed_min
  echo 2 > /sys/block/${mddev}/md/group_thread_cnt
done

You will need to adjust my find/pci* devices to find your device, and
you will need to test some with the queue_depth/nr_requests to see
what is best for your controller/disk combination.   You may want to
also test different values with the group_thread_cnt.

The set_queue_depth file (and the set_sync_speed file look like this):
cat //usr/local/bin/set_queue_depth
echo $1 > $2

On mine you will notice I have 6 arrays, 4 of those arrays are 3tb
disk split into 4 750GB partitions to minimize time for a single grow
to complete.

The Other 2 are a 3tb remaining space split into 2 1.5tb spaces to
also minimize the grow time.

I have also found that when a disk fails often only a single partition
gets a bad block and fails and so I only have to --re-add/--add one
device.

And if the disk has not failed you can do a --replace so long as you
can get the old and new devices in the chassis.   With the multiple
partitions it usually means I only have 1 of 4 partitions that failed
in mdadm, and so a re-add gets that one to work and I can then do the
replace which just reads from the disk it is replacing and as such is
much faster.

I also carefully setup the disk partition naming such that the last
digit of the partitions matches the last digit of the md ie:
md16 : active raid6 sdh6[10] sdi6[12] sdj6[7] sdg6[9] sde6[1] sdb6[8] sdf6[=
11]
      3615495680 blocks super 1.2 level 6, 512k chunk, algorithm 2
[7/7] [UUUUUUU]
      bitmap: 0/6 pages [0KB], 65536KB chunk

as that makes the adding/re-adding simpler as I know which device it always=
 is.


On Tue, Jan 11, 2022 at 3:59 AM Jarom=C3=ADr C=C3=A1p=C3=ADk <jaromir.capik=
@email.cz> wrote:
>
> Hello Roger.
>
> I just run atop on a different and much better hardware doing mdadm --gro=
w on raid5 with 4 drives and it shows the following
>
> DSK | sdl | | busy 90% | read 950  | | write 502 | | KiB/r 1012 | KiB/w 5=
06 | | MBr/s 94.0 | | MBw/s 24.9 | | avq 1.29 | avio 6.22 ms | |
> DSK | sdk | | busy 89% | read 968  | | write 499 | | KiB/r 995  | KiB/w 5=
09 | | MBr/s 94.1 | | MBw/s 24.8 | | avq 0.92 | avio 6.09 ms | |
> DSK | sdj | | busy 88% | read 1004 | | write 503 | | KiB/r 958  | KiB/w 5=
05 | | MBr/s 94.0 | | MBw/s 24.8 | | avq 0.66 | avio 5.91 ms | |
> DSK | sdi | | busy 87% | read 1013 | | write 499 | | KiB/r 949  | KiB/w 5=
09 | | MBr/s 94.0 | | MBw/s 24.8 | | avq 0.65 | avio 5.81 ms | |
>
> Personalities : [raid1] [raid6] [raid5] [raid4] [linear] [multipath] [rai=
d0] [raid10]
> md3 : active raid5 sdi1[5] sdl1[6] sdk1[4] sdj1[2]
>       46877237760 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4]=
 [UUUU]
>       [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>...]  resync =
=3D 88.5% (13834588672/15625745920) finish=3D293.1min speed=3D101843K/sec
>       bitmap: 8/59 pages [32KB], 131072KB chunk
>
> Surprisingly all 4 drives show approximately 94MB/s read and 25MB/s write=
.
> Even when each of the drives can read 270MB/s and write 250MB/s, the sync=
 speed is 100MB/s only, so?
>
> Does --grow differ from --add?
>
> Thanks,
> Jaromir
>
>
>
> ---------- P=C5=AFvodn=C3=AD e-mail ----------
>
> Od: Roger Heflin <rogerheflin@gmail.com>
>
> Komu: Wols Lists <antlists@youngman.org.uk>
>
> Datum: 11. 1. 2022 1:15:17
>
> P=C5=99edm=C4=9Bt: Re: Feature request: Add flag for assuming a new clean=
 drive
>  completely dirty when adding to a degraded raid5 array in order to incre=
ase
>  the speed of the array rebuild
>
> I just did a "--add" with sdd on a raid6 array missing a volume and here =
is what sar shows:
>
> 06:08:12 PM       sdb     91.03  34615.97      0.36      0.00    380.26  =
    0.41      4.47     30.31
> 06:08:12 PM       sdc      0.02      0.00      0.00      0.00      0.00  =
    0.00      0.00      0.00
> 06:08:12 PM       sdd     77.12     26.28  34563.36      0.00    448.54  =
    0.64      8.23     27.40
> 06:08:12 PM       sde     36.45  34598.82      0.36      0.00    949.22  =
    1.43     38.78     70.37
> 06:08:12 PM       sdf     46.87  34598.89      0.36      0.00    738.25  =
    1.23     26.13     57.81
>
> 06:09:12 PM       sda      5.12      0.93     75.33      0.00     14.91  =
    0.01      1.48      0.39
> 06:09:12 PM       sdb    122.57  46819.67      0.40      0.00    382.00  =
    0.54      4.38     35.85
> 06:09:12 PM       sdc      0.00      0.00      0.00      0.00      0.00  =
    0.00      0.00      0.00
> 06:09:12 PM       sdd    105.92      0.00  46775.73      0.00    441.63  =
    1.12     10.53     35.80
> 06:09:12 PM       sde     48.47  46817.53      0.40      0.00    965.98  =
    1.95     40.00     97.89
> 06:09:12 PM       sdf     56.95  46834.53      0.40      0.00    822.39  =
    1.73     30.32     82.33
>
>
> 06:10:12 PM       sda      4.55      1.20     48.20      0.00     10.86  =
    0.01      0.97      0.27
>
> 06:10:12 PM       sdb    123.67  46616.93      0.40      0.00    376.96  =
    0.52      4.15     34.66
> 06:10:12 PM       sdc      0.00      0.00      0.00      0.00      0.00  =
    0.00      0.00      0.00
> 06:10:12 PM       sdd    109.82      0.00  46623.40      0.00    424.56  =
    1.30     11.80     36.15
> 06:10:12 PM       sde     49.18  46602.00      0.40      0.00    947.52  =
    1.93     39.17     97.27
> 06:10:12 PM       sdf     54.88  46601.07      0.40      0.00    849.10  =
    1.75     31.82     85.16
>
>
> 06:11:12 PM       sda      4.07      1.00     50.80      0.00     12.74  =
    0.01      1.77      0.30
>
> 06:11:12 PM       sdb    121.93  46363.20      0.40      0.00    380.24  =
    0.51      4.10     34.72
> 06:11:12 PM       sdc      0.00      0.00      0.00      0.00      0.00  =
    0.00      0.00      0.00
> 06:11:12 PM       sdd    109.58      0.00  46372.47      0.00    423.17  =
    1.37     12.44     35.69
> 06:11:12 PM       sde     49.38  46371.00      0.40      0.00    939.01  =
    1.93     38.88     97.09
> 06:11:12 PM       sdf     55.12  46352.53      0.40      0.00    841.00  =
    1.73     31.39     85.25
>
>
> 06:12:12 PM       sda      5.75     14.20     79.05      0.00     16.22  =
    0.01      1.78      0.40
>
> 06:12:12 PM       sdb    120.73  45994.13      0.40      0.00    380.97  =
    0.51      4.20     34.72
> 06:12:12 PM       sdc      0.00      0.00      0.00      0.00      0.00  =
    0.00      0.00      0.00
> 06:12:12 PM       sdd    110.95      0.00  45982.87      0.00    414.45  =
    1.43     12.81     35.39
> 06:12:12 PM       sde     49.63  46020.46      0.40      0.00    927.37  =
    1.91     38.39     96.18
> 06:12:12 PM       sdf     54.27  46022.80      0.40      0.00    847.97  =
    1.75     32.14     86.65
>
>
>
> So there are very few reads going on for sdd, but a lot of reads of the o=
ther disks to recalculate what the data on that disk.
>
> This is on raid6, but if raid6 is not doing a pointless check read on a n=
ew disk add, I would not expect raid5 to be.
>
>
> This is on a 5.14 kernel.
>
>
>
> On Mon, Jan 10, 2022 at 5:15 PM Wols Lists <antlists@youngman.org.uk> wro=
te:
>
> On 09/01/2022 14:21, Jarom=C3=ADr C=C3=A1p=C3=ADk wrote:
>
> > In case of huge arrays (48TB in my case) the array rebuild takes a coup=
le of
>
> > days with the current approach even when the array is idle and during t=
hat
>
> > time any of the drives could fail causing a fatal data loss.
>
> >
>
> > Does it make at least a bit of sense or my understanding and assumption=
s
>
> > are wrong?
>
>
>
> It does make sense, but have you read the code to see if it already does =
it?
>
>
>
> And if it doesn't, someone's going to have to write it, in which case it
>
> doesn't make sense, not to have that as the default.
>
>
>
> Bear in mind that rebuilding the array with a new drive is completely
>
> different logic to doing an integrity check, so will need its own code,
>
> so I expect it already works that way.
>
>
>
> I think you've got two choices. Firstly, raid or not, you should have
>
> backups! Raid is for high-availability, not for keeping your data safe!
>
> And secondly, go raid-6 which gives you that bit extra redundancy.
>
>
>
> Cheers,
>
> Wol
>
>
>
