From: Wolfgang Denk <wd@denx.de>
Subject: Re: RAID5 lockup with AMCC440 and async-tx
Date: Mon, 01 Oct 2007 19:39:01 +0200
Message-ID: <20071001173901.59F712408A@gemini.denx.de>
References: <8a24fb800710010402u5aa0187bq4f850b8cb71483c9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: Your message of "Mon, 01 Oct 2007 12:02:54 BST."
             <8a24fb800710010402u5aa0187bq4f850b8cb71483c9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dale Dunlea <ddunlea@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Dale,

in message <8a24fb800710010402u5aa0187bq4f850b8cb71483c9@mail.gmail.com> you wrote:
>
> Latest code from Dan or latest code from denx.de? I grabbed the latest

From linux-2.6-denx

> code from Dan, but I'm having trouble cloning denx.de:
> 
> "remote: error: object directory /home/git/linux-2.6/.git/objects does
> not exist; check .git/objects/info/alternates."

Argh.. Stupid me.

Please try again - this one is fixed now.

> > We saw similar problems, in our case they showed up only with a large
> > number of disks in combination with big kernel pages sizes (64 kB).
> >
> The problem occurs for me with both 4k and 64k pages.

Probably using more than one controller adds to the likelyhood of
being hit by this race condition.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Immortality consists largely of boredom.
	-- Zefrem Cochrane, "Metamorphosis", stardate 3219.8
