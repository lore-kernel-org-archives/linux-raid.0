From: Wolfgang Denk <wd@denx.de>
Subject: Re: RAID5 lockup with AMCC440 and async-tx
Date: Mon, 01 Oct 2007 12:32:16 +0200
Message-ID: <20071001103216.433742408A@gemini.denx.de>
References: <8a24fb800710010216m21cd7734p4c19df1aa7dd5564@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: Your message of "Mon, 01 Oct 2007 10:16:00 BST."
             <8a24fb800710010216m21cd7734p4c19df1aa7dd5564@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dale Dunlea <ddunlea@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Dale,

in message <8a24fb800710010216m21cd7734p4c19df1aa7dd5564@mail.gmail.com> you wrote:
> 
> I have a board with an AMCC440 processor, running RAID5 using the
> async-tx interface. In general, it works well, but I have found a test
> case that consistently causes a hard lockup of the entire system.

Please make sure to use latest code - we found a bug recently.

> What makes this case odd is that I have only been able to generate it
> when accessing disks that are on two separate HBAs - in my case
> mpt-fusion based SAS HBAs. Once two HBAs are in use, the bug is
> trivial to repeat. I simply create a RAID5 using disks from each HBA,
> wait for it to resync, and then run

We saw similar problems, in our case they showed up only with a large
number of disks in combination with big kernel pages sizes (64 kB).

> Any pointers on how to debug this? It feels like a race condition of
> some description, but any serial port printing I enable causes the
> problem to go away, and I can't print silently to /var/log/messages as
> the system hangs before it can flush.

See above - please try current code.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
HR Manager to job candidate "I see you've had no  computer  training.
Although  that  qualifies  you  for upper management, it means you're
under-qualified for our entry level positions."
