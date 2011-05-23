From: Ed W <lists@wildgooses.com>
Subject: Re: HBA Adaptor advice
Date: Mon, 23 May 2011 11:42:04 +0100
Message-ID: <4DDA39FC.5060001@wildgooses.com>
References: <20110523021234.1BAEAF9C03C@mail.fulab.com> <BANLkTindNRCxRUpfpONnKPwoE8fg7SbgZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTindNRCxRUpfpONnKPwoE8fg7SbgZw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tobias McNulty <tobias@caktusgroup.com>
Cc: Jim Schatzman <James.Schatzman@fulab.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/05/2011 04:39, Tobias McNulty wrote:
> One odd statistical fluke regarding quality control on the large Green
> drives:  I ordered 3 of the drives on Amazon and 3 on Newegg, and all
> 3 of the Newegg drives failed very quickly (within a couple weeks),
> while all 3 of the Amazon drives are still going strong (5 months old
> and on 24/7).  I'm not sure if it was a packaging issue or an issue
> with that particular set of drives that Newegg had in stock, but it
> left me wondering.


I had some similar experience with some Samsung F3 drives recently.  Not
as clear cut as your example, but I have found other examples in the
archives here which suggest that drive failure might correlate with
batch number?  I'm sure I have seen others suggest trying to build
arrays out of mixed batch (or perhaps brand?) drives

Going back some 10-15 years when I used to put paired raid1 drives into
our office servers, every failure I ever had appeared to affect both
drives within some few hours of each other... (less than 48 hours say).
 There are plenty of external reasons to explain that (besides drives
reaching end of life), such as power fluctuations, temperature, etc, but
punchline remains that mirroring didn't buy me much protection...

Tricky to make this stuff reliable.. Small probabilities and
catastrophic scenarios are hard to value...

Ed W
