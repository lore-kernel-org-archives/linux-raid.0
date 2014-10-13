From: Ram Ramesh <rramesh2400@gmail.com>
Subject: mdadm --grow with --backup-file does not create backupfile?
Date: Sun, 12 Oct 2014 20:26:05 -0500
Message-ID: <543B2A2D.9080407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I added a new disk and grew my raid6 md0 with the following command line

    sudo mdadm --grow --raid-devices=5
    --backup-file=/root/grow_md0.bkp_file --layout=normalise /dev/md0

I got a response that stated that mdadm needed to backup 384K of data. 
However, when I checked after about 5min there was no backup file. Is 
this expected?

    386 > sudo ls /root
    <no files. so no output>
    387 > sudo ls /root/grow_md0.bkp_file
    ls: cannot access /root/grow_md0.bkp_file: No such file or directory

Ramesh

