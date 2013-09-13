From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: How-to for enabling TRIM for SSD RAID-1 arrays?
Date: Fri, 13 Sep 2013 17:54:54 -0500
Message-ID: <523397BE.8080404@hardwarefreak.com>
References: <CAD2NviVyoF4y9uQnvcng082zAGQoXq18JT7WM=+RfBGCzCp9zA@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAD2NviVyoF4y9uQnvcng082zAGQoXq18JT7WM=+RfBGCzCp9zA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Derek Piper <derek.piper@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/13/2013 3:25 PM, Derek Piper wrote:

> Having found a posting on this list from July this year, I am trying to
> find if (and how) TRIM support is supported and enabled under RAID 1 with 2
> SSD drives.

The are more important questions to first ask yourself.

1.  Will TRIM benefit your make/model of SSDs?
    Are they the same brand, model, and firmware?  If different brands
    or models, or even the same model w/different firmware, the two may
    behave completely differently WRT TRIM.  One may speed up while the
    other slows down.

2.  Will it benefit your workloads?

3.  How compressible are your files, on average?

4.  Which SSDs?  SandForce 22xx based?  Which firmware rev?  See:
http://www.anandtech.com/show/6107/corsair-force-series-gs-240gb-review

5.  Do you plan to use realtime discard or batch discard?  Most recent
    data shows that realtime discard murders performance.


Summary:  There is much, much, more to optimizing SSD performance than
getting TRIM working down the stack.  In fact some SSDs work better
without TRIM, and some perform worse when TRIM is used.

For many users, TRIM is a solution to a problem they may never have.
They simply want it because they've read somewhere that they should have it.

-- 
Stan



