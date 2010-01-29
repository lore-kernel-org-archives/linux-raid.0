From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: woes with... mdadm ?
Date: Thu, 28 Jan 2010 20:58:32 -0800
Message-ID: <4877c76c1001282058s6931a9e2tbe0da4ef67428680@mail.gmail.com>
References: <4B5F6C5D.8020202@ultratux.net>
	 <4877c76c1001262014w6219132ew552b092dab9aba62@mail.gmail.com>
	 <4B608645.8030102@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B608645.8030102@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: Maarten <maarten@ultratux.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The point about the CRC being only slightly off is that usually a
change in the data-set produces a much larger variation.  It could be
only a single bit or two near the end.

The point about stress-testing the CPU/RAM is to validate that those
are known clean in as close to a high-temp real load environment as
possible.

That would then point to corruption on the cables or drives.  Which
you can diagnose more easily individually instead of as part of an
array.
