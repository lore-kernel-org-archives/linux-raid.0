From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: RAID 0, disks swapped ?
Date: Fri, 17 Oct 2008 14:36:48 +0200
Message-ID: <gda0t0$9o2$1@ger.gmane.org>
References: <200810171318.12654.c.baegert-listes@lixium.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

c.baegert-listes@lixium.fr <c.baegert-listes@lixium.fr> wrote:
> I had to recreate the main RAID 0 (mdadm --create), I thought that the order 
> of /dev/md3 and /dev/md4 was not important (mdadm is known to find the good 
> order automatically),

This is true for assembling an existing RAID (provided it has a
superblock), but when you create a new one ... where should md know the
order except from what you gave it?
But... why did you have to recreate it at all?


regards
   Mario
-- 
We are the Bore. Resistance is futile. You will be bored.

