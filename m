From: "Dale Dunlea" <ddunlea@gmail.com>
Subject: Re: RAID5 lockup with AMCC440 and async-tx
Date: Mon, 1 Oct 2007 12:02:54 +0100
Message-ID: <8a24fb800710010402u5aa0187bq4f850b8cb71483c9@mail.gmail.com>
References: <8a24fb800710010216m21cd7734p4c19df1aa7dd5564@mail.gmail.com>
	 <20071001103216.433742408A@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071001103216.433742408A@gemini.denx.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/10/2007, Wolfgang Denk <wd@denx.de> wrote:
> Dear Dale,
>
> in message <8a24fb800710010216m21cd7734p4c19df1aa7dd5564@mail.gmail.com> you wrote:
> >
> > I have a board with an AMCC440 processor, running RAID5 using the
> > async-tx interface. In general, it works well, but I have found a test
> > case that consistently causes a hard lockup of the entire system.
>
> Please make sure to use latest code - we found a bug recently.

Latest code from Dan or latest code from denx.de? I grabbed the latest
code from Dan, but I'm having trouble cloning denx.de:

"remote: error: object directory /home/git/linux-2.6/.git/objects does
not exist; check .git/objects/info/alternates."
>
> > What makes this case odd is that I have only been able to generate it
> > when accessing disks that are on two separate HBAs - in my case
> > mpt-fusion based SAS HBAs. Once two HBAs are in use, the bug is
> > trivial to repeat. I simply create a RAID5 using disks from each HBA,
> > wait for it to resync, and then run
>
> We saw similar problems, in our case they showed up only with a large
> number of disks in combination with big kernel pages sizes (64 kB).
>
The problem occurs for me with both 4k and 64k pages.

Regards,
Dale
