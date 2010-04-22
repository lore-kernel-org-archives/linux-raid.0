From: Brett King <king.br@gmail.com>
Subject: Re: compute_blocknr: map not correct error during RAID6 reshape 6 ->
	7 disks, mdadm 3.1.2 / kernel 2.6.34-rc3
Date: Thu, 22 Apr 2010 13:43:39 +1000
Message-ID: <i2s8cf253381004212043ud8d89d56n8c2ddffc3b6fc47@mail.gmail.com>
References: <u2j8cf253381004151856l76b4e227mc6327534e0e304ad@mail.gmail.com>
	 <z2q8cf253381004192043haf99536cvfb2bf6fcfb40fa4d@mail.gmail.com>
	 <20100420141442.2ca76b48@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100420141442.2ca76b48@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,
Just a quick update to advise the below patch worked - the array
finished its reshape and the filesystem mounted without error.

-    int chunk_number, dummy1, dd_idx = i;
+    int dummy1, dd_idx = i;
+    sector_t chunk_number;

I'll rebuild it with a larger chunk size to avoid similar issues in
the future, thanks everyone !
