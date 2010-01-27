From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: woes with... mdadm ?
Date: Tue, 26 Jan 2010 20:14:22 -0800
Message-ID: <4877c76c1001262014w6219132ew552b092dab9aba62@mail.gmail.com>
References: <4B5F6C5D.8020202@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B5F6C5D.8020202@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: Maarten <maarten@ultratux.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Lets validate some basics first:

1, 2) Have you stress-tested your CPU and ram?

3: the CRC is off only on two nibbles (between bits 4 and 11); and
nowhere else.  That usually doesn't happen with CRCs.
3) >> In the past I had some similar SATA controllers become corrupted
by some test-debugging code in an older version of the kernel.  Even
if the devices firmware is up to date TRY REFLASHING/'updating' THEM.
<<

4) Have you run S.M.A.R.T. self tests
5) If possible badblocks as well; once you've verified everything else.

Those are all possible and easy to test for causes of data-corruption.
