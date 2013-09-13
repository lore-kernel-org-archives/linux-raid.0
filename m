From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: Implementing --detail-platform for DDF
Date: Thu, 12 Sep 2013 17:18:13 -0700
Message-ID: <CAA9_cmcoSkDL_afvnBL09eSryAPYd-90wk1XJZ_Hvo4CdEQgpg@mail.gmail.com>
References: <5230D9D6.7030005@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5230D9D6.7030005@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

On Wed, Sep 11, 2013 at 2:00 PM, Martin Wilck <mwilck@arcor.de> wrote:
> Hi Neil,
>
> I thought I might come up with an implementation of mdadm
> --detail-platform for DDF, but I encountered a problem I'd like to discuss.
>
> For DDF, we can't scan PCI devices like IMSM does, because we don't know
> all controllers supporting DDF. Thus I considered scanning block devices
> instead and looking at "foreign" vendor strings in the meta data;
> possibly also filtering by device names or types. It occured to me that
> it might be elegant to simply call conf_get_devs() for a list of devices
> to be scanned. But if I do that, config.o and its dependencies must be
> linked with mdmon, blowing up its size considerably. I figure that
> that's a no-go. But I'm also reluctant to write my own DDF-specific
> block device scanning code while there is conf_get_devs() already.
>
> Perhaps I am misunderstanding the purpose of --detail-platform?
> I wouldn't bother with it if YaST2/libstorage didn't call it in order to
> check if a "fake RAID" platform is present.

--detail-platform is more about finding the presence of the raid
option-rom / firmware support.  I can imagine the installer may want
to confirm that an array is bootable before installing to it.

Is it enough to scan for devices that self-report as raid controllers?
 Problem then becomes finding a cross-implementation method to parse
the firmware signature to detect DDF capabilities.

--
Dan
