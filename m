From: "Rob Bray" <raid@bymeinc.com>
Subject: Re: avoiding the initial resync on --create
Date: Mon, 9 Oct 2006 15:10:56 -0400 (EDT)
Message-ID: <37950.192.168.0.1.1160421056.squirrel@bymeinc.com>
References: <20061009125700.GA10191@piper.madduck.net>
    <20061009134946.GA26122@harddisk-recovery.com>
    <1160411520.2917.76.camel@fc6.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1160411520.2917.76.camel@fc6.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> On Mon, 2006-10-09 at 15:49 +0200, Erik Mouw wrote:
>
>> There is no way to figure out what exactly is correct data and what is
>> not. It might work right after creation and during the initial install,
>> but after the next reboot there is no way to figure out what blocks to
>> believe.
>
> You don't really need to.  After a clean install, the operating system
> has no business reading any block it didn't write to during the install
> unless you are just reading disk blocks for the fun of it.  And any
> program that depends on data that hasn't first been written to disk is
> just wrong and stupid anyway.

I suppose a partial-stripe write would read back junk data on the other
disks, xor with your write, and update the parity block.

If you benchmark the disk, you're going to be reading blocks you didn't
necessarily write, which could kick out consistency errors.

A whole-array consistency check would puke on the out-of-whack parity data.

