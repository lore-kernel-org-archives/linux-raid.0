From: Mike Snitzer <snitzer@gmail.com>
Subject: Re: Load-balancing mirrors w/ asymmetric performance
Date: Mon, 12 Oct 2009 10:22:24 -0400
Message-ID: <170fa0d20910120722o2347f119g9e3c48b52bc4efef@mail.gmail.com>
References: <f3177b9e0910041240h4dba8771vb5ba07216c9c8189@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f3177b9e0910041240h4dba8771vb5ba07216c9c8189@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: linuxraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Oct 4, 2009 at 3:40 PM, Chris Worley <worleys@gmail.com> wrote:
> When you mirror two devices, they may not have the same performance.
> For example, if one device is local and the other remote.
>
> There's nothing you can do about writes, as everything needs written.
>
> But, reads shouldn't be split 50/50: they should be balanced depending
> relative performance of each mirror to optimize overall read
> performance.

And MD already has the ability to flag the slow paths as write-mostly, see:

mdadm ... --write-mostly

There is also '--write-behind' support for devices that have been
tagged as 'write-mostly'.
