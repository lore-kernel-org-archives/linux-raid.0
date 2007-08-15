From: Michal Soltys <nozo@ziu.info>
Subject: mdadm --auto=mdp on non-standard named arrays
Date: Wed, 15 Aug 2007 20:44:20 +0200
Message-ID: <46C34984.2020800@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just a tiny detail, but it looks like -auto=mdp won't create additional 
device nodes for raid's partitions (unless explicitely specified by number), 
when used with non-standard name, i.e.

mdadm -C /dev/md/abc -l0 -n2 /dev/sda2 /dev/sdb2 --auto=mdp

will only create /dev/md/abc node. Remaining p/part/partition have no 
problems here.

Tested with mdadm v2.6.2

