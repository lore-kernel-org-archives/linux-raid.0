From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: What's the typical RAID10 setup?
Date: Fri, 04 Feb 2011 11:03:30 -0500
Message-ID: <4D4C2352.9000407@cfl.rr.com>
References: <AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com> <AANLkTimoSvWj3mnowZbVKKHEMzwjiQ=WqRUUsj91n_Zr@mail.gmail.com> <20110131152151.GD7861@cthulhu.home.robinhill.me.uk> <AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com> <AANLkTi=mLFwdLzcjcpzC0JJ=v8Aa817g+CzrR88pmy9y@mail.gmail.com> <AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com> <AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com> <4D470F96.40409@cfl.rr.com> <4D471A41.1090706@hardwarefreak.com> <4D4730C0.8080900@cfl.rr.com> <20110201092007.GA7860@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110201092007.GA7860@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

FYI, you should get in the habit of using your mail client's reply to
all function.  I did not see this until now because you did not send me
a copy.

On 2/1/2011 4:20 AM, Robin Hill wrote:
> No, it's RAID 10 or RAID 1+0. RAID 0+1 would be 2 mirrored pairs of
> 5-disk RAID 0 arrays, in which case you could only lose 5 disks if

In English we read from left to right and top to bottom, so 0+1 means
stripe on top of mirror.

> The md man page would be better for information on the physical layouts,
> but I don't see anything on there to support what you're saying here.

The section on raid10 describes the layouts.  For a 4 disk array, the
default layout of n2 is equivalent to raid 0+1.  A 2, 3, or 5 disk array
is not even possible with 0+1, but raid10 is quite happy with that.
