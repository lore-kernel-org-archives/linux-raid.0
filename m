From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/2 v3] wait: add wait_event_lock_irq() interface
Date: Fri, 30 Nov 2012 12:36:35 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1211301233320.8688@dhcp-1-104.brq.redhat.com>
References: <1354272161-9173-1-git-send-email-lczerner@redhat.com> <20121130024842.5326d998.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121130024842.5326d998.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lukas Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, axboe@kernel.dk, jmoyer@redhat.com, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Fri, 30 Nov 2012, Andrew Morton wrote:

> Date: Fri, 30 Nov 2012 02:48:42 -0800
> From: Andrew Morton <akpm@linux-foundation.org>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, axboe@kernel.dk,
>     jmoyer@redhat.com, Neil Brown <neilb@suse.de>,
>     David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
>     Peter Zijlstra <a.p.zijlstra@chello.nl>
> Subject: Re: [PATCH 1/2 v3] wait: add wait_event_lock_irq() interface
> 
> On Fri, 30 Nov 2012 11:42:40 +0100 Lukas Czerner <lczerner@redhat.com> wrote:
> 
> > New wait_event{_interruptible}_lock_irq{_cmd} macros added. This commit
> > moves the private wait_event_lock_irq() macro from MD to regular wait
> > includes, introduces new macro wait_event_lock_irq_cmd() instead of using
> > the old method with omitting cmd parameter which is ugly and makes a use
> > of new macros in the MD. It also introduces the _interruptible_ variant.
> > 
> > The use of new interface is when one have a special lock to protect data
> > structures used in the condition, or one also needs to invoke "cmd"
> > before putting it to sleep.
> > 
> > All new macros are expected to be called with the lock taken. The lock
> > is released before sleep and is reacquired afterwards. We will leave the
> > macro with the lock held.
> > 
> > Note to DM: IMO this should also fix theoretical race on waitqueue while
> > using simultaneously wait_event_lock_irq() and wait_event() because of
> > lack of locking around current state setting and wait queue removal.
> 
> Does this fix the sparse warning which Fengguang just sent us?

Which report from Fengguang do you have in mind ? I do not see any
on linux-kernel today.

/me going to see what spare reports

-Lukas
