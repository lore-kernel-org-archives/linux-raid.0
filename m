From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: ICH7 sata-ahci + software raid warning
Date: Tue, 11 Jul 2006 14:44:31 +0200
Message-ID: <bb145bd20607110544u74cf35afra8875ef65394c5a2@mail.gmail.com>
References: <bb145bd20607100948y2f41e034re3c0fb30c8bd1ad5@mail.gmail.com>
	 <Pine.LNX.4.64.0607110823160.858@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0607110823160.858@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Why not just --set-faulty or --fail with mdadm?

This is not about testing, but about real errors.

1) I depend on the md layer to tell me if a disk is faulty ... failing
the disk manually would only help if I already knew the disk was
faulty and just wanted to remove it.

2) If the affected array has root on it it's game over: no logins of
any sort, no issuing commands, no manual failing, since any process
that accesses a fs will hang.

C.
