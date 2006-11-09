From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Too much ECC?
Date: Thu, 9 Nov 2006 17:50:34 +0100
Message-ID: <20061109165034.GR27175@boogie.lpds.sztaki.hu>
References: <200611091530.56024.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200611091530.56024.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Nov 09, 2006 at 03:30:55PM +0100, Dexter Filmore wrote:

> 195 Hardware_ECC_Recovered  3344107

For some models that's perfectly normal.

> Looking at a 5 year old 40GB Maxtor that's not been cooled too well I see "3" 
> as the raw value.

Different technology, different vendor, different meaning of the
attribute.

> Should I be worried or am I just not properly reading this?

If the other attributes are OK then the raw value of
Hardware_ECC_Recovered has not much meaning.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
