From: =?ISO-8859-15?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Subject: Re[2]: Found duplicate PV: using /dev/sda3 not /dev/md1
Date: Mon, 16 Jun 2014 22:28:58 +0200
Message-ID: <145561825.20140616222858@oudeis.org>
References: <1896515726.20140614235853@oudeis.org>
 <1454723160.20140615203503@oudeis.org> <539E5A90.3080207@turmel.org>
 <19411862.20140616155327@oudeis.org> <539F00AE.9090504@turmel.org>
 <1153494452.20140616202024@oudeis.org> <539F5049.2080407@turmel.org>
Reply-To: =?ISO-8859-15?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <539F5049.2080407@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


PT> Yep, use mdadm --stop --force.

unfortunately, same result:

[root@gateway ~]# mdadm --stop --force /dev/md1
mdadm: fail to stop array /dev/md1: Device or resource busy
Perhaps a running process, mounted filesystem or active volume group?


cu

