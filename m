From: Phil Turmel <philip@turmel.org>
Subject: Re: question about RAID10 near and far layouts
Date: Mon, 11 Jun 2012 08:28:22 -0400
Message-ID: <4FD5E466.4050409@turmel.org>
References: <1339377964.38410.YahooMailClassic@web190004.mail.sg3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1339377964.38410.YahooMailClassic@web190004.mail.sg3.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: plug bert <plugbert@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/10/2012 09:26 PM, plug bert wrote:
> hi peeps,
> 
> i've been reading through
> 
> http://en.wikipedia.org/wiki/Non-standard_RAID_levels
> 
> and just wanted to verify if my understanding is correct.
> 
> Is "near" safer than "far"?
> 
> e.g. given 4 drives in RAID10 array, n2:
> 
> 4 drives
> 
> 1 2 3 4
> --------------
> A1 A1 A2 A2
> A3 A3 A4 A4
> A5 A5 A6 A6
> A7 A7 A8 A8
> 
> you'd lose the array if either 1&2 or 3&4 goes down at the same time.
> 
> 
> With 4 drives in RAID10 array, f2:
> 
> 4 drives
> 1 2 3 4
> --------------------
> A1 A2 A3 A4
> A5 A6 A7 A8
> A9 A10 A11 A12
> .. .. .. ..
> A4 A1 A2 A3
> A8 A5 A6 A7
> A12 A9 A10 A11
> 
> ...there seems to be a lot more combinations that can result in a trashed array(1&2, 2&3, 3&4).
> 
> Is my analysis correct? Inputs are more than welcome, tia

I think wikipedia might have this layout wrong.  I was under the
impression that a four-disk far2 layout would be:

> 1 2 3 4
> --------------------
> A1 A2 A3 A4
> A5 A6 A7 A8
> A9 A10 A11 A12
> .. .. .. ..
> A2 A1 A4 A3
> A6 A5 A8 A7
> A10 A9 A12 A11

I haven't checked the code, though.

Phil
