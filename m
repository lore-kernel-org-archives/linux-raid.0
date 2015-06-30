From: Nate Clark <nate@neworld.us>
Subject: Re: I/O error reading from raid 1 device but not slave devices
Date: Tue, 30 Jun 2015 10:46:38 -0400
Message-ID: <CAG2YfWOn5_9KAK+qFY3XBBrh2L2HuxDCoc_6kzEEV8diyeG3Wg@mail.gmail.com>
References: <CAG2YfWMfwtNkLGoswsZVSxpTm+BxdQD8e1ZB+Mc2+PxWrWSAYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAG2YfWMfwtNkLGoswsZVSxpTm+BxdQD8e1ZB+Mc2+PxWrWSAYw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jun 29, 2015 at 5:35 PM, Nate Clark <nate@neworld.us> wrote:
> Hello,
>
> I have encountered a strange error while reading from a raid 1 device.
> If I read from the md device I encounter an I/O error, however if I
> read from the underlying devices there is no issue.

It appears both drives in the array have identical bad blocks list. I
am not sure why any blocks were marked bad since I don't see any drive
I/O errors in the logs and the smart output from each drive shows they
are healthy.

Thanks,
-nate
