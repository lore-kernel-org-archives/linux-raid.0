From: Stephen Thomas <scjthm@live.com>
Subject: Poor performance with raid 0 with 2 devices at partition level
Date: Sun, 6 Jul 2014 06:28:57 +0100
Message-ID: <SNT146-W18D11856292553E667D4BDA8020@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi

I have a some problems with a two disk raid 0 array using md. I two dis=
ks with advanced format 4096 physical/512 logical sector size. I have t=
wo partitions on two disks which are aligned on a divisible by 8 sector=
 boundary. I run dd on each of the paritions using the sync mode, and t=
he block dump tells me that it is writing 8 sectors at a time. =A0I get=
 about 100+Mbytes/second. I create a raid array using the mdadm tools w=
ith chunk size of 128Kbytes and I check block dump and it tells me that=
 it is writing 8 sectors at a time on the MD device. When I write to th=
e md device I only get about 8Mbytes/second. =A0On the same machine usi=
ng full disk raid configured using the intel firmware raid and read by =
MD I get about 200+ Mbytes/s write speed.

Is there anything that I am doing that is incorrect?


Cheers

Stevo 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
