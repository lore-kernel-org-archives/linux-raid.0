From: "Peter Kovari" <peter@kovari.priv.hu>
Subject: Question regarding --backup-file
Date: Mon, 2 May 2011 17:13:47 +0200
Message-ID: <000301cc08db$89293160$9b7b9420$@priv.hu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: hu
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I understand, that a change from RAID5 to RAID6 by adding a single disk -
eg. keeping the number of data disks - requires a backup file throughout the
whole reshape process. For a larger, multi-TB array this means millions of
writes to the backup file, which - if i'm correct - means means millions of
writes to the same physical sectors of the disk that holds the backup file.
Is this not problematic? How many write operations can a typical drive
tolerate nowadays? (on the same sectors)

Cheers,
Peter


