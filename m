From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Was: [RFC PATCH 2.6.23.1] md: add dm-raid1 read balancing
Date: Wed, 07 Nov 2007 10:15:40 +0100
Message-ID: <87fxziju0z.fsf@informatik.uni-tuebingen.de>
References: <1194084522.1353.10.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1194084522.1353.10.camel@localhost> (Konstantin Sharlaimov's
	message of "Sat, 03 Nov 2007 20:08:42 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: konstantin.sharlaimov@gmail.com
Cc: linux-raid <linux-raid@vger.kernel.org>, Rik van Riel <riel@redhat.com>, "; Ingo Molnar" <mingo@redhat.com>, "; Neil Brown" <neilb@suse.de>
List-Id: linux-raid.ids

Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com> writes:

> This patch adds RAID1 read balancing to device mapper. A read operation
> that is close (in terms of sectors) to a previous read or write goes to 
> the same mirror.

I wonder if there shouldn't be a way to turn this off (or if there
already is one).

Or more generaly an option to say what is "near". Specifically I would
like to teach the raid1 layer that I have 2 external raid boxes with a
16k chunk size. So read/write within a 16k chunk will be the same disk
but the next 16k are a different disk and "near" doesn't apply
anymore.

MfG
        Goswin

