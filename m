From: Mark Watts <mrwatts@fast24.co.uk>
Subject: Re: Scrub?
Date: Fri, 6 Aug 2004 20:14:08 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408062014.08382.mrwatts@fast24.co.uk>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01153121@otce2k03.adaptec.com> <1951.216.222.31.66.1091819236.squirrel@mail.oversimplified.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1951.216.222.31.66.1091819236.squirrel@mail.oversimplified.com>
Content-Disposition: inline
To: Derek Listmail Acct <listmail@oversimplified.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 06 Aug 2004 8:07 pm, Derek Listmail Acct wrote:
> > dd if=/dev/zero of=/dev/md0 bs=200b
>
> This will fill the array with zeros, which isn't what I want to do.  I'm
> trying to verify the parity data for my raid 5 array is correct.  I feel
> one of my drives may be failing, and want to make sure the array is
> consistent.

Thats array verification, not scrubbing (which is erasing the disk)
