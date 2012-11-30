From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: Raid 0+1
Date: Fri, 30 Nov 2012 15:27:56 +0100
Message-ID: <50B8C26C.7000807@profitbricks.com>
References: <CAAo+KF=-XStwczZvxPh7jgLZzwEAD71XWWg0h5HBXekBO8-5vQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAo+KF=-XStwczZvxPh7jgLZzwEAD71XWWg0h5HBXekBO8-5vQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Oguz Yilmaz <oguzyilmazlist@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 30.11.2012 14:25, Oguz Yilmaz wrote:
> What is the suggested way for making Raid 0+1 (not 1+0)?
> Is it possible to make it without LVM?

Yes, it is possible but it only makes sense if you want to mirror to
another server as most people know that the alternative DRBD is too slow
for serious storage requirements.

Create the RAID-0 first, then take your RAID-0 device and e.g. an iSCSI
device from another storage server with the same setup and create a
RAID-1 over them. Then, you've got your stacked MD layers.

With the flag write-mostly you can even tell the read balancing that the
remote device is slower than the local one.

Cheers,
Sebastian
