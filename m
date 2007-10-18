From: =?UTF-8?B?QkVSVFJBTkQgSm/Dq2w=?= <joel.bertrand@systella.fr>
Subject: Re: [BUG] Raid5 trouble
Date: Thu, 18 Oct 2007 10:29:43 +0200
Message-ID: <47171977.8040309@systella.fr>
References: <4714BB92.7040701@systella.fr> <47161CE3.80909@systella.fr>	 <e9c3a7c20710170758p4046ca44labe370e94bca6e93@mail.gmail.com>	 <e9c3a7c20710170840u2ed8d6a9x26523eec6700ad11@mail.gmail.com>	 <47163BF9.304@systella.fr> <1192668368.22506.6.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1192668368.22506.6.camel@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-raid.ids

	Dan,

	I'm testing your last patch (fix-biofill-clear2.patch). It seems to work:

Every 1.0s: cat /proc/mdstat                            Thu Oct 18 
10:28:55 2007

Personalities : [raid1] [raid6] [raid5] [raid4]
md7 : active raid1 sdi1[1] md_d0p1[0]
       1464725632 blocks [2/2] [UU]
       [>....................]  resync =  0.4% (6442248/1464725632) 
finish=1216.6
min speed=19974K/sec

md_d0 : active raid5 sdc1[0] sdh1[5] sdg1[4] sdf1[3] sde1[2] sdd1[1]
       1464725760 blocks level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]

	I hope it fixes bug I have seen. I shall come back - I think tomorrow, 
my raid volume requires more than 20 hours to be created - to say if it 
works fine.

	Regards,

	JKB
