From: Antonio Perez <ap23563m@gmx.com>
Subject: Re:
Date: Wed, 06 Jan 2010 16:57:52 -0400
Message-ID: <5088676.PTlYT5Mo9Q@rnqqfki.eternal-september.org>
References: <600349.38000.qm@web88207.mail.re2.yahoo.com> <4877c76c1001061221w582efcfdudc9a33c0f74a756a@mail.gmail.com>
Reply-To: ap23563m@gmx.com
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Evans wrote:
[...] 
> Grub wants to embed (copy it's executable) in to the area between the
> MBR style layout (sector 0 of a drive) and the first partition on that
> drive (typically starts as early as sector 63).  Try starting the
> first partition at something like a 1 or 2 mb offset from the start of
> the drive.  That should likely be enough space.

	...something like a 1 or 2 mb offset...

Grub-core is about 26k, anything bigger than 30k should be enough, right?

-- 
Antonio Perez

