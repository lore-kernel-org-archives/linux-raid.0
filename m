From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: auiestion about ops_run_biodrain() using ADMA
Date: Tue, 14 Jul 2009 15:15:44 -0700
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C07B0918A@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When there is dependency on async_memcpy(in ops_run_biodrain) by
async_xor(in ops_run_postxor) how is the consistency guaranteed ? I mean
where is the locking. In case of ADMA I see both requests are submitted
suing async_tx_submit(). Is this completely depends on the sequence of
submission ?
Thanks and Regards,
Marri
