From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [PATCH md 0 of 4] Introduction
Date: Tue, 08 Mar 2005 12:02:17 -0500
Message-ID: <422DDA99.60608@steeleye.com>
References: <20050308165021.3745.patches@notabene> <6jj0g2-c27.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
In-Reply-To: <6jj0g2-c27.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer wrote:

> Neil - can you describe for me (us all?) what is meant by
> intent=ADlogging here.

Since I wrote a lot of the code, I guess I'll try...

> Well, I can guess - I suppose the driver marks the bitmap before a wr=
ite
> (or group of writes) and unmarks it when they have completed
> successfully.  Is that it?

Yes. It marks the bitmap before writing (actually queues up the bitmap=20
and normal writes in bunches for the sake of performance). The code is=20
actually (loosely) based on your original bitmap (fr1) code.

> If so, how does it manage to mark what it is _going_ to do (without
> psychic powers) on the disk bitmap? =20

That's actually fairly easy. The pages for the bitmap are locked in=20
memory, so you just dirty the bits you want (which doesn't actually=20
incur any I/O) and then when you're about to perform the normal writes,=
=20
you flush the dirty bitmap pages to disk.

Once the writes are complete, a thread (we have the raid1d thread doing=
=20
this) comes back along and flushes the (now clean) bitmap pages back to=
=20
disk. If the pages get dirty again in the meantime (because of more=20
I/O), we just leave them dirty and don't touch the disk.

> Then resync would only deal with the marked blocks.

Right. It clears the bitmap once things are back in sync.

--
Paul

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
