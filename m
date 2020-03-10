From: Song Liu <song@kernel.org>
Subject: Re: Failed JBOD RAID on old NAS, how to diagnose/resurrect?
Date: Tue, 10 Mar 2020 14:20:02 -0700
Message-ID: <CAPhsuW4Kh7YxxarBKNKtTh=3Kef7cBxtEMEzEB_6jPkAiAor1Q@mail.gmail.com>
References: <20200307215811.GA27305@esprimo> <20200307220820.GA31559@esprimo> <20200308141427.GA15739@esprimo>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200308141427.GA15739@esprimo>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Mar 8, 2020 at 7:15 AM Chris Green <cl@isbd.net> wrote:
>
> Well I've got it working again but I'm very confused as to *why* it
> failed the way it did.
>
> A 'cat /proc/mdstat' produced:-
>
>     Personalities : [linear] [raid0] [raid1]
>     md4 : active raid1 sda4[0]
>           973522816 blocks [2/1] [U_]
>
>     md1 : active raid1 sdb2[0] sda2[1]
>           256960 blocks [2/2] [UU]
>
>     md3 : active raid1 sdb3[0] sda3[1]
>           987904 blocks [2/2] [UU]
>
>     md2 : active raid1 sdb4[0]
>           973522816 blocks [2/1] [U_]
>
>     md0 : active raid1 sdb1[0] sda1[1]
>           1959808 blocks [2/2] [UU]
>
> So md2 and md4 (the main parts of the two 1Tb disk drives) seemed to
> be OK from the RAID point of view.  But I noticed that the block
> device for /dev/md4 didn't exist:-
>
>     ~ # ls -l /dev/md*
>     brw-r-----    1 root     root       9,   0 Sep 29  2011 /dev/md0
>     brw-r-----    1 root     root       9,   1 Sep 29  2011 /dev/md1
>     brw-r-----    1 root     root       9,  10 Sep 29  2011 /dev/md10
>     brw-r-----    1 root     root       9,  11 Sep 29  2011 /dev/md11
>     brw-r-----    1 root     root       9,  12 Sep 29  2011 /dev/md12
>     brw-r-----    1 root     root       9,  13 Sep 29  2011 /dev/md13
>     brw-r-----    1 root     root       9,  14 Sep 29  2011 /dev/md14
>     brw-r-----    1 root     root       9,  15 Sep 29  2011 /dev/md15
>     brw-r-----    1 root     root       9,  16 Sep 29  2011 /dev/md16
>     brw-r-----    1 root     root       9,  17 Sep 29  2011 /dev/md17
>     brw-r-----    1 root     root       9,  18 Sep 29  2011 /dev/md18
>     brw-r-----    1 root     root       9,  19 Sep 29  2011 /dev/md19
>     brw-r-----    1 root     root       9,   2 Sep 29  2011 /dev/md2
>     brw-r-----    1 root     root       9,  20 Sep 29  2011 /dev/md20
>     brw-r-----    1 root     root       9,  21 Sep 29  2011 /dev/md21
>     brw-r-----    1 root     root       9,  22 Sep 29  2011 /dev/md22
>     brw-r-----    1 root     root       9,  23 Sep 29  2011 /dev/md23
>     brw-r-----    1 root     root       9,  24 Sep 29  2011 /dev/md24
>     brw-r-----    1 root     root       9,  25 Sep 29  2011 /dev/md25
>     brw-r-----    1 root     root       9,  26 Sep 29  2011 /dev/md26
>     brw-r-----    1 root     root       9,  27 Sep 29  2011 /dev/md27
>     brw-r-----    1 root     root       9,  28 Sep 29  2011 /dev/md28
>     brw-r-----    1 root     root       9,  29 Sep 29  2011 /dev/md29
>     brw-r-----    1 root     root       9,   3 Sep 29  2011 /dev/md3
>     brw-r-----    1 root     root       9,   5 Sep 29  2011 /dev/md5
>     brw-r-----    1 root     root       9,   6 Sep 29  2011 /dev/md6
>     brw-r-----    1 root     root       9,   7 Sep 29  2011 /dev/md7
>     brw-r-----    1 root     root       9,   8 Sep 29  2011 /dev/md8
>     brw-r-----    1 root     root       9,   9 Sep 29  2011 /dev/md9
>
>
> The fix was simply to use 'mknod' to create the missing /dev/md4, now
> I can mount the drive and see the data.
>
> What I don't understand is where /dev/md4 went, how would it have got
> deleted?  I have yet to reboot the system to see if /dev/md4
> disappears again but if it does it's not a big problem to create it
> again.
>
> Should the RAID block devices get created as part of the RAID start
> up? Maybe there's something gone awry there.

Do you have proper /etc/md.conf?

Thanks,
Song
