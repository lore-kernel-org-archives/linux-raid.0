From: spam@altium.nl (Dick Streefland)
Subject: Re: RAID5 - 2nd drive died whilst waiting for RMA
Date: Fri, 12 Nov 2004 16:22:47 -0000
Message-ID: <6775.4194e357.6922c@altium.nl>
References: <41948B65.3090504@dgreaves.com> <41948B65.3090504@dgreaves.com> <4194A9E9.70003@dgreaves.com>
Reply-To: dick.streefland@altium.nl (Dick Streefland)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves <david@dgreaves.com> wrote:
| so, the plan in order to try and extract data:
| * insert new drive as /dev/sdd1
| * dd if=/dev/sda1 of=/dev/sdd1
| * mdadm /dev/md0 --remove /dev/sda1
| * physically swap /dev/sda and /dev/sdd so /dev/sdd
| * mdadm /dev/md0 --add /dev/sda1
| * fsck filesystem and expect to lose files where there were bad blocks
| * wait for new drive (special delivery - tomorrow morning)
| * insert new drive as /dev/sdd
| * mdadm /dev/md0 --add /dev/sdd1

You might want to check out "ddrescue", which is a version of "dd"
that is designed to read from a disk with bad sectors.

-- 
Dick Streefland                      ////                      Altium BV
dick.streefland@altium.nl           (@ @)          http://www.altium.com
--------------------------------oOO--(_)--OOo---------------------------

