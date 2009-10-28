From: Andrew Dunn <andrew.g.dunn@gmail.com>
Subject: Benchmarking RAID6 and proper creation.
Date: Wed, 28 Oct 2009 16:23:01 -0400
Message-ID: <4AE8A825.4000802@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a system with 9 WD1001FALS drives in a RAID6 array right now,
they are all addressed with AOC-USAS-L8i controller cards.

I would like to test out the array's performance, I typically i/o large
files (100MiB-100GiB) but when creating the array I left the chunk size
alone and let mkfs.ext4 choose default settings (no special chunking or
striping)

Some of you are gurus who might be able to point me in the right
direction for benchmarking and creating a proper array for my purposes.

Thanks a ton for making linux raid so incredibly versatile and awesome!

-- 
Andrew Dunn
http://agdunn.net

