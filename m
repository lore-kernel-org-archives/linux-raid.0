From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: SV: RAID-6 support in kernel?
Date: Tue, 4 Jun 2002 14:59:55 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <adidsu$k6r$2@main.gmane.org>
References: <2D0AFEFEE711D611923E009027D39F2B02F17E@nasexs1.meridian-data.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2D0AFEFEE711D611923E009027D39F2B02F17E@nasexs1.meridian-data.com>
To: Dale Stephenson <dale.stephenson@quantum.com>, 'Kasper Dupont' <kasperd@daimi.au.dk>
Cc: Christian Vik <cvik@vanadis.no>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Of course, for a 4 drive setup there's no reason to use RAID 6 at all (RAID
> 10 will withstand any two drive failure if you only use 4 drives), but
> that's the reasoning.  I think the best way to deal with the read-modify
> write problem for RAID 6 is to use a small chunk size and deal with NxN
> chunks as a unit.  But YMMV.

RAID10 will _not_ withstand any two-drive fail in a 4-drive scenario. If D1 
and D3 fail, you're fscked

D1 D2
D3 D4

-- 
Roy Sigurd Karlsbakk, Datavaktmester

Computers are like air conditioners.
They stop working when you open Windows.
