From: "Mikael Chambon" <raid-ml@cronos.org>
Subject: RAID recovery
Date: Thu, 10 Jul 2003 20:54:58 -1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <017b01c34779$57e66e00$c9e903ca@magnus>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi again,

Here is my last question about RAID for now.

I saw a lot of docs about RAID installation, but I was not able to find
one which clearly explain what to do after a HD crash. Does someone has a
good link for me ?

For example, let's say I have two new IDE HD in a RAID1 array, raid-disk1
and
raid-disk2. If raid-disk1 crash, I have to (from linux-raid-How-to)

Power down the system
replace the failed disk
powerup the system
user raidhotadd to insert the new disk in the array as raid-disk1


But what should I do to make sure that raid-disk1 will reconstruct from
raid-disk2 ? If raid-disk2 reconstruct from raid-disk1, I will lose all
my data right ?

Thanks for all guys,

--
Mikael Chambon


