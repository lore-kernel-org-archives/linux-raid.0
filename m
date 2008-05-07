From: rosenfield.albert@gmail.com
Subject: Re: two questions re. proactive recovery and forced assembly
Date: Wed, 7 May 2008 14:52:30 +0200
Message-ID: <c4985c940805070552t227d29c5l6660e1b8c735b81d@mail.gmail.com>
References: <c4985c940804100501g5cac252ax129328371c36d397@mail.gmail.com>
	 <48013976.6020705@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48013976.6020705@sauce.co.nz>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> More information on md RAID options can be found in the file md.txt, in the
> Documentation directory of the kernel source.

Looking over md.txt, there is also a less introsive 'check' option,
which it seems does not assume that the array is dirty to begin with.

The documentation says that 'check' "may repair the disk".  What does
that mean?  Will it or won't it?  (does it suffice to use 'check' in a
cron job?)
