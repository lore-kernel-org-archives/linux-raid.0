From: =?ISO-8859-15?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Subject: Re[3]: Found duplicate PV: using /dev/sda3 not /dev/md1
Date: Wed, 6 Aug 2014 14:49:39 +0200
Message-ID: <434471753.20140806144939@oudeis.org>
References: <1896515726.20140614235853@oudeis.org>
 <1454723160.20140615203503@oudeis.org> <539E5A90.3080207@turmel.org>
 <19411862.20140616155327@oudeis.org> <539F00AE.9090504@turmel.org>
 <1153494452.20140616202024@oudeis.org> <539F5049.2080407@turmel.org>
 <145561825.20140616222858@oudeis.org> <539F5970.3060504@turmel.org>
 <1353040832.20140617032748@oudeis.org> <53A02D0C.90409@turmel.org>
 <1769771799.20140617161255@oudeis.org>
Reply-To: =?ISO-8859-15?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1769771799.20140617161255@oudeis.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Cc: Phil Turmel <philip@turmel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I assume we hit a dead end here?

RF> [root@gateway ~]# dmsetup ls
RF> vg_gateway-lv_data      (253, 2)
RF> vg_gateway-lv_var       (253, 1)
RF> vg_gateway-lv_home      (253, 0)
RF> [root@gateway ~]#

[...] (see my last mail regarding this topic)

I wonder what will happen if I mdadmin --resize /dev/md1? presumably
it will overwrite this stray LVM superblock and raid volume content
will be the same as it was a few weeks ago, when this problem first
occured?

tnx

