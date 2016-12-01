From: Robert LeBlanc <robert@leblancnet.us>
Subject: Re: [PATCH 1/2] md/raid1: Refactor raid1_make_request
Date: Thu, 1 Dec 2016 10:40:19 -0700
Message-ID: <CAANLjFq2eezGRded8uDk6U0si_gt9j250qR4VQW+WFUeYJ70OA@mail.gmail.com>
References: <20161130212020.15762-1-robert@leblancnet.us> <20161130212020.15762-2-robert@leblancnet.us>
 <22592.18979.608624.661894@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22592.18979.608624.661894@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Dec 1, 2016 at 9:04 AM, John Stoffel <john@stoffel.org> wrote:
> Maybe this is pedantic, but why not have an 'else' instead of the
> return to make it more clear?  If someone (like me :-) missed the
> return on the quick read through, it's going to be some confusion.
>
> if (bio_data_dir(bio) == READ)
>    raid1_read_request(mddev, bui, r1_bio);
> else
>    raid1_write_request(mddev, bio, r1_bio, start_next_window);
>
> seems cleaner.

Yeah, I agree that is a bit cleaner, I was just following the previous
style. I'll change it to what you propose.

> Also, why are the calls different with the start_next_window parameter
> added in?  Sorry for being dense, trying to understand the code
> better...

start_next_windows is set by wait_barrier() and is only non-zero for
writes and the return value of zero is never used for reads. I tried
to move that code into the write branch, but I could not unload the
module due to conf->nr_pending == conf->queued+extra failing in
wait_event_lock_irq_cmd() in freeze_array(). Each read was
decrementing conf->nr_pending and since wait_barrier() was not being
called on reads, conf->nr_pending was very negative and would not
return to zero. In order to refactor that out completely would require
a lot more work and changes. I'd need to do more research into how
much the spin_locks are needed for reading when there is recovery
going on before I could start to try and refactor that. The other
option is to break wait_barrier() into two functions, one that gets
called for both read and write and the other for just the writes. I
can do the latter pretty easily if that is a desired direction.

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
