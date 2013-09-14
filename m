From: Derek Piper <derek.piper@gmail.com>
Subject: Re: How-to for enabling TRIM for SSD RAID-1 arrays?
Date: Fri, 13 Sep 2013 23:53:27 -0400
Message-ID: <CAD2NviU0ptD9BUWnqVYsJsyi6e+8mffYSbWz+HDwdi721cq5gA@mail.gmail.com>
References: <CAD2NviVyoF4y9uQnvcng082zAGQoXq18JT7WM=+RfBGCzCp9zA@mail.gmail.com>
	<523397BE.8080404@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <523397BE.8080404@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have 2 Sandisk Extreme 120GB SSDs (Sandforce 2281 with latest
firmware - R211). I have indeed heard that TRIM was desirable to limit
the effects of write amplification and to keep the write performance
to a good level throughout the life of the drive(s). This machine is a
home file/print/web/mysql server (the real large data being on regular
7200RPM HDD RAID arrays). The SSDs are for boot, root and home
directories.

A periodic 'garbage collection' type TRIM operation would be fine, and
can be run at a cron job I see. It was not clear to me how the md-raid
went about enabling that at the device level so fstrim would even
work.

In looking over the SanDisk Extreme with SandForce stuff relating to
the firmware revision it appears that it is 5.03 or 5.04 in revision
R211. It's possible that it might just not be worth it. I had a
feeling that by enabling TRIM it would help my drives out. If that's
not the case then it may best be left alone.

Thanks,

Derek

On Fri, Sep 13, 2013 at 6:54 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 9/13/2013 3:25 PM, Derek Piper wrote:
>
>> Having found a posting on this list from July this year, I am trying to
>> find if (and how) TRIM support is supported and enabled under RAID 1 with 2
>> SSD drives.
>
> The are more important questions to first ask yourself.
>
> 1.  Will TRIM benefit your make/model of SSDs?
>     Are they the same brand, model, and firmware?  If different brands
>     or models, or even the same model w/different firmware, the two may
>     behave completely differently WRT TRIM.  One may speed up while the
>     other slows down.
>
> 2.  Will it benefit your workloads?
>
> 3.  How compressible are your files, on average?
>
> 4.  Which SSDs?  SandForce 22xx based?  Which firmware rev?  See:
> http://www.anandtech.com/show/6107/corsair-force-series-gs-240gb-review
>
> 5.  Do you plan to use realtime discard or batch discard?  Most recent
>     data shows that realtime discard murders performance.
>
>
> Summary:  There is much, much, more to optimizing SSD performance than
> getting TRIM working down the stack.  In fact some SSDs work better
> without TRIM, and some perform worse when TRIM is used.
>
> For many users, TRIM is a solution to a problem they may never have.
> They simply want it because they've read somewhere that they should have it.
>
> --
> Stan
>
>
>



-- 
Derek Piper - derek.piper@gmail.com
