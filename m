From: Phil Turmel <philip@turmel.org>
Subject: Re: assistance recovering failed raid6 array
Date: Mon, 20 Feb 2017 16:30:45 -0500
Message-ID: <fd323bc5-78d9-9f51-f7b1-01f9e90215fa@turmel.org>
References: <58AA4B1E.1030809@bosner.de>
 <e01061cb-ea4c-4f64-16e8-e6027adbc70d@turmel.org>
 <E18A7C79-09E0-4361-9F89-68AE1E6FCBF6@bosner.de>
 <5cc1566c-1b4c-c663-56a1-2040b93b46d7@turmel.org>
 <231629B1-0888-4B3D-BD81-F641937AC045@bosner.de>
 <676bd1fa-4b97-2c6a-05b8-bd23290fb9a6@turmel.org>
 <54F6D166-0D54-49EF-B967-124DC582B299@bosner.de>
 <fcf34399-2f7a-f444-bff7-512ae29d2e7b@turmel.org>
 <30DDAE62-6D76-4999-A69A-A6C16D082DA9@bosner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <30DDAE62-6D76-4999-A69A-A6C16D082DA9@bosner.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Bosner <martin@bosner.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/20/2017 02:31 PM, Martin Bosner wrote:

> Is there a way tell mdadm to use sdk1 as a “active” device? And how
> can i tell the array that it should not try to recover sdm1 but set
> it active ? Is there any magic to force the state ? It might not be
> healthy for the normal use case but might be helpful for me.

No. There's no way to do that.  Short of reading the kernel code to do
hex editing on the superblock.  And since the spare status is there due
to an --add action, you can't trust that anything else there would be
safe for --create --assume-clean. You would scramble these eggs even
further.

Phil

