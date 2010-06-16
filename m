From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: mdadm freezes the system
Date: Wed, 16 Jun 2010 00:03:54 -0700
Message-ID: <AANLkTikdknJnRpHrMybjFTFDRHTH9ad4Rne_wyQ_-84s@mail.gmail.com>
References: <20100608145913.187a69ca@natsu> <20100608222434.3f0fb637@natsu>
	<20100611004316.7d8ad74d@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100611004316.7d8ad74d@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Have you exhaustively tested your drives as well?

The smartctl -t long test is a good one to start with.  If you fail it
sometimes re-writing the sector(s) in the area of the failure allow
the drive to resolve the problem by using one of the space sectors
(the drive hides a handful of from normal use and keeps them in
reserve for just such occasions).  However I recently had a drive I
had to pull out and use the manufacturer's utility to 'zero'
(erase/wipe) everything; it then finally passed a similar test within
the drive utility.  I expect it to resync without further issue.
