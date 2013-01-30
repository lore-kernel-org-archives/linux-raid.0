From: Priya Kamala <priya.kamala@perpetual-data.com>
Subject: FW: RAID-1 problem after device removal
Date: Wed, 30 Jan 2013 11:00:05 +0000
Message-ID: <5108FD35.7040508@perpetual-data.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Resending on behalf of a colleague as his mails are not getting through 
to the list.

-----Original Message-----
From: Barry J Sturgeon [mailto:barry.sturgeon@perpetual-data.com]
Sent: 30 January 2013 07:29
To: 'linux-raid@vger.kernel.org'
Subject: RE: RAID-1 problem after device removal


Hi,
    When I SCSI-remove a drive from a RAID-1 partition I see the RAID
partition correctly marked failed (F).
However, all write attempts after this are quietly failing, even though the
file system (XFS) and LVM are not reporting any errors.
In other words.

cp * TEST_FOLDER; echo "scsi remove-single-device 1 0 1 0" >
/proc/scsi/scsi; touch TEST_FILE

The files from TEST_FOLDER and TEST_FILE appear on the file system, but when
I reboot they have disappeared! Note that I do not see this issue with a
RAID-5 AND does not occur on RAID-1 Superblock version 1.2.
So I only see this with RAID-1 Superblock version 0.9.

I have tried kernel 3.2.32 and 3.2.37 and the both show this behavior.
The same test succeeds on 2.6. I am committed to 3.2.x so I cannot move
further upstream.

Am I doing something illegal?
Does anybody recognize this?
Any suggestions how I should proceed?

Thanks,
    Barry

