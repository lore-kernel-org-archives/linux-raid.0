From: Alireza Haghdoost <alireza@cs.umn.edu>
Subject: Re: Optimal chunk size for RAID5?
Date: Sun, 22 Feb 2015 08:33:02 -0600
Message-ID: <CAB-428=7y-KSbCeXo6y6o5Jfzgf-5h6pfYxY+4Z74bqYp=oMUg@mail.gmail.com>
References: <mccemd$8pi$1@ger.gmane.org> <20150222173047.1ea65d67@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150222173047.1ea65d67@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: Christer Solskogen <christer.solskogen@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Feb 22, 2015 at 6:30 AM, Roman Mamedov <rm@romanrm.net> wrote:
> On Sun, 22 Feb 2015 12:31:23 +0100
> Christer Solskogen <christer.solskogen@gmail.com> wrote:
>
>> There are so many different views on the internet
>
> ...and yet you're asking for some more? :)
>
>> Is there even such a thing as optimal chunk size?
>
> 64K should be fine:
> http://louwrentius.com/linux-raid-level-and-chunk-size-the-benchmarks.html
>

I have seen that people report 64K chunk size results better
performance. However, I was not able to find why mdadm maintainers
decided to switch into 512K default chunk size a few years ago ? Was
that decision related to the write-intent bitmap overhead ?
