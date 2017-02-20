From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: assistance recovering failed raid6 array
Date: Mon, 20 Feb 2017 20:45:09 +0000
Message-ID: <58AB5555.5070504@youngman.org.uk>
References: <58AA4B1E.1030809@bosner.de>
 <e01061cb-ea4c-4f64-16e8-e6027adbc70d@turmel.org>
 <E18A7C79-09E0-4361-9F89-68AE1E6FCBF6@bosner.de>
 <5cc1566c-1b4c-c663-56a1-2040b93b46d7@turmel.org>
 <231629B1-0888-4B3D-BD81-F641937AC045@bosner.de>
 <676bd1fa-4b97-2c6a-05b8-bd23290fb9a6@turmel.org>
 <54F6D166-0D54-49EF-B967-124DC582B299@bosner.de>
 <fcf34399-2f7a-f444-bff7-512ae29d2e7b@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fcf34399-2f7a-f444-bff7-512ae29d2e7b@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Martin Bosner <martin@bosner.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/02/17 19:16, Phil Turmel wrote:
> For every stripe in the array, you need 34 devices of 36 to be
> readable.  Any time you fall back on ddrescue to make one of those
> 34, you are ensuring that some data is lost.  But yes, that would
> otherwise work.  The 2/3 recovered disk is only useful in this (use
> ddrescue to get as much of the missing disk as possible).

I keep on asking :-)

But there's a request on the linux wiki program for someone to write a
utility program that takes a ddrescue log and flags the duff sectors as
"soft unreadable". That would mean that if you can recover 35 drives,
provided no stripe has lost two sectors across two drives, you wouldn't
lose any data.

If you want to try and write that utility? Or if you want to email me a
ddrescue log with a bunch of failed sectors, I'll have a go at writing
it myself :-)

Cheers,
Wol
