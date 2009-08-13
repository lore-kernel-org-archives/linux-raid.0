From: "John Robinson" <john.robinson@anonymous.org.uk>
Subject: Re: Help understanding the root cause of a member dropping out of
     a  RAID 1 set.
Date: Thu, 13 Aug 2009 17:26:39 +0100 (BST)
Message-ID: <64960.78.86.108.203.1250180799.squirrel@www.yuiop.co.uk>
References: <ABFC24E4C13D81489F7F624E14891C860BF9A409@uk-ex-mbx1.terastack.bluearc.com>
    <a43edf1b0908130913x238b33ecref5a3d070bf3cb16@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a43edf1b0908130913x238b33ecref5a3d070bf3cb16@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 13 August, 2009 5:13 pm, Billy Crook wrote:
> On Thu, Aug 13, 2009 at 03:44, Simon Jackson<sjackson@bluearc.com> wrote:
[...]
>> 2009-08-11T06:21:08-07:00 Metro-1 kernel: [556573.348168] md:
>> super_written gets error=-5, uptodate=0
>
> mdraid notices.  says oh craps.
>
>> 2009-08-11T06:21:08-07:00 Metro-1 kernel: [556573.348168] raid1:
>> Operation continuing on 1 devices.
>
> mdraid marks the component that encountered the error failed, and
> keeps on keeping on
>
>> 2009-08-11T06:21:08-07:00 Metro-1 kernel: [556573.348168] ata1: EH
>> complete
>
> ata reset (of link, and subsequently drive) is complete.

Can or could md be made or configured to try re-adding a device if this
sort of thing happens? After all, a stray cosmic ray or whatever perhaps
shouldn't make one lose redundancy if the drive's actually OK?

Cheers,

John.

