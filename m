From: Iain Rauch <groups@email.iain.rauch.co.uk>
Subject: RAID 6 grow problem
Date: Sat, 02 Jun 2007 16:30:23 +0100
Message-ID: <C2874B9F.7EBD%groups@email.iain.rauch.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, when I run:

mdadm /dev/md1 --grow --raid-devices 16 --backup-file=/md1backup

I get:

mdadm: Need to backup 1792K of critical section..
mdadm: Cannot set device size/shape for /dev/md1: Invalid argument

Any help?


Iain


