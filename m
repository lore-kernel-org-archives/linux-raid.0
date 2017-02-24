From: Phil Turmel <philip@turmel.org>
Subject: Re: [BUG] non-metadata arrays cannot use more than 27 component
 devices
Date: Fri, 24 Feb 2017 15:46:19 -0500
Message-ID: <1e40da0d-b175-9ff5-d2e5-cf1f25aacc26@turmel.org>
References: <20170224040816.41f2f372.ian_bruce@mail.ru>
 <41ea334c-ae1c-dac6-e1a1-480d3700a588@turmel.org>
 <20170224084024.4dfe83a2.ian_bruce@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170224084024.4dfe83a2.ian_bruce@mail.ru>
Sender: linux-raid-owner@vger.kernel.org
To: ian_bruce@mail.ru, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/24/2017 11:40 AM, ian_bruce@mail.ru wrote:
> On Fri, 24 Feb 2017 10:20:52 -0500 Phil Turmel <philip@turmel.org> 
> wrote:
> 
>> Considering the existence of --build is strictly to support arrays 
>> that predate MD raid, it seems a bit of a stretch to claim this as
>> a bug instead of a feature request.
> 
> quoting from the mdadm manual page:

Quote all you like, it doesn't change the history. Note that build mode
doesn't support a bunch of other MD raid features either, like all of
the parity raid levels.  That it doesn't support v1+ metadata isn't a
surprise, and isn't the only legacy feature that only uses legacy
metadata (built-in kernel auto-assembly gets the most whining, actually).

Anyways, though I can't speak for the maintainers, it seems that build
mode is there to keep the MD maintainers from being yelled at by Linus
for breaking legacy setups.  Nothing more.

If you think its trivial to implement --build with v1.x metadata, go
right ahead.  Post your patches for review.

Phil
