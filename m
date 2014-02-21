From: Larry Fenske <LFenske@SGI.com>
Subject: Re: raid 'check' does not provoke expected i/o error
Date: Fri, 21 Feb 2014 10:49:29 -0700
Message-ID: <530791A9.60808@SGI.com>
References: <5307034E.9080007@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5307034E.9080007@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>, list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The translation between disk and RAID sectors is something I also have
been wanting.  Does anybody have any information about this?

- Larry Fenske

On 02/21/2014 12:42 AM, Eyal Lebedinsky wrote:
> Q2) Do we have a writeup on how to translate the sector (in the i/o
error) to a block
> in the raid device (/dev/mdN)?
