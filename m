From: Phil Turmel <philip@turmel.org>
Subject: Re: mdadm --create parameter ordering
Date: Mon, 13 Jul 2015 09:17:52 -0400
Message-ID: <55A3BA80.50505@turmel.org>
References: <CAFcup8E3iKxb8H-Fz76bKJQhjmhq1FuVu11rEPb-k=g2U_nX=w@mail.gmail.com>
 <20150713105928.GA19366@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150713105928.GA19366@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Reddie <steven.reddie@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/13/2015 06:59 AM, Robin Hill wrote:

[snip /]

Let me elaborate on one of Robin's comments:

> The --assume-clean option will prevent parity calculation (as it assumes
> that the parity on disk is already correct), which may be what you're
> after. It should only be used it you're absolutely certain of the data
> though, as it can lead to large-scale corruption otherwise.

It is not enough to be certain of the order to use --create
--assume-clean on existing data.  You must also be certain of superblock
type, chunk size, data offset, and layout option.

Data loss due to unwise use of --create has a history of bad outcomes.
It destroys the previous metadata on array members, metadata that is
almost always needed to recover damaged arrays.  The --create option
should *never* be used on an array with important data without first
asking for advice on this list.

Phil
