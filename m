From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [patch] limit error rate
Date: Tue, 22 Apr 2008 17:44:10 -0700
Message-ID: <e9c3a7c20804221744m6600eccdy9934f58fb6ccded3@mail.gmail.com>
References: <ftquac$82m$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ftquac$82m$1@ger.gmane.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bernd-schubert@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Apr 12, 2008 at 11:16 AM, Bernd Schubert <bernd-schubert@gmx.de> wrote:
> Hello,
>
>  last night we had scsi problems and a hardware raid
>  unit was offlined during heavy i/o. While this happened we got for
>  about 3 minutes a huge number messages like these
>
>  Apr 12 03:36:07 pfs1n14 kernel: [197510.696595] raid5:md7: read error not correctable (sector 2993096568 on sdj2).
>
>  I guess the high error rate is responsible for not scheduling other
>  events - during this time the system was not pingable and in the end
>  also other devices run into scsi command timeouts causing problems on
>  these unrelated devices as well.
>
>
>  Signed-off-by: Bernd Schubert <bernd-schubert@gmx.de>
>

Hi Bernd,

This patch is whitespace damaged (tabs-->spaces).  Can you resend as
an attachment?

Thanks,
Dan
