From: Edward Kuns <eddie.kuns@gmail.com>
Subject: Re: mdadm stuck at 0% reshape after grow
Date: Wed, 6 Dec 2017 14:19:17 -0600
Message-ID: <CACsGCyTZaqRxWFJ1NxN3jVktRcQv3_AdjRTT+3OfuYMuFYdr_w@mail.gmail.com>
References: <CAGx2nv6cZ85YCrUQsCBWfojFxOyqW4=+5OaCqU1Gf0UX=T3Gbg@mail.gmail.com>
 <1865221512489329@web5g.yandex.ru> <d34ebd38-47e5-35bc-5ee6-0da194ce1901@turmel.org>
 <CAGx2nv6YAc5jBL36K0oNG=tE5J3TNXGMvTvD9ZvcZYthXe9Y5g@mail.gmail.com>
 <20171206104905.GA4383@metamorpher.de> <61c9e4bd-1605-5b17-80ce-c738b80b7058@turmel.org>
 <20171206160346.GA5806@metamorpher.de> <1b43be27-f21a-1fba-f983-01c5356a654d@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1b43be27-f21a-1fba-f983-01c5356a654d@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Wols Lists <antlists@youngman.org.uk>
Cc: Andreas Klauer <Andreas.Klauer@metamorpher.de>, Jeremy Graham <jeremy@doghouse.agency>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Dec 6, 2017 at 10:21 AM, Phil Turmel <philip@turmel.org> wrote:
> The problem with the BBL right now is its existence.

I have a couple questions:

1) If I have bad blocks lists configured, how do I safely remove them?

I checked my three arrays and I have BBL configured on two of my eight
partitions making up my three arrays:

# mdadm --examine-badblocks /dev/sda5 /dev/sdb3
No bad-blocks list configured on /dev/sda5
No bad-blocks list configured on /dev/sdb3
# mdadm --examine-badblocks /dev/sda3 /dev/sdb2
No bad-blocks list configured on /dev/sda3
No bad-blocks list configured on /dev/sdb2
# mdadm --examine-badblocks /dev/sda2 /dev/sdb1 /dev/sdc1 /dev/sdd1
No bad-blocks list configured on /dev/sda2
No bad-blocks list configured on /dev/sdb1
Bad-blocks list is empty in /dev/sdc1
Bad-blocks list is empty in /dev/sdd1

I replaced sdc and sdd a couple years ago when one of the two failed.
(They were the same Seagate model that had a particularly high failure
rate not obvious when I bought them.  So I replaced both.)  Apparently
when I replaced them, I inadvertently enabled the BBL on them.

2) Wol, should there be a section on the Wiki about "Things you should
make sure you have configured" that includes disabling the BBL (unless
you know what you're doing), making sure you're scrubbing regularly,
making sure you have drives that support scterc (or if you don't,
configuring /sys/block/<device>/device/timeout), and so on?  Perhaps a
list of information you should have handy before disaster strikes to
make life a lot easier if it does?  E.g., running lsdrv or dumping
partition tables to text files or listing information about your RAID
configuration and LVM, etc.


I have an unrelated question due to poking around while gathering the
above information.  I just realized that this code that I put in
/etc/rc.d/rc.local doesn't work for me because smartctl is not
returning an error:

# Force drives to play nice with MD
for i in /dev/sd? ; do
    if smartctl -l scterc,70,70 $i > /dev/null ; then
        echo -n $i " is good "
    else
        echo 180 > /sys/block/${i/\/dev\/}/device/timeout
        echo -n $i " is  bad "
    fi;
    smartctl -i $i | egrep "(Device Model|Product:)"
    blockdev --setra 1024 $i
done

If I check this manually, I notice that smartctl returns 0 whether the
command succeeds or fails.

# smartctl -l scterc,70,70 /dev/sdb ; echo $?
smartctl 6.5 2016-05-07 r4318 [x86_64-linux-4.8.13-100.fc23.x86_64]
(local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

SCT Commands not supported

0

This is an old Linux version and I need to upgrade, I know.  Hopefully
over the holidays.  But I got that scriptlet above from this mailing
list and I see it at
https://raid.wiki.kernel.org/index.php/Timeout_Mismatch -- so did the
smartctl behavior change at some point?

# smartctl --version
smartctl 6.5 2016-05-07 r4318 [x86_64-linux-4.8.13-100.fc23.x86_64]
(local build)

      Thanks,

           Eddie
