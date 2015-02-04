From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Off-Topic Write cache disabling?
Date: Tue, 3 Feb 2015 18:38:57 -0600
Message-ID: <CAAMCDef=cHzrAonynERM0oWYvXfzK=iGzG7vL-m3p2hkpN3uNw@mail.gmail.com>
References: <CAFE24U1G9+bqTzK4eD-cenyc5CGQQdrcu7S9Ks4CsHPS9wJ4zA@mail.gmail.com>
 <CAAMCDedvF+Nv9LYqM7Ddgg2xMQKtgQDntOsG0krxWCV4H+zQmA@mail.gmail.com> <CAB-428kgGgMTiyUgq=0geAMsLGju2QeJvL=GfcChX0W5cBfPBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB-428kgGgMTiyUgq=0geAMsLGju2QeJvL=GfcChX0W5cBfPBg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alireza Haghdoost <alireza@cs.umn.edu>
Cc: Weedy <weedy2887@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

When dirty_cache hits 50mb it writes enough out to get the dirty_cache
down to 25MB (since 25000000 is the lower setting)

On Tue, Feb 3, 2015 at 1:16 PM, Alireza Haghdoost <alireza@cs.umn.edu> wrote:
>> and it syncs down to 25mb when it syncs.
>
> What do you mean by "syncs down to 25mb" ?
