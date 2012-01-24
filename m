From: Michal Soltys <soltys@ziu.info>
Subject: Re: [PATCH 1/1] Work around gcc-4.7's strict aliasing checks
Date: Tue, 24 Jan 2012 01:59:38 +0100
Message-ID: <4F1E027A.40007@ziu.info>
References: <20120112104320.471910db@notabene.brown> <1327193360-4446-1-git-send-email-soltys@ziu.info> <4F1D57A5.7070104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F1D57A5.7070104@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

On 12-01-23 13:50, Jes Sorensen wrote:
> On 01/22/12 01:49, Michal Soltys wrote:
>>  Below is approach to the "problem" from a bit different angle -
>>  using alias-permitting type definitions consistently where necessary
>>  - so assuring compiler won't (shouldn't ?) pursue any funny ideas no
>>  matter what. I'd guess it's the "right" thing to do - aside from
>>  going kernel way and using -fno-strict-aliasing everywhere (or
>>  #pragmas).
>>
>>  The compilation goes cleanly at Wstrict-aliasing=1 - so most
>>  aggresive yet most dumb at the same time (note, not checked on 4.7,
>>  but obviously I included necessary equivalent changes to the Jes's
>>  patch).
>>
>>  Anyway - side effects of Wstrict-aliasing=1 are false positives -
>>  quite a few of them actually (funcion argument casts where only
>>  pointers are involved, some pointers which are not dereferenced
>>  "nearby" and/or in the same block) - but false negatives should be
>>  (almost ?) nonexistent.  As mdadm is rather critical, and itself
>>  compiled with Wall, Wextra and Werror - I assume to be extra careful
>>  - this should complement those settings well.
>>
>>  On a bad side of this approach - it doesn't necessary make the code
>>  prettier, and might make people ask "the hell is this ...".
> 
> Hi Michal,
> 
> Personally I'd rather have someone who knows about the ddf on disk
> format go through the code and fix properly.
> IMHO adding more ugly typedefs is a situation of where the cure is
> worse than the disease.

Btw, the patch went through the whole mdadm, not just ddf part. And
afaik, if we aim to be formally correct - there's no going around
typedefs (which are required for "may_alias" on simple types).
Otherwise, it just tricking gcc into not issuing warnings (even if
the chance of actual problems occuring is absolutely minuscule).

> We're all going through the code trying to come up with workarounds
> for gcc (myself included), rather than fixing the code.

Well, IMHO the [probably] best workaround for now would be
-fno-strict-aliasing then - which avoids warnings, ugly attribute
[over]use, and should assure expected behavior.

Say, near the top of Makefile:

-CFLAGS = $(CWFLAGS) $(CXFLAGS) -DSendmail=\""$(MAILCMD)"\" $(CONFFILEFLAGS) $(DIRFLAGS)
+CFLAGS = $(CWFLAGS) $(CXFLAGS) -fno-strict-aliasing -DSendmail=\""$(MAILCMD)"\" $(CONFFILEFLAGS) $(DIRFLAGS)
