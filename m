From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: RAID 0, disks swapped ?
Date: Fri, 17 Oct 2008 19:44:16 +0200
Message-ID: <gdaitg$fnb$1@ger.gmane.org>
References: <200810171318.12654.c.baegert-listes@lixium.fr>
 <200810171548.59686.c.baegert-listes@lixium.fr>
 <gda641$spp$2@ger.gmane.org>
 <200810171634.22114.c.baegert-listes@lixium.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

c.baegert-listes@lixium.fr <c.baegert-listes@lixium.fr> wrote:
> Is the order the number [1] or [0] in the line below ?
> md5 : active raid0 md4[1] md3[0]

Yes, this should be the result of mdadm -C ... /dev/md5 /dev/md3 /dev/md4


regards
   Mario
-- 
There are two major products that come from Berkeley: LSD and UNIX.
We don't believe this to be a coincidence.    -- Jeremy S. Anderson

