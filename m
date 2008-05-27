From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: aoe disk not recognized as part of raid - solution!
Date: Tue, 27 May 2008 13:05:01 +0200
Message-ID: <20080527130501.75ad1820.taeuber@bbaw.de>
References: <20080523142525.31d6e06b.taeuber@bbaw.de>
	<20080523170056.d6e39787.taeuber@bbaw.de>
	<46144.192.168.1.70.1211610465.squirrel@neil.brown.name>
	<20080526122057.1ed4454e.taeuber@bbaw.de>
	<18491.45392.503390.245024@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18491.45392.503390.245024@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

it was my fault!

I added the following =C2=BB/dev/etherd/e*.*=C2=AB to the DEVICE list i=
n /etc/mdadm.conf.

Sorry.
Lars
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
