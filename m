From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: raid5 - adding journal to an existing device?
Date: Sat, 25 Feb 2017 23:12:21 +0900
Message-ID: <9447cf1f98aaade8ab5cd3f0ef724f79@admin.virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mdadm manual specifies the following for create, build and grow modes:

        --write-journal
               Specify journal device for the RAID-4/5/6 array.

However:

# mdadm --grow /dev/md2 --write-journal /dev/sdc1
mdadm: :option --write-journal not valid in grow mode


Is it not yet supported, will never be supported, or am I simply trying 
to use it in a  wrong way?



Tried the following versions:

# ./mdadm -V
mdadm - v3.4-115-ge22fe3a - 29th November 2016

# mdadm -V
mdadm - v3.4 - 28th January 2016


Tomasz Chmielewski
https://lxadm.com
