From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: RAID-10 explicitly defined drive pairs?
Date: Wed, 11 Jun 2014 19:05:20 +0300
Message-ID: <CAGRgLy706GQmVQSvxnLkXyYooaghjteVx9c11LdRxDjYyBwdDw@mail.gmail.com>
References: <20111212115459.GC20730@fi.muni.cz>
	<4EE61EAE.20101@anonymous.org.uk>
	<20120106150823.GX25976@fi.muni.cz>
	<20120107075526.59ed433c@notabene.brown>
	<CAGRgLy4Q5FhHMAeU3egqEfFKR_h1HneReg0sD_+hCmsF3WDzQw@mail.gmail.com>
	<20120322213114.61fd4e44@notabene.brown>
	<CAGRgLy7N7m4zFY-EKe8ApUGSR3ZCUpOTZcRvLVLd5WAN2f+k9g@mail.gmail.com>
	<CAGRgLy7BaVTjacaqMVD1JNYgtTn6MAk9bN-GzDC8B0CypJWJmw@mail.gmail.com>
	<CAGRgLy5tauPMAoy=3QkErvtQPjz3FrNYTxQ-2rxTP6nO5tRXXQ@mail.gmail.com>
	<20140610101122.53d16123@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140610101122.53d16123@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks, Neil.
What we do now:
- we refuse freezing/re-adding drives if array is not idle or
recovering (e.g., resyncing)
- otherwise, we freeze, add/re-add drives, unfreeze

Thanks!
Alex.



On Tue, Jun 10, 2014 at 3:11 AM, NeilBrown <neilb@suse.de> wrote:
> On Mon, 9 Jun 2014 17:26:38 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
> wrote:
>
>> > Why do you refuse to freeze the array if it's not "idle"? What will
>> > happen is that current recover/resync will abort, drives will be
>> > added, and on unfreezing, array will resume (restart?) recovery with
>> > all drives. If array was resyncing, however, it will start recovering
>> > the newly added drives, because kernel prefers recovery over resync
>> > (as we discussed earlier).
>> Indeed, since dea3786ae2cf74ecb0087d1bea1aa04e9091ad5c, I see that you
>> agree to freeze the array also in case it is recovering.
>
> I guess I did..... though I don't remember seeing the email that you have
> quoted.  I can see it in my inbox, but it seems that I never replied.  Maybe
> I was too busy that day :-(
>
> If there other outstanding issues, feel free to resend.
> (If I don't reply it is more likely to be careless than deliberate, so in
> general you should feel free to resend if I don't respond in a week or so).
>
> NeilBrown
