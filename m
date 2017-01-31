From: Phil Turmel <philip@turmel.org>
Subject: Re: drives failed during reshape, array won't even force-assemble
Date: Mon, 30 Jan 2017 19:29:23 -0500
Message-ID: <fb9787fd-4047-cc53-a926-f9715d7faee6@turmel.org>
References: <d08f3721-6a72-3fc3-58d6-29034a6962f1@warntjen.net>
 <73c909f6-5bf3-06c5-368f-2a641a3445b7@turmel.org>
 <d49d7786-1174-0e96-e857-f2b2b6144c1b@warntjen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d49d7786-1174-0e96-e857-f2b2b6144c1b@warntjen.net>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Warntjen <thomas@warntjen.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/30/2017 02:57 PM, Thomas Warntjen wrote:
> Hi Phil,
> 
> thanks for your reply - sadly it's the first I got so no, I haven't
> solved it yet. Any help is still highly appreciated!

Ok.

I'm a bit surprised forced assembly didn't work.  Please provide fresh
mdadm --examine output for all member devices (untrimmed), plus the
output from "ls -l /dev/disk/by-id/ata-*".

That'll help.  Please paste inline and turn off line wrap, so it all
comes through neatly.

Phil

