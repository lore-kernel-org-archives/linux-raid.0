From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: What can be used instead of /dev/disk/by-path/* symlinks?
Date: Tue, 17 Dec 2013 09:10:44 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB1A69A1E3@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

Hi Neil,

The /dev/disk/by-path/* symlinks are not created for ATA devices in systems using systemd v182+, so mdadm cannot use them in case of policies and udev rules (mdadm -If --path=...)

What do you think - what should be used instead? The symlinks from /sys/block/* ?

Regards,
Lukasz
