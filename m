From: Martin Bosner <martin@bosner.de>
Subject: Re: assistance recovering failed raid6 array
Date: Mon, 20 Feb 2017 20:31:45 +0100
Message-ID: <30DDAE62-6D76-4999-A69A-A6C16D082DA9@bosner.de>
References: <58AA4B1E.1030809@bosner.de>
 <e01061cb-ea4c-4f64-16e8-e6027adbc70d@turmel.org>
 <E18A7C79-09E0-4361-9F89-68AE1E6FCBF6@bosner.de>
 <5cc1566c-1b4c-c663-56a1-2040b93b46d7@turmel.org>
 <231629B1-0888-4B3D-BD81-F641937AC045@bosner.de>
 <676bd1fa-4b97-2c6a-05b8-bd23290fb9a6@turmel.org>
 <54F6D166-0D54-49EF-B967-124DC582B299@bosner.de>
 <fcf34399-2f7a-f444-bff7-512ae29d2e7b@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fcf34399-2f7a-f444-bff7-512ae29d2e7b@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> On 20 Feb 2017, at 20:16, Phil Turmel <philip@turmel.org> wrote:
> 
> If you can get to 35 of 36 original disks, even with scattered errors,
> you could complete a check scrub to make 35 good disks.  With timeout
> mismatch, you'll have to override the kernel timeouts for all devices,
> so such a scrub would take a very long time, but would recover everything.

Is there a way tell mdadm to use sdk1 as a “active” device? And how can i tell the array that it should not try to recover sdm1 but set it active ? Is there any magic to force the state ? It might not be healthy for the normal use case but might be helpful for me.

Martin