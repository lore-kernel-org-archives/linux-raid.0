From: =?ISO-8859-15?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Subject: Re[2]: Found duplicate PV: using /dev/sda3 not /dev/md1
Date: Tue, 17 Jun 2014 03:27:48 +0200
Message-ID: <1353040832.20140617032748@oudeis.org>
References: <1896515726.20140614235853@oudeis.org>
 <1454723160.20140615203503@oudeis.org> <539E5A90.3080207@turmel.org>
 <19411862.20140616155327@oudeis.org> <539F00AE.9090504@turmel.org>
 <1153494452.20140616202024@oudeis.org> <539F5049.2080407@turmel.org>
 <145561825.20140616222858@oudeis.org> <539F5970.3060504@turmel.org>
Reply-To: =?ISO-8859-15?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <539F5970.3060504@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

phil,

PT> Look in /sys/block/md1/holders/

[root@gateway md1]# cd holders/
[root@gateway holders]# ls -lh
total 0
lrwxrwxrwx 1 root root 0 Jun 16 23:11 dm-0 -> ../../../block/dm-0
lrwxrwxrwx 1 root root 0 Jun 16 23:11 dm-1 -> ../../../block/dm-1
lrwxrwxrwx 1 root root 0 Jun 16 23:11 dm-2 -> ../../../block/dm-2
[root@gateway holders]#

not sure what that means?

