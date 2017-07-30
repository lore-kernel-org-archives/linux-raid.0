From: Vasco Steinmetz <linux@kyberraum.net>
Subject: How to add journal device to existing RAID5?
Date: Sun, 30 Jul 2017 17:19:37 +0200
Message-ID: <ec6b9beb-b239-9ab9-03ac-7351e152d1af@kyberraum.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I bought a 32GB Intel Optane NVMe and would like to add it to an
existing RAID5 array as the journal device.

My hope was that with the latest Loonix kernel 4.12.4 and mdadm 4.0
adding a log device to an already existing array should work.

It didn't. :(

Though I marked the R5 array as RO, mdadm complained that adding a
journal to that particular array is not possible because it didn't have
had a journal device in teh past.

Unfortunately it is not possible for me to recreate the array, as that
would imply to move all data to backup, delete and recreate the array
and afterwards move it back.


When is it planned for mdadm/md-raid?.c to add/remove journal devices on
the fly (assuming they array may not be currently in use, e.g. --readonly)?


Kind regards,
Vasco
