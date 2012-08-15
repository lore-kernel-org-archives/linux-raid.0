From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: O_DIRECT to md raid 6 is slow
Date: Wed, 15 Aug 2012 12:50:55 +0100
Message-ID: <502B8D1F.7030706@anonymous.org.uk>
References: <CALCETrWCu=UPATPdqWP=Gpvswv-RDwaxfr1W1jxYtUMZsqKgSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWCu=UPATPdqWP=Gpvswv-RDwaxfr1W1jxYtUMZsqKgSQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15/08/2012 01:49, Andy Lutomirski wrote:
> If I do:
> # dd if=/dev/zero of=/dev/md0p1 bs=8M
[...]
> It looks like md isn't recognizing that I'm writing whole stripes when
> I'm in O_DIRECT mode.

I see your md device is partitioned. Is the partition itself stripe-aligned?

Cheers,

John.
