From: Stefan Smietanowski <stesmi@stesmi.com>
Subject: Re: "Enhanced" MD code avaible for review
Date: Thu, 18 Mar 2004 07:38:18 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <405943DA.9030202@stesmi.com>
References: <459805408.1079547261@aslan.scsiguy.com> <4058A481.3020505@pobox.com> <4058C089.9060603@adaptec.com> <200403172245.31842.bzolnier@elka.pw.edu.pl> <4058EBEC.8070309@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4058EBEC.8070309@adaptec.com>
To: Scott Long <scott_long@adaptec.com>
Cc: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>, Jeff Garzik <jgarzik@pobox.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-raid@vger.kernel.org, "Gibbs, Justin" <justin_gibbs@adaptec.com>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Hi.

<snip beginning of discsussion about DDF, etc>

> With DM, what happens when your initrd gets accidentally corrupted?
> What happens when the kernel and userland pieces get out of sync?
> Maybe you are booting off of a single drive and only using DM arrays
> for secondary storage, but maybe you're not.  If something goes wrong
> with DM, how do you boot?

Tell me something... Do you guys release a driver for WinXP as an
example? You don't have to answer that really as it's obvious that
you do. Do you in the installation program recompile the windows
kernel so that your driver is monolithic? The answer is most presumably
no - that's not how it's done there.

Ok. Your example states "what if initrd gets corrupted" and my example
is "what if you driver file(s) get corrupted?" and my example
is equally important to a module in linux as it is a driver in windows.

Now, since you do supply a windows driver and that driver is NOT
statically linked to the windows kernel why is it that you believe
a meta driver (which MD really is in a sense) needs special treatment
(static linking into the kernel) when for instance a driver for a piece
of hardware doesn't? If you have disk corruption so far that your
initrd is corrupted I would seriously suggest NOT booting that OS
that's on that drive regardless of anything else and sticking it
in another box OR booting from rescue media of some sort.

// Stefan
