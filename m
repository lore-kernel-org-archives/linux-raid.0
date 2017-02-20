From: Phil Turmel <philip@turmel.org>
Subject: Re: assistance recovering failed raid6 array
Date: Mon, 20 Feb 2017 14:16:26 -0500
Message-ID: <fcf34399-2f7a-f444-bff7-512ae29d2e7b@turmel.org>
References: <58AA4B1E.1030809@bosner.de>
 <e01061cb-ea4c-4f64-16e8-e6027adbc70d@turmel.org>
 <E18A7C79-09E0-4361-9F89-68AE1E6FCBF6@bosner.de>
 <5cc1566c-1b4c-c663-56a1-2040b93b46d7@turmel.org>
 <231629B1-0888-4B3D-BD81-F641937AC045@bosner.de>
 <676bd1fa-4b97-2c6a-05b8-bd23290fb9a6@turmel.org>
 <54F6D166-0D54-49EF-B967-124DC582B299@bosner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54F6D166-0D54-49EF-B967-124DC582B299@bosner.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Bosner <martin@bosner.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/20/2017 01:27 PM, Martin Bosner wrote:
>> If you have any access to the two "dead" drives, there might be a 
>> slight chance. Since they were likely kicked out due to timeout 
>> mismatch, not a complete failure, this could be possible.
>> 
>> Otherwise, you are utterly screwed.  Sorry.
> 
> The disks are dead. I already tried different boards but that did
> not help.

Oh, well.

> What would happen if i recreate the array with —assume-clean ? Would 
> i be able to start the array? Can I mark disks as clean? I actually 
> have one failed disks, one nearly recovered disk and one that has 
> been copied by 2/3 ...

For every stripe in the array, you need 34 devices of 36 to be
readable.  Any time you fall back on ddrescue to make one of those
34, you are ensuring that some data is lost.  But yes, that would
otherwise work.  The 2/3 recovered disk is only useful in this (use
ddrescue to get as much of the missing disk as possible).

If you can get to 35 of 36 original disks, even with scattered errors,
you could complete a check scrub to make 35 good disks.  With timeout
mismatch, you'll have to override the kernel timeouts for all devices,
so such a scrub would take a very long time, but would recover everything.

> Martin

Phil
