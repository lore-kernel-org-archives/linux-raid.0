From: "P. Gautschi" <linuxlist@gautschi.net>
Subject: Preventing automatic start of ARRAY on Kubuntu
Date: Thu, 16 Oct 2014 18:00:06 +0200
Message-ID: <543FEB86.5070902@gautschi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm currently experimenting with RAID5 on Kubuntu 14.10 Beta 2.

When the system boots, /dev/md127 is automatically started. This occurs
whether the line (output after creation of mdadm --detail --scan)
ARRAY /dev/md0 metadata=1.2 name=test:0 UUID=2e0d5db2:47c49e4b:75c06b8b:11bf68cf
is in /etc/mdadm/mdadm.conf or not.

I would expected that the array is only started when the line is in the file
and then as /dev/md0 and not as md127.

My final goal is to prevent the start of the array when it is degraded
(missing or previously failed disk).

I had problems with a power cable and one disk had failed. While checking
the cables a second disk failed temporarily. Even though I wasn't writing
to the fs on the array I ended with and array that could not be assembled
again, after all disk were working again. (I have tried reboots,
mdadm --assemble --force and the other tricks from
https://raid.wiki.kernel.org/index.php/RAID_Recovery
but ended with a corrupt fs.)

I'm now trying to minimize the risk of data loss. Not starting the
array when degraded (or starting it read-only) is one of my ideas
but I don't know where and how to implement this.

Another idea is, that the array could switch to read only when
degraded during runtime. Ideally this would be delayed until the
fs does a flush/sync to be in a recoverable state. Of course file
accesses would fail is such a situation but it prefer this to
the rick of loosing data.
Is it possible to do this?

Patrick
