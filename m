From: Phil Turmel <philip@turmel.org>
Subject: Re: Proposal for metadata version 2.x :)
Date: Sun, 17 Jun 2012 09:37:02 -0400
Message-ID: <4FDDDD7E.2040009@turmel.org>
References: <CA+sTkh6ATWGjByZuKvRCkcwTW1cJw73mNNK92LW5WNfpi2eXKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sTkh6ATWGjByZuKvRCkcwTW1cJw73mNNK92LW5WNfpi2eXKA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Igor M Podlesny <for.poige+lsr@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/17/2012 06:12 AM, Igor M Podlesny wrote:
>    Hi! If I understand correctly, one cannot safely switch between 1.x
> metdata layouts since data offsets would be different, right?
> 
>    Why not to overcome this limitation by holding all three metadata
> zones reserved to prevent RAID data allocation inside them? It doesn't
> seem to be significant waste of disk space, but would be more flexible
> indeed.

A very useful property of v1.0 metadata is that the contents start at
the partition start, making Raid1 contents available to bootloaders when
the array isn't running.  That behavior is incompatible with your
suggestion, so your suggestion will be unacceptable to anyone using that
behavior to their advantage.  (Like me.)

Phil
