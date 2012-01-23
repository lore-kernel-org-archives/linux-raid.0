From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 1/1] Work around gcc-4.7's strict aliasing checks
Date: Mon, 23 Jan 2012 13:50:45 +0100
Message-ID: <4F1D57A5.7070104@redhat.com>
References: <20120112104320.471910db@notabene.brown> <1327193360-4446-1-git-send-email-soltys@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1327193360-4446-1-git-send-email-soltys@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <soltys@ziu.info>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

On 01/22/12 01:49, Michal Soltys wrote:
> Below is approach to the "problem" from a bit different angle - using
> alias-permitting type definitions consistently where necessary - so assuring
> compiler won't (shouldn't ?) pursue any funny ideas no matter what. I'd guess
> it's the "right" thing to do - aside from going kernel way and using
> -fno-strict-aliasing everywhere (or #pragmas).
> 
> The compilation goes cleanly at Wstrict-aliasing=1 - so most aggresive yet most
> dumb at the same time (note, not checked on 4.7, but obviously I included
> necessary equivalent changes to the Jes's patch).
> 
> Anyway - side effects of Wstrict-aliasing=1 are false positives - quite a few
> of them actually (funcion argument casts where only pointers are involved, some
> pointers which are not dereferenced "nearby" and/or in the same block) - but
> false negatives should be (almost ?) nonexistent.  As mdadm is rather critical,
> and itself compiled with Wall, Wextra and Werror - I assume to be extra careful
> - this should complement those settings well.
> 
> On a bad side of this approach - it doesn't necessary make the code prettier,
> and might make people ask "the hell is this ...".

Hi Michal,

Personally I'd rather have someone who knows about the ddf on disk
format go through the code and fix properly. We're all going through the
code trying to come up with workarounds for gcc (myself included),
rather than fixing the code.

IMHO adding more ugly typedefs is a situation of where the cure is worse
than the disease.

Cheers,
Jes
