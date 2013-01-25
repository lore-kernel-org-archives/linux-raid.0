From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Failing to grow raid10 with one larger disk
Date: Thu, 24 Jan 2013 19:07:24 -0700
Message-ID: <86C569BD-4731-4920-905E-B90DB78204CB@colorremedies.com>
References: <CAOHBbgU5Uf+eD=O7_0K1AKn_t+RcdaeAQabf9XSST8qtcbaAsw@mail.gmail.com> <CADNH=7H+r25QRY0RekU+ukG=s-TT9FNfMnfctj=oKniPiYL0-Q@mail.gmail.com> <CAOHBbgVizy_LTyOaT=WUyPbFjOOLLxRFnMT3hYWPF5cVmRpHJg@mail.gmail.com> <5101DB37.7030407@fnarfbargle.com> <CAOHBbgUbbxWZh2TM5m+o6ULHxctGPOs55mK3sKrX8A-D5UKJCg@mail.gmail.com> <5101E09B.3030404@websitemanagers.com.au> <CAOHBbgXYX3xOuOKWHRbJSbRhm-==bZ8JLpjOXvAwwMce+1S6tQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOHBbgXYX3xOuOKWHRbJSbRhm-==bZ8JLpjOXvAwwMce+1S6tQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Asif Iqbal <vadud3@gmail.com>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 24, 2013, at 6:56 PM, Asif Iqbal <vadud3@gmail.com> wrote:
> 
> I like this method. However, can I have raid10 with disks of multiple sizes?
> ( for my case 2 76G and 4 300G )

Yes but it will only be as large as 2x the size of the lowest common denominator sized block device (disk or parition). There's simply no way you can have a raid10 array get bigger just be swapping out one of the disks with a larger disk. All of them must get bigger for the array to grow.

A RAID 10 is first a mirror, those two block devices must be the same size to be the same. And then to stripe, the mirrors must be the same size. So what you want to do is only workable by having all disks the same size.


Chris Murphy

