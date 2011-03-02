From: Bart Kus <me@bartk.us>
Subject: Increasing maxsect of md devices?
Date: Wed, 02 Mar 2011 14:26:02 -0800
Message-ID: <4D6EC3FA.4030809@bartk.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

This seems contradictory:

jo ~ # blockdev --getiomin /dev/md5
524288
jo ~ # blockdev --getioopt /dev/md5
4194304
jo ~ # blockdev --getmaxsect /dev/md5
255
jo ~ # blockdev --getbsz /dev/md5
4096
jo ~ # blockdev --getss /dev/md5
512
jo ~ #

Optimal IO size is reported as 4MB (and that is indeed the stripe size), 
but maximum sectors per request is only 128kB?  How can software do 
optimal 4MB IOs with the maxsect limit?  Does XFS care about this limit?

--Bart

