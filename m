From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Locking bugs in 2.4 md.c
Date: Thu, 18 Sep 2003 17:23:10 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030918152310.GD30852@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org, Neil Brown <neilb@cse.unsw.edu.au>
Cc: axboe@suse.de
List-Id: linux-raid.ids

Hi Neil,

I can pretty reliably Oops the 2.4 md raid1 in md_update_sb with a

while true
	mdadm /dev/md0 -f /dev/foo -r /dev/foo
	mdadm /dev/md0 -a /dev/foo
done &
while true
	mdadm /dev/md1 -f /dev/bar -r /dev/bar
	mdadm /dev/md1 -a /dev/bar
done &

in parallel on several md devices. It will finally die in md_update_sb,
and appears to be related to some locking bugs.

(The above is a stress test and makes it occur faster; customers report
it happens in the field too, that's why I went looking.)

In March (see http://www.spinics.net/lists/raid/msg02335.html) you wrot=
e
you had a patch which made the locking in 2.4 "better", even though it
was rather ugly. Well, ugly it might be, but needed still ;-)

I assume you want to use the reconfig_sem for it? If you don't have a
recent patch, could you sketch out what you wanted to do so I could
start from there?

Thanks!


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

(Or maybe you want to backport the 2.6 md to 2.4... ;-)

--=20
High Availability & Clustering		ever tried. ever failed. no matter.
SuSE Labs				try again. fail again. fail better.
Research & Development, SuSE Linux AG		-- Samuel Beckett

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
