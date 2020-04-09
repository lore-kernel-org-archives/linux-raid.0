From: "Andrey ``Bass'' Shcheglov" <andrewbass@gmail.com>
Subject: Re: Repairing a RAID1 with non-zero mismatch_cnt, vol. 2
Date: Fri, 10 Apr 2020 00:18:34 +0300
Message-ID: <CADSg1JgwR7C6iqTz7gA3tw1WB=NT9_3Wwa1KHbsYLbPh23qrJQ@mail.gmail.com>
References: <CADSg1Jh1i+OPq0_hWOvHxK0xroUbn_w0_ZjxjwcnrbSsBXGY5A@mail.gmail.com>
 <5E25876A.1030004@youngman.org.uk> <CADSg1Jj3XmD_RmSedn3AT9uCXbHQGa6ATBK1UP33onS8Vi=60g@mail.gmail.com>
 <CADSg1Jh7=6XHXbDqWVWg=fa-+09Vd9E+KBuTy6AWucJesFkBmQ@mail.gmail.com> <20200409071940.GA4072@cthulhu.home.robinhill.me.uk>
Reply-To: andrewbass@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200409071940.GA4072@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: robin@robinhill.me.uk
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Indeed.

The subsequent check resulted in the zero value of mismatch_cnt.

Thank you Robin.

Regards,
Andrey.

On Thu, 9 Apr 2020 at 10:19, Robin Hill <robin@robinhill.me.uk> wrote:
>
> The mismatch_cnt after repair indicates how many repairs were completed.
> You need to run a new repair/check to see whether there are any
> remaining mismatches.
