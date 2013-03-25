From: maurice <mhilarius@gmail.com>
Subject: Creating a RAID10 (near) for use in a CentOS 6 system
Date: Mon, 25 Mar 2013 11:30:25 -0600
Message-ID: <515089B1.9010607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I come today, hat in hand, for some suggestions on a new install with 
RAID10.

I wish to install CentOS 6 on a new system.
I am using 4 identical drives, and do not see any need to partition them.
They are 2TB Hitachi Ultrastar (enterprise)drives.

I wish to use RAID10, near

Questions:
Syntax: Creating near vs far. Is there a specific syntax to use?

I *think* this is what I need:
mdadm --create /dev/md0 --run --level=10 --chunk=4 --raid-devices=4 
/dev/sda /dev/sdb /dev/sdc /dev/sdd

Next question is about mdadm versions and kernels.
CentOS 6 currently uses 2.6.32-358.2.1.el6
Is there anything in that I should beware of?

OTOH, one may get newer kernels by enabling elrepo

http://elrepo.org/tiki/tiki-index.php

This will get me up to:
     kernel-lt-3.0.70-1.el6.elrepo
     kernel-ml-3.8.4-1.el6.elrepo

Is that desirable in this case?

Any thoughts and suggestions are most welcome..


-- 
Cheers,
Maurice Hilarius
eMail: /mhilarius@gmail.com/
