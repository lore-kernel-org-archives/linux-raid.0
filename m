From: Phil Turmel <philip@turmel.org>
Subject: Re: assistance recovering failed raid6 array
Date: Mon, 20 Feb 2017 16:21:34 -0500
Message-ID: <6286c879-2c58-ee43-86fb-22e83c1964c4@turmel.org>
References: <58AA4B1E.1030809@bosner.de>
 <e01061cb-ea4c-4f64-16e8-e6027adbc70d@turmel.org>
 <E18A7C79-09E0-4361-9F89-68AE1E6FCBF6@bosner.de>
 <5cc1566c-1b4c-c663-56a1-2040b93b46d7@turmel.org>
 <231629B1-0888-4B3D-BD81-F641937AC045@bosner.de>
 <676bd1fa-4b97-2c6a-05b8-bd23290fb9a6@turmel.org>
 <54F6D166-0D54-49EF-B967-124DC582B299@bosner.de>
 <fcf34399-2f7a-f444-bff7-512ae29d2e7b@turmel.org>
 <58AB5555.5070504@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58AB5555.5070504@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Martin Bosner <martin@bosner.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/20/2017 03:45 PM, Wols Lists wrote:

> But there's a request on the linux wiki program for someone to write a
> utility program that takes a ddrescue log and flags the duff sectors as
> "soft unreadable". That would mean that if you can recover 35 drives,
> provided no stripe has lost two sectors across two drives, you wouldn't
> lose any data.
> 
> If you want to try and write that utility? Or if you want to email me a
> ddrescue log with a bunch of failed sectors, I'll have a go at writing
> it myself :-)

Check out hdparm --make-bad-sector.  You can get what you are describing
by scripting that.  It's marked very dangerous, but I guess if one has
nothing to lose....

Phil

