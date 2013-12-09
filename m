From: Wilson Jonathan <piercing_male@hotmail.com>
Subject: adding a missing drive(s), which drives get written to?
Date: Mon, 9 Dec 2013 14:09:11 +0000
Message-ID: <BLU0-SMTP144CE5F6040BC17EDAE8A9E98D30@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After recovering from a failed raid6, now running with 2 missing drives
and soon to be finally backed up (is still backing up), I have 2 related
questions...

The first is, can I add in both drives at the same time, or do I need to
add them in singly, just checking for clarity?

The second question is far more important... during the re-creation of
data on the newly added missing disk/partition(s) does mdadm just read
the data from the original array and write to the new disk(s) or does it
potentially write new/update existing data (excluding bitmap/superblock)
to the existing disks.

My reason for asking about what gets written where is because I
re-purposed the pulled (2) disks along with another that I had laying
around to use as a temporary backup medium... one of the pulled disks
suddenly re-mapped over a thousand sectors (i'm fairly sure it was in
the thousand, but the disk is now reporting immediate fail imminent in
smart and and in reality when it was taring to it, it totally locked up)
but then again the disk was over 5 years of "powered up" time... I'm
suprised it had not failed sooner so I am now rather worried that
although periodic scrubs (first sun/month) have reported no problems
that if one of the existing 4 disks gets heavy writes it will fail but
"might" just last long enough in a heavy read situation (and in fact no
problems are reported so far in the backup process) to get at least 1
disk redundancy back into the array.

Thanks in advance.

Jon


