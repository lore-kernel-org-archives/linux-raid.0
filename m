From: "Tim Kent" <tim.kent@wkconsulting.com.au>
Subject: Adaptec 79xx HostRAID support
Date: Fri, 29 Jul 2005 18:20:38 +1000 (EST)
Message-ID: <21447.202.173.144.102.1122625238.squirrel@webmail.ilisys.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I've compiled the Linux 2.6.8 kernel (Debian Sarge version) with the
updated aic79xx drivers from Just Gibbs' web site which has allowed me to
now see disks while in HostRAID mode.  What is the next step to see the
logical RAID device instead of the disks?  I understand that the Linux
kernel needs to understand the Adaptec metadata on the disk.  I've tried
applying the rather dated emd diffs (emd-2.6-20040425-diffs.gz) to this
kernel without success.

Thanks,
Tim

