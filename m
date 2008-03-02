From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Strange RAID-5 rebuild problem
Date: Sun, 02 Mar 2008 13:09:36 +0300
Message-ID: <47CA7CE0.9050702@msgid.tls.msk.ru>
References: <656D8E57-804D-4A63-B9CA-D3C899616F61@it-loops.com> <3816592D-B75C-4B00-B3B7-65AE3B403DB0@it-loops.com> <20080301222326.GA20435@cthulhu.home.robinhill.me.uk> <2BABB51E-7701-44D4-AD07-6394CCF77941@it-loops.com> <A5F6B52A-00BB-4096-9A8D-367F61989186@it-loops.com> <244F7F54-081B-462E-A0AD-8E5E1056B90B@it-loops.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <244F7F54-081B-462E-A0AD-8E5E1056B90B@it-loops.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Guntsche <mike@it-loops.com>
Cc: linux-raid@vger.kernel.org, Robin Hill <robin@robinhill.me.uk>
List-Id: linux-raid.ids

Michael Guntsche wrote:
> 
[]
> Answering myself here after reading through the manapges, this seems to 
> be a regression. Furthermore this may yield to some nasty data 
> corruption, well at least I think it will.
> 
> * --stop the array while resyncing.
> * set start_ro to 1
> * Start the array, automatic reconstruction does not start even after 
> the data is been written to the ARRAY

You can't write any data to a read-only array.

/mjt

> * stop the array again
> * set start_ro to 0
> * Start the array again
> The array picks up the resync process where it stopped the first time 
> even if there has already been data written to it, while it was started 
> with start_ro = 1.
> Won't this yield corrupted data, since data BEFORE that offset might 
> actually have changed in the mean time?
> 
> Kind regards,
> Michael

