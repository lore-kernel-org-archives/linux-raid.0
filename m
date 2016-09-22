From: Axel Spallek <axel@spallek.org>
Subject: Re: RAID5 grow interrupted.
Date: Thu, 22 Sep 2016 20:44:22 +0200
Message-ID: <33cea2c1-2b9a-ac8d-25ab-dbe21e4e2852@spallek.org>
References: <36947ef9-64e2-f084-4949-476107e2771e@spallek.org>
 <57E3F62E.10706@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57E3F62E.10706@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

root@s10:~# mdadm --stop /dev/md1
mdadm: stopped /dev/md1
root@s10:~#
root@s10:~# mdadm --assemble --scan
mdadm: /dev/md/1: Need a backup file to complete reshape of this array.
mdadm: Please provided one with "--backup-file=..."
mdadm: No arrays found in config file or automatically
root@s10:~# mdadm --assemble --scan --backup-file=/var/backups/mdadm.backup
mdadm: --backup_file not meaningful with a --scan assembly.


Am 22.09.2016 um 17:18 schrieb Wols Lists:
> mdadm --assemble --scan

