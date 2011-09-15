From: Nigel Cunningham <nigel@tuxonice.net>
Subject: Re: Repeatable md OOPS on suspend,
 2.6.39.4 and 3.0.3
Date: Thu, 15 Sep 2011 14:18:08 +1000
Message-ID: <4E717C80.20305@tuxonice.net>
References: <CALxPEfw-XdcosHemovkxj9aOwaYxUaQ6dj=yMaKCmoy2vkkUkg@mail.gmail.com>	<loom.20110901T032036-733@post.gmane.org>	<CALxPEfwJ99bvmSXkqSKutAYbcD9OLcyMcKQQO6G+Yxi9RQ1DFA@mail.gmail.com>	<CALxPEfyQrwWh1AWY-fwwCeMzDEeK390Eof9PwrsN6C11Wnt9=A@mail.gmail.com>	<loom.20110906T201030-97@post.gmane.org>	<87mxed7u3s.fsf_-_@spindle.srvr.nix>	<4E71397A.9060708@tuxonice.net>
	<20110915053139.09dd6ae1@notabene.brown>
Reply-To: TuxOnIce users' list <tuxonice-users@lists.tuxonice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tuxonice-users-bounces@lists.tuxonice.net>
In-Reply-To: <20110915053139.09dd6ae1@notabene.brown>
List-Unsubscribe: <http://lists.tuxonice.net/options/tuxonice-users>,
	<mailto:tuxonice-users-request@lists.tuxonice.net?subject=unsubscribe>
List-Archive: <http://lists.tuxonice.net/pipermail/tuxonice-users>
List-Post: <mailto:tuxonice-users@lists.tuxonice.net>
List-Help: <mailto:tuxonice-users-request@lists.tuxonice.net?subject=help>
List-Subscribe: <http://lists.tuxonice.net/listinfo/tuxonice-users>,
	<mailto:tuxonice-users-request@lists.tuxonice.net?subject=subscribe>
Sender: tuxonice-users-bounces@lists.tuxonice.net
Errors-To: tuxonice-users-bounces@lists.tuxonice.net
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, TuxOnIce users' list <tuxonice-users@lists.tuxonice.net>
List-Id: linux-raid.ids

Hi.

On 15/09/11 13:31, NeilBrown wrote:
> On Thu, 15 Sep 2011 09:32:10 +1000 Nigel Cunningham <nigel@tuxonice.net>
> wrote:
> 
>> Hi.
>>
>> Please try/review the attached patch.
>>
>> The problem is that TuxOnIce adds a BUG_ON() to catch non-TuxOnIce I/O
>> during hibernation, as a method of seeking to stop on-disk data getting
>> corrupted by the writing of data that has potentially been overwritten
>> by the atomic copy.
>>
>> Stopping the md devices from being marked readonly is the right thing to
>> do - if we don't resume, we want recovery to be run. If we do resume,
>> they should still be in the pre-hibernate state.
>>
>> Regards,
>>
>> Nigel
> 
> This doesn't feel like the right approach to me.
> 
> I think the 'md' device *should* be marked 'clean' when it is clean to
> avoid unnecessary resyncs.

I must be missing something. In raid terminology, what does 'clean'
mean? Googling gives me lots of references to flyspray :) I thought it
meant the filesystems contained therein were cleanly unmounted (which it
isn't in this case). Just 'cleanly shutdown'?

> It would almost certainly make sense to have a way to tell md 'hibernate
> wrote to your device so things might have changed - you should check'.
> Then md could look at the metadata and refresh any in-memory information
> such as device failures and event counts.
> After all if a device fails while writing out the hibernation image, we want
> the hibernation to succeed (I assume) and we want md to know that the device
> is failed when it wakes back up, and currently it won't.  So we really need
> that notification anyway.

Now that I understand and agree with.

Regards,

Nigel
-- 
Evolution (n): A hypothetical process whereby improbable
events occur with alarming frequency, order arises from chaos, and
no one is given credit.
