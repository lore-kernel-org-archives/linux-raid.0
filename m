From: "ptschack ." <ptschack@googlemail.com>
Subject: Re: Help with corrupted MDADM Raid6
Date: Fri, 13 Jun 2014 12:53:24 +0200
Message-ID: <CAH4F3SZ3HR0ZryMeEkWeQH2r3wqeQPsA3uKF_eQcA9s6oP+SsA@mail.gmail.com>
References: <CAH4F3SZ4Q8MO5Ci8ihSrLf1myo8pTfJ8SNC5EwJZQHf_H44GPA@mail.gmail.com>
	<20140613202541.584dc8f1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140613202541.584dc8f1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

thanks for your answer. Some clarification:

I clearly remember creating the RAID on the partitions (i.e. sda1,
sdb1, ...), not the whole devices (sda, sdb, ...). Doing this, I
created an ext4 partition on each drive and then created the RAID (in
hindsight, I know now I should have done this differently, starting
with the filesystem).

Before restoring my backup of the system disk (unrelated to the RAID)
I ran GParted to just look at the drives, not make any changes. My
guess is that GParted somehow "restored" the superblocks on all disks
except sdk1, thus destroying the md superblocks on those drives.

Nevertheless, when I get home in a few hours I will run mdadm
--examine on the whole devices, but I am 99% sure that nothing will be
found. Would an assemble (or create, for that matter) be able to
restore missing superblocks?

Regards,
-P.
