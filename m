From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Sun, 26 Apr 2009 21:08:19 +0200
Message-ID: <20090426190819.GA11161@lazy.lzy>
References: <20090420181736.GB4236@lazy.lzy> <20090420211332.GA5550@maude.comedia.it> <20090421181519.GA4114@lazy.lzy> <1240416414.10178.1.camel@cichlid.com> <9A77DB27-C12A-4BA2-94C4-D59B7DAFF32C@redhat.com> <20090424191509.GA28484@lazy.lzy> <302D7194-F25F-48B8-95E3-1A0A054A411F@redhat.com> <20090426121412.GA11921@lazy.lzy> <20090426125852.GA14517@lazy.lzy> <3649DFAC-EFCA-4E81-B459-7A601156B5A6@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3649DFAC-EFCA-4E81-B459-7A601156B5A6@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Apr 26, 2009 at 02:06:31PM -0400, Doug Ledford wrote:
[...]
> You can update the two udev rules files and things should work fine  
> after that.

Thank you for the clarifications.

Unfortunately, it seems that the two rules sets are
not working on F10.
After adding the two files and removing the old one
(I guess replaced by the 65-md-incremental.rules),
on hot plug nothing happens.
I removed all the old md files, but this did not help.

Maybe something else from F11 is required, udev-141
or mdadm-3.0 or the kernel.

Thanks again,

bye,

-- 

piergiorgio
