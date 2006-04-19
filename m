From: Shai <shaibn@gmail.com>
Subject: Re: replace disk in raid5 without linux noticing?
Date: Wed, 19 Apr 2006 18:31:48 +0200
Message-ID: <e3edb0fa0604190931i1160d94eo829ba17943b0c5eb@mail.gmail.com>
References: <200604191631.04305.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200604191631.04305.Dexter.Filmore@gmx.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/19/06, Dexter Filmore <Dexter.Filmore@gmx.de> wrote:
> Let's say a disk in an array starts yielding smart errors but is still
> functional.
> So instead of waiting for it to fail completely and start a sync and stress
> the other disks, could I clone that disk to a fresh one, put the array
> offline and replace the disk?

Hi,

Why can't you just mark that drive as failed, remove it and hotadd a
new drive to replace the failed drive?

Shai
