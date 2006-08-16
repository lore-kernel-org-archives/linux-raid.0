From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: remark and RFC
Date: Wed, 16 Aug 2006 16:59:53 +0200
Message-ID: <62b0912f0608160759u37879015hec81eaaf8439e68d@mail.gmail.com>
References: <200608160906.k7G96A204753@inv.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200608160906.k7G96A204753@inv.it.uc3m.es>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: ptb@inv.it.uc3m.es
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Peter T. Breuer wrote:
> I would like raid request retries to be done with exponential
> delays, so that we get a chance to overcome network brownouts.

Hmm, I don't think MD even does retries of requests.

It does write-back as a (very successful! Thanks Neil :-D) attempt to
fix bad blocks, but that's a different thing.

Is that what you meant?

Or is there something sandwiched between MD and ENBD that performs retries...

Or am I just wrong :-)..
