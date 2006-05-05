From: John Rowe <rowe@excc.ex.ac.uk>
Subject: Re: Two-disk RAID5?
Date: Fri, 05 May 2006 10:31:56 +0100
Message-ID: <1146821517.4365.40.camel@kenny>
References: <216D6FA68B0F304DA93E95C5B786F2D12FCBBC@bart.corp.egenera.com>
	 <Pine.LNX.4.61.0604261518020.1846@soloth.lewis.org>
	 <20060501171128.GA18811@harddisk-recovery.com>  <445AA801.6050404@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <445AA801.6050404@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> Sorry, I couldn't find a diplomatic way to say you're completely wrong.

We don't necessarily expect a diplomatic way, but a clear and
intelligent one would be helpful. 

In two-disk RAID5 which is it?

  1) The 'parity bit' is the same as the datum.

  2) The parity bit is the complement of the datum.

  3) It doesn't work at a bit-wise level.

Many of us feel that RAID5 looks like:

  parity = data[0];
  for (i=1; i < ndisks; ++i)
      parity ^= data[i];

which implies (1). It could easily be (2) but merely saying "it's not
data, it's parity" doesn't clarify matters a great deal. 

But I'm pleased my question has stirred up such controversy!

John


