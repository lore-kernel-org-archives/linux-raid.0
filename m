From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Does md work in 2.6 yet?
Date: Fri, 12 Sep 2003 14:29:36 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16225.19376.203201.546765@notabene.cse.unsw.edu.au>
References: <20030909150818.23616.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from linux@horizon.com on  September 9
To: linux@horizon.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On  September 9, linux@horizon.com wrote:
> A while ago (2.5.46 or so), I tried using the 2.6 kernel and
> discovered that if you have large stripe sizes, it will send
> a single bio for more than 256 sectors to the IDE driver,
> which complains and doesn't do the I/O.
> 
> File system corruption follows shortly thereafter.  Ouch.
> 
> The obvious fix was just to propagate the minimum of the underlying
> devices' maximum bio size to the md driver, but the general solution had
> to cope with hot adds, which might include a new device with a smaller
> bio size limit, and was difficult.
> 
> Has anyone managed a fix yet?  I've been a bit scared to try, although
> read-only should be safe enough.

Yes, I think this is fixed now.

Success reports are always welcome.

NeilBrown
