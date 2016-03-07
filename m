From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Import/recover RAID6 created with SAS2108?
Date: Mon, 7 Mar 2016 22:50:26 +0100
Message-ID: <20160307215026.GA8042@EIS>
References: <2832CD22-EADC-4BC6-A250-FE8919A92E0A@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2832CD22-EADC-4BC6-A250-FE8919A92E0A@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Russell <dpr@aol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Mar 06, 2016 at 04:37:42PM -0500, Dan Russell wrote:
> can md read a RAID6 created by the 2108, or would I be wasting my time?

It might be possible.

I don't use HW-RAID anywhere but if I was forced to, this would be 
one of the first things to determine, how to read it with software 
in case the card fails.

> I can paste or gist the output of madam -E (304 lines) if it would help.

I don't know if it would help, but paste everything you have anyhow.

Is the data encrypted? If not - search for known file type headers 
(like a large jpeg or tar.gz, something larger than disks * chunksize), 
then look at the data on the other disks at the same offsets 
(grab a few megs of each disks), then try to deduce the layout 
and structure from that.

Basically use known data to reverse-engineer the layout if you 
currently know nothing about disk orders, chunk sizes, etc.

Regards
Andreas Klauer
