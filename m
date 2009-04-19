From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Spares Missing event in case of spare group?
Date: Sun, 19 Apr 2009 18:02:15 +0200
Message-ID: <49EB4B07.9050208@computer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

I have two RAID1 sets of equal size, with one spare shared between them. 
When I reboot the system I get a Spares Missing notification on one of 
the arrays.

Since this is a false positive, is there a way to avoid it?

Extract from mdadm.conf:

ARRAY /dev/md0 level=raid1 num-devices=2 spares=1 
UUID=19e69537:f7a6aec8:5a5f7576:3fc29e0d spare-group=swapgroup
ARRAY /dev/md1 level=raid1 num-devices=2 spares=1 
UUID=5e728621:c8b356a8:01f8e270:f0e280cb spare-group=swapgroup

Thanks, Jan
