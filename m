From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: raid6 kernel error
Date: Sat, 24 Jan 2009 19:07:04 -0700
Message-ID: <e9c3a7c20901241807q261f14e5k4aa0a1a909ed45ce@mail.gmail.com>
References: <200901221716.n0MHG01N026618@focus.uchicago.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200901221716.n0MHG01N026618@focus.uchicago.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Clem Pryke <pryke@focus.uchicago.edu>
Cc: linux-raid@vger.kernel.org, Kenneth Aird <kenneth.aird@usap.gov>
List-Id: linux-raid.ids

On Thu, Jan 22, 2009 at 10:16 AM, Clem Pryke <pryke@focus.uchicago.edu> wrote:
> I built a raid6 md array of 12x1.5TB disks. During the initial sync I got a
> kernel error I've not seen before. The sync then
> apparently completed successfully. How serious is this?

Not too serious, it just means that the resync operation prevented
that cpu from rescheduling for a while.  The pending patches to move
raid6 parity calculations outside of the stripe-lock should resolve
this warning.

Thanks,
Dan
