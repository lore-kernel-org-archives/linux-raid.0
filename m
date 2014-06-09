From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: RAID-10 explicitly defined drive pairs?
Date: Mon, 9 Jun 2014 17:26:38 +0300
Message-ID: <CAGRgLy5tauPMAoy=3QkErvtQPjz3FrNYTxQ-2rxTP6nO5tRXXQ@mail.gmail.com>
References: <20111212115459.GC20730@fi.muni.cz>
	<4EE61EAE.20101@anonymous.org.uk>
	<20120106150823.GX25976@fi.muni.cz>
	<20120107075526.59ed433c@notabene.brown>
	<CAGRgLy4Q5FhHMAeU3egqEfFKR_h1HneReg0sD_+hCmsF3WDzQw@mail.gmail.com>
	<20120322213114.61fd4e44@notabene.brown>
	<CAGRgLy7N7m4zFY-EKe8ApUGSR3ZCUpOTZcRvLVLd5WAN2f+k9g@mail.gmail.com>
	<CAGRgLy7BaVTjacaqMVD1JNYgtTn6MAk9bN-GzDC8B0CypJWJmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy7BaVTjacaqMVD1JNYgtTn6MAk9bN-GzDC8B0CypJWJmw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Why do you refuse to freeze the array if it's not "idle"? What will
> happen is that current recover/resync will abort, drives will be
> added, and on unfreezing, array will resume (restart?) recovery with
> all drives. If array was resyncing, however, it will start recovering
> the newly added drives, because kernel prefers recovery over resync
> (as we discussed earlier).
Indeed, since dea3786ae2cf74ecb0087d1bea1aa04e9091ad5c, I see that you
agree to freeze the array also in case it is recovering.

Alex.
