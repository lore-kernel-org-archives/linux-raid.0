From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 3.12: raid-1 mismatch_cnt question
Date: Thu, 7 Nov 2013 05:54:01 -0500
Message-ID: <CAO9zADxbiW_OBiewAY8JQQjxS51Ydrm8Rj1=MWXCA+Xo9K3=2Q@mail.gmail.com>
References: <000f01ced948$2fbab140$8f3013c0$@lucidpixels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000f01ced948$2fbab140$8f3013c0$@lucidpixels.com>
Sender: linux-raid-owner@vger.kernel.org
To: open list <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 4, 2013 at 5:25 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> Hi,
>
> I run two SSDs in a RAID-1 configuration and I have a swap partition on a
> third SSD.  Over time, the mismatch_cnt between the two devices grows higher
> and higher.
>
> Once a week, I run a check and repair against the md devices to help bring
> the mismatch_cnt down.  When I run the check and repair, the system is live
> so there are various logs/processes writing to disk.  The system also has
> ECC memory and there are no errors reported.
>
> The following graph is the mismatch_cnt from June 2013 to current; each drop
> represents a check+repair.  In September, I dropped the kernel/vm caches
> before running check/repair and that seemed to help a bit.
> http://home.comcast.net/~jpiszcz/20131104/md_raid_mismatch_cnt.png
>
> My question is: is this normal or should the mismatch_cnt always be 0 unless
> there is a HW or md/driver issue?
>
> Justin.
>

Hi,

Could anyone please comment if this is normal/expected behavior?

Thanks,

Justin.
