From: Hans Kraus <hans@hanswkraus.com>
Subject: Timeout question
Date: Mon, 04 Nov 2013 21:07:01 +0100
Message-ID: <5277FE65.8050001@hanswkraus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I put all my replaced and so on HDs in one machine to serve
backup duties, with backuppc.

I assembled four raid0, each consiting of a 3 + 1 TB couple or
2 + 2 TB couple. Some of these support scterc, some do not. I've
put the following in rc.local (by the way, the system is running
Debian):
cd /dev
for x in sd[a-z]; do
     /bin/echo $x 
"---------------------------------------------------------------------------"
     /usr/sbin/smartctl -s on -o on -S on /dev/$x || echo 
"/usr/sbin/smartctl -s on -o on -S on /dev/$x failed."
     /usr/sbin/smartctl -l scterc,70,70 /dev/$x || echo 180 
 >/sys/block/$x/device/timeout || echo "/sys/block/$x/device/timeout not 
available"
     /usr/sbin/smartctl -t offline /dev/$x || echo "/usr/sbin/smartctl 
-t offline /dev/$x failed"
     /bin/echo 
"-------------------------------------------------------------------------------"
done

Afterwards, these four raid0 are the members of a raid5. The idea
behind this is to be able to replace the raid0 with single 4 TB drives.
Now comes my question: Do I need to care for timeouts of the raid0, and
if so, how do I do that? The following doesn't work:
for x in md??; do
     /bin/echo $x 
"--------------------------------------------------------------------------"
     echo 180 >/sys/block/$x/device/timeout || echo 
"/sys/block/$x/device/timeout not available"
     /bin/echo 
"-------------------------------------------------------------------------------"
  done

Kind regards,
Hans
