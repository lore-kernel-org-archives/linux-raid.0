From: "Martin K. Petersen" <mkp@mkp.net>
Subject: Re: question regarding a raid-1 set
Date: 26 Aug 2003 11:11:52 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <yq13cfov4g7.fsf@wilson.mkp.net>
References: <200308261637.08588.jbaten@i2rs.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200308261637.08588.jbaten@i2rs.nl>
To: Jeroen Baten <jbaten@i2rs.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Jeroen" == Jeroen Baten <jbaten@i2rs.nl> writes:

Jeroen> md2 : active raid1 sdb6[1] sda6[0] 31848704 blocks [2/1] [U_]
                           ^^^^^^^                                ^

Jeroen> when he types 'raidhotadd /dev/md2 /dev/sdb6' it generates:
Jeroen> "dev/md2: can not hot-add disk: disk busy"

sdb6 *is* busy.  It's sda6 that's out of sync.

-- 
Martin K. Petersen	Wild Open Source, Inc.
mkp@wildopensource.com	http://www.wildopensource.com/

