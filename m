From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH 1/2] md/raid1: Refactor raid1_make_request
Date: Thu, 1 Dec 2016 17:00:56 -0500
Message-ID: <22592.40344.186084.537205@quad.stoffel.home>
References: <20161130212020.15762-1-robert@leblancnet.us>
        <20161130212020.15762-2-robert@leblancnet.us>
        <22592.18979.608624.661894@quad.stoffel.home>
        <CAANLjFq2eezGRded8uDk6U0si_gt9j250qR4VQW+WFUeYJ70OA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAANLjFq2eezGRded8uDk6U0si_gt9j250qR4VQW+WFUeYJ70OA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert LeBlanc <robert@leblancnet.us>
Cc: John Stoffel <john@stoffel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Robert" == Robert LeBlanc <robert@leblancnet.us> writes:

Robert> On Thu, Dec 1, 2016 at 9:04 AM, John Stoffel <john@stoffel.org> wrote:
>> Maybe this is pedantic, but why not have an 'else' instead of the
>> return to make it more clear?  If someone (like me :-) missed the
>> return on the quick read through, it's going to be some confusion.
>> 
>> if (bio_data_dir(bio) == READ)
>> raid1_read_request(mddev, bui, r1_bio);
>> else
>> raid1_write_request(mddev, bio, r1_bio, start_next_window);
>> 
>> seems cleaner.

Robert> Yeah, I agree that is a bit cleaner, I was just following the
Robert> previous style. I'll change it to what you propose.

It's not a big deal, whatever makes you happy.  

>> Also, why are the calls different with the start_next_window parameter
>> added in?  Sorry for being dense, trying to understand the code
>> better...

Robert> start_next_windows is set by wait_barrier() and is only
Robert> non-zero for writes and the return value of zero is never used
Robert> for reads. I tried to move that code into the write branch,
Robert> but I could not unload the module due to conf->nr_pending ==
Robert> conf->queued+extra failing in wait_event_lock_irq_cmd() in
Robert> freeze_array(). Each read was decrementing conf->nr_pending
Robert> and since wait_barrier() was not being called on reads,
Robert> conf->nr_pending was very negative and would not return to
Robert> zero. In order to refactor that out completely would require a
Robert> lot more work and changes. I'd need to do more research into
Robert> how much the spin_locks are needed for reading when there is
Robert> recovery going on before I could start to try and refactor
Robert> that. The other option is to break wait_barrier() into two
Robert> functions, one that gets called for both read and write and
Robert> the other for just the writes. I can do the latter pretty
Robert> easily if that is a desired direction.

That second option might be the way to move forward.  But it sounds
like a bigger refactoring than is really needed now.

John
