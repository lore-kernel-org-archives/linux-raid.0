From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Linux MD RAID 1 read performance tunning
Date: Thu, 24 Dec 2009 13:41:56 +0100
Message-ID: <87zl585ysr.fsf@frosties.localdomain>
References: <8e04b5820912220834m595f1aa6sf0071f99b4a5a144@mail.gmail.com>
	<20091222165225.GA2684@rap.rap.dk>
	<8e04b5820912220908s233c3bf9yf0fa9ba8deda693b@mail.gmail.com>
	<20091222182248.GA5719@rap.rap.dk>
	<87d424rbex.fsf@frosties.localdomain>
	<8e04b5820912240116k6c93333byfcd0dc6b82fedec0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8e04b5820912240116k6c93333byfcd0dc6b82fedec0@mail.gmail.com>
	(Ciprian Dorin's message of "Thu, 24 Dec 2009 11:16:25 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: "Ciprian Dorin, Craciun" <ciprian.craciun@gmail.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Keld Jorn Simonsen <keld@keldix.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Ciprian Dorin, Craciun" <ciprian.craciun@gmail.com> writes:

>     Thanks all for your feedback. (I haven't tried the proposed three
> dd's in parallel, but I promise I'll try them the next time I assemble
> my backup array.)
>
>     But one observation though:
>     * indeed my usage of the array was mono-process;
>     * when reading from the array to construct the MD5 sums for the
> files I've used only one process;
>     * indeed the data was read from a single disk (at a time);
>     * but now the interesting think comes: I think it favored one disk
> (the same most of the time) over the others;
>
>     Is this as expected?
>
>     Thanks again,
>     Ciprian.

I don't think it should favour any one disk in particular. But it
might be that if all disks are at the same place (e.g. you just wrote
something) it will always pick the first one. You have to check the
source for that or maybe Neil knows from memory.

But you can tune this:

       -W, --write-mostly
              subsequent devices listed in a --build, --create, or
              --add com- mand will be flagged as 'write-mostly'.  This
              is valid for RAID1 only and means that the 'md' driver
              will avoid reading from these devices if at all
              possible.  This can be useful if mirror- ing over a slow
              link.

       --write-behind=
              Specify that write-behind mode should be enabled (valid
              for RAID1 only).  If an argument is specified, it will
              set the maxi- mum number of outstanding writes allowed.
              The default value is 256.  A write-intent bitmap is
              required in order to use write- behind mode, and
              write-behind is only attempted on drives marked as
              write-mostly.

Since you mentioned that you have different speeds on the disks maybe
you should set this for the slow drive(s).

MfG
        Goswin
