From: Dan Christensen <jdc@uwo.ca>
Subject: Re: "raid" versions of hard drives for software raid?
Date: Wed, 02 Jul 2008 16:54:30 -0400
Message-ID: <87tzf8ovll.fsf@uwo.ca>
References: <873amsqbag.fsf@uwo.ca> <486BE720.3090507@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brendan Conoboy <blc@redhat.com> writes:

> Dan Christensen wrote:
>> I'm looking at either the Western Digital 500G RE2 drives or the cheaper
>> 500G SE16 drives.  I have read that for use with a hardware raid card,
>> the RE2 drives are more appropriate, and I'm wondering if the same is
>> true for software raid.
>
> It's a mechanical property- vibration tolerance and whatnot.  No
> difference between software and hardware raid in this sense.

The difference that is most commonly described, and that I should have
highlighted, is TLER: Time-Limited Error Recovery.  Apparently, the SE16
drives can take a long time to recover from an error (up to two minutes,
I believe), and hardware raid controllers can kick the drives out of the
array when it would instead be better for the drive to return a
read/write error and let the raid controller deal with it.

My question is really whether this logic applies to linux software raid.

One other point is that I also read that TLER can be enabled and
disabled for both SE16 and RE2 drives using Windows software.  Not sure
if it runs under wine.  See

  http://www.hardforum.com/archive/index.php/t-1285254.html

Dan

