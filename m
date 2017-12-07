From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: When will Linux support new RAID controllers
Date: Thu, 7 Dec 2017 14:16:12 +0000
Message-ID: <20171207141612.2653a0fb@alans-desktop>
References: <CAGRSmLs-Hr+FFfa4_29kidEeL2d7b+cEP6u1OkOUoYW6Cm15BA@mail.gmail.com>
        <20171110131937.GA26181@infradead.org>
        <CAKKYfmEqw48mjBsKoy=qeny6B1X8PKytSN4UwpvSupo87746kg@mail.gmail.com>
        <CAGRSmLsvAR6wth7tPd5J2kAydy64uQ+h45Yu-SUeOAHkfOHXHA@mail.gmail.com>
        <CAGRSmLto7dG19zgUkdZjuhacWXo=ju6WdS0YVjC5xOOsGjV9kg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAGRSmLto7dG19zgUkdZjuhacWXo=ju6WdS0YVjC5xOOsGjV9kg@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: "David F." <df7729@gmail.com>
Cc: Dennis Mungai <dmngaie@gmail.com>, Christoph Hellwig <hch@infradead.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, linux-ide@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-nvme@lists.infradead.org
List-Id: linux-raid.ids

On Mon, 4 Dec 2017 18:01:10 -0800
"David F." <df7729@gmail.com> wrote:

> Hi,
> 
> Any word if the patch is available?
> 
> Is this going mainline anytime soon?

I am not aware of anyone in Intel working on it or planning to work on it
at this point. Nothing stops someone outside of Intel doing that from the
code that was released.

For things that need BIOS changes whatever the vendor my experience has
always been that you make the most impact by talking to the actual system
vendor (who controls the BIOS), including telling them why you didn't buy
their machine. At the end of the day businesses make decisions based on
dollars.

Alan
