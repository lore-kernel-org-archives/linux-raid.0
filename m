From: Spencer Tuttle <rodeojones@fastmail.fm>
Subject: Autostart RAID1 on boot
Date: Tue, 15 Nov 2005 09:50:59 -0700
Message-ID: <437A11F3.90204@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Why do I need to run mdadm -A -ap /dev/md_d0 /dev/sda /dev/sdb to start 
my array everytime I boot?  This seems like I will never be able to boot 
from this array if I have to run this command.

What do I have to do to autostart this array on boot?

Thanks,
Spencer
