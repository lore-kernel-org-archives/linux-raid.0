From: Phil Turmel <philip@turmel.org>
Subject: Re: Fault tolerance with badblocks
Date: Mon, 8 May 2017 15:02:10 -0400
Message-ID: <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
 <590B3039.3060000@youngman.org.uk>
 <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>
 <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
 <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee>
 <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87h90v8kt3.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>, Wols Lists <antlists@youngman.org.uk>
Cc: "Ravi (Tom) Hale" <ravi@hale.ee>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/08/2017 10:50 AM, Nix wrote:

> I wonder... scrubbing is not very useful with md, particularly with RAID
> 6, because it does no writes unless something mismatches,

This is wrong.  The purpose of scrubbing is to expose any sectors that
have degraded (as Wol describes) to the point of generating a read
error.  A "check" scrub only writes back to the sectors that report a
URE, giving the drive firmware a chance to fix or relocate the sector.

A check scrub will NOT write on mismatch, just increment the mismatch
counter.  This is the recommended regular scrubbing operation.  You want
to know when mismatches occur.

> If there was a way to get md to *rewrite* everything during scrub,
> rather than just checking, this might help (in addition to letting the
> drive refresh the magnetization of absolutely everything).

This is actually counterproductive.  Rewriting everything may refresh
the magnetism on weakening sectors, but will also prevent the drive from
*finding* weakening sectors that really do need relocation.

Phil
