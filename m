From: Nix <nix@esperi.org.uk>
Subject: Re: Repeatable md OOPS on suspend,
	2.6.39.4 and 3.0.3
Date: Thu, 15 Sep 2011 06:38:28 +0100
Message-ID: <87d3f29xgr.fsf@spindle.srvr.nix>
References: <CALxPEfw-XdcosHemovkxj9aOwaYxUaQ6dj=yMaKCmoy2vkkUkg@mail.gmail.com>
	<loom.20110901T032036-733@post.gmane.org>
	<CALxPEfwJ99bvmSXkqSKutAYbcD9OLcyMcKQQO6G+Yxi9RQ1DFA@mail.gmail.com>
	<CALxPEfyQrwWh1AWY-fwwCeMzDEeK390Eof9PwrsN6C11Wnt9=A@mail.gmail.com>
	<loom.20110906T201030-97@post.gmane.org>
	<87mxed7u3s.fsf_-_@spindle.srvr.nix> <4E71397A.9060708@tuxonice.net>
	<20110915053139.09dd6ae1@notabene.brown> <4E717C80.20305@tuxonice.net>
Reply-To: TuxOnIce users' list <tuxonice-users@lists.tuxonice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tuxonice-users-bounces@lists.tuxonice.net>
In-Reply-To: <4E717C80.20305@tuxonice.net> (Nigel Cunningham's message of
	"Thu, 15 Sep 2011 14:18:08 +1000")
List-Unsubscribe: <http://lists.tuxonice.net/options/tuxonice-users>,
	<mailto:tuxonice-users-request@lists.tuxonice.net?subject=unsubscribe>
List-Archive: <http://lists.tuxonice.net/pipermail/tuxonice-users>
List-Post: <mailto:tuxonice-users@lists.tuxonice.net>
List-Help: <mailto:tuxonice-users-request@lists.tuxonice.net?subject=help>
List-Subscribe: <http://lists.tuxonice.net/listinfo/tuxonice-users>,
	<mailto:tuxonice-users-request@lists.tuxonice.net?subject=subscribe>
Sender: tuxonice-users-bounces@lists.tuxonice.net
Errors-To: tuxonice-users-bounces@lists.tuxonice.net
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, TuxOnIce users' list <tuxonice-users@tuxonice.net>
List-Id: linux-raid.ids

On 15 Sep 2011, Nigel Cunningham outgrape:

> Hi.
>
> On 15/09/11 13:31, NeilBrown wrote:
>> I think the 'md' device *should* be marked 'clean' when it is clean to
>> avoid unnecessary resyncs.
>
> I must be missing something. In raid terminology, what does 'clean'
> mean? Googling gives me lots of references to flyspray :) I thought it
> meant the filesystems contained therein were cleanly unmounted (which it
> isn't in this case). Just 'cleanly shutdown'?

It's got nothing to do with filesystems. Just 'all writes that were
issued to this array have reached all constituent devices in the array'.
(Which one hopes they have if we're about to power down!)

Thus, if an array is dirty, one or more writes is presumed to have not
got to one or more devices, so a resync is required. (The update of the
superblock's state from dirty to clean is done lazily because the state
changes very frequently and it means another write, so arrays can be
briefly marked dirty if they are in fact clean, but should never be
marked clean if they are in fact dirty.)

-- 
NULL && (void)
