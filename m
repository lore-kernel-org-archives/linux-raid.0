From: Alireza Haghdoost <alireza@cs.umn.edu>
Subject: Inject I/O latency for RAID5/6 read and writes
Date: Mon, 23 Feb 2015 12:32:47 -0600
Message-ID: <CAB-428=gcsgxa1k83h0QWmijhe_kXaLMQZqs+m=Zb0OWX06geA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

I needed to inject I/O completion latency in the RAID5/6 codes for
test purpose. I was wondering where would be the good place in
md/raid5.c code to add delay ?

So far I have tried adding mdelay/udelay in raid5_end_write_request()
and it seems it works to increase I/O completion of writes. However,
adding delay in raid5_end_read_request() does not really change the
read I/O latency. Any idea ?

--Alireza
