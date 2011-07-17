From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: Software RAID and TRIM
Date: Sun, 17 Jul 2011 23:57:12 +0200
Message-ID: <ivvln5$dcd$2@dough.gmane.org>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk> <BANLkTimswAVra6qnMS4g8WRzs=dhi_f7OQ@mail.gmail.com> <alpine.OSX.2.00.1106291119200.257@trogdor.csi.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.00.1106291119200.257@trogdor.csi.cam.ac.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tom De Mulder wrote:
> Yes, it's (usually/ideally) the filesystem's job to invoke the TRIM 
> command

Well, for us voluntarily (cron-triggered) batch-discards have shown
to be the better option. If you leave it to the filesystem to
trigger the discards, then you might lose write performance
when you need it most.

In comparison, a voluntarily triggered discard in some low-usage time
is painless.

Regards,

Lutz Vieweg

