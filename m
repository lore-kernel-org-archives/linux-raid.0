From: den RDC <denrdc@gmail.com>
Subject: RAID 5 - All superblocks gone due to MBR/GPT mishap - how do i figure
 out chunk size?
Date: Thu, 16 May 2013 21:24:12 +0200
Message-ID: <CAMtEPUOF_jAWwxgJt=GjL+9RMTo-j8_WgPDXAWNNDTHn=4uAkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello

Due to a nasty (human) error,  4 2tb disks in raid5 have lost their
1st megabyte of data ( including superblock ). In an attempt to get
the array to a state usable enough to at least attempt data recovery,
I have been trying to re-enable the array using various chunk size and
partition start offsets, but i cant seem to get it anywhere near a
consistent state ( recovery tools only return files or pieces of files
smaller then the chunk size, indicating alignment/chunk size
inconsistencies ).

The data I do have is :
- the order of the disks
- the pretty solid assumption that all data, even parity should be
fine for most of the disk except the very beginning.
- the exact size of the MD device before it got corrupted.

Is there any way, however adventurous, to glean the missing data (
chunk size, chunk alignment/offset ) from analysis of the existing
data ?

Kind regards
den_RDC
