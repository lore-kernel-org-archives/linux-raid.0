From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] Remove: container should wait for an array to release a drive
Date: Tue, 19 Jul 2016 10:27:39 -0400
Message-ID: <wrfjk2ghwvms.fsf@redhat.com>
References: <1468843890-30425-1-git-send-email-tomasz.majchrzak@intel.com>
	<22412.56226.478064.375583@quad.stoffel.home>
	<wrfjzipey8cg.fsf@redhat.com>
	<20160719072338.GA17053@proton.igk.intel.com>
	<22414.10215.472325.518194@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22414.10215.472325.518194@quad.stoffel.home> (John Stoffel's
	message of "Tue, 19 Jul 2016 09:15:19 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Tomasz Majchrzak <tomasz.majchrzak@intel.com>, linux-raid@vger.kernel.org, aleksey.obitotskiy@intel.com, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

"John Stoffel" <john@stoffel.org> writes:
>>>>>> "Tomasz" == Tomasz Majchrzak <tomasz.majchrzak@intel.com> writes:
>
> Tomasz> On Mon, Jul 18, 2016 at 04:55:27PM -0400, Jes Sorensen wrote:
>>> "John Stoffel" <john@stoffel.org> writes:
>>> > Really, you're sleeping 10 seconds without telling the user?  That
>>> > seems to be a bit obnoxious.  Logging something here would be good.
>>> 
>>> Hi,
>>> 
>>> Sorry just back from vacation and just started attacking the mountain of
>>> email.
>>> 
>>> I agree with John here, please add some logging message. Also is 10
>>> seconds really needed? It seems an awful lot per iteration.
>>> 
>>> Cheers,
>>> Jes
>
> Tomasz> Well, actually it's 20 iteration 100ms each so up to 2
> Tomasz> seconds. I have never seen it taking more than 3 iterations,
> Tomasz> however I don't have a full knowledge how long it can take md
> Tomasz> module to release an array. I just added 2 seconds as a
> Tomasz> precaution, better wait a bit longer than leave an array in
> Tomasz> inconsistent state.  Is it fine?
>
> Then maybe instead of the magic number 100000, you put in a define
> which says the expected sleep time, or maybe even just a commment?  I
> can never keep the usleep number units straight in my head anyway.
> :-/

Heh, made the same mistake here - I blame the jetlag and the crazy
weather here in NYC :)

If you can add a comment explaining it, that will satisfy my concerns.

Thanks,
Jes
