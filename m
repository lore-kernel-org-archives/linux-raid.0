From: Martin Bosner <martin@bosner.de>
Subject: Re: assistance recovering failed raid6 array
Date: Mon, 20 Feb 2017 19:27:01 +0100
Message-ID: <54F6D166-0D54-49EF-B967-124DC582B299@bosner.de>
References: <58AA4B1E.1030809@bosner.de>
 <e01061cb-ea4c-4f64-16e8-e6027adbc70d@turmel.org>
 <E18A7C79-09E0-4361-9F89-68AE1E6FCBF6@bosner.de>
 <5cc1566c-1b4c-c663-56a1-2040b93b46d7@turmel.org>
 <231629B1-0888-4B3D-BD81-F641937AC045@bosner.de>
 <676bd1fa-4b97-2c6a-05b8-bd23290fb9a6@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <676bd1fa-4b97-2c6a-05b8-bd23290fb9a6@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> On 20 Feb 2017, at 19:11, Phil Turmel <philip@turmel.org> wrote:
> 
> Of the 36 original disks, you have 34.  You have one incomplete
> rebuild, meaning it is still technically a spare. One of the still
> active 34 is also showing pending relocations, meaning that disk will
> not be able to supply all sectors to complete any recovery.
> { /dev/sdah, serial # S1F0FPYR }
> 
> If you have any access to the two "dead" drives, there might be
> a slight chance. Since they were likely kicked out due to timeout
> mismatch, not a complete failure, this could be possible.
> 
> Otherwise, you are utterly screwed.  Sorry.

The disks are dead. I already tried different boards but that did not help.

What would happen if i recreate the array with —assume-clean ? Would i be able to start the array? Can I mark disks as clean? I actually have one failed disks, one nearly recovered disk and one that has been copied by 2/3 ...

Martin 

