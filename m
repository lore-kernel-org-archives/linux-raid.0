From: Bhamini Easwaran <ebhamini@yahoo.com>
Subject: How to convert raid0 to raid1
Date: Mon, 24 Mar 2003 21:48:53 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030325054853.1573.qmail@web13904.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a system running RedHat linux 7.2 and i have
configured RAID 1 for my / and /boot partitions during
installation. However, for my /var partition, i had
mistakenly chosen RAID 0. The two members are of
exactly same size and are on 2 seperate disks. Now i
want to change it to RAID 1. Please suggest the
correct procedure to do it.
I changed the /etc/raidtab and did a reboot, but it
didnt work. raidhotremove cant be used either as /var
cant be unmounted.
How should i proceed? Someone please help.
Bhamini


__________________________________________________
Do you Yahoo!?
Yahoo! Platinum - Watch CBS' NCAA March Madness, live on your desktop!
http://platinum.yahoo.com
