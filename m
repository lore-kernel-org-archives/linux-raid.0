From: Roman Mamedov <rm@romanrm.net>
Subject: Re: stripe_cache_size, some info
Date: Fri, 24 Mar 2017 11:00:47 +0500
Message-ID: <20170324110047.6f89eb62@natsu>
References: <CAJH6TXhL4=MLanyvQh8UMkBmfkfjPd-frsCOC3PqLnDXCpMetw@mail.gmail.com>
        <87wpbf8buk.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87wpbf8buk.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 24 Mar 2017 16:47:47 +1100
NeilBrown <neilb@suse.com> wrote:

> > 1) any upper limit for that value ? Can I set it near 1GB like most
> > hardware controller?
> 
> It is currently limited to 32768, for no particularly good reason.

I feel it should be clarified that's in *PAGES* (4K on x86) per *ARRAY MEMBER*.

So the calculation can get a little bit complex, it's not like you're setting
it to 32 MB with that number.

For a 8-drive array that would be 32768 * 4096 * 8 = 1073741824 bytes (1GB).

-- 
With respect,
Roman
