From: Nix <nix@esperi.org.uk>
Subject: Re: Repeatable md OOPS on suspend,
	2.6.39.4 and 3.0.3
Date: Thu, 15 Sep 2011 06:34:45 +0100
Message-ID: <87hb4e9xmy.fsf@spindle.srvr.nix>
References: <CALxPEfw-XdcosHemovkxj9aOwaYxUaQ6dj=yMaKCmoy2vkkUkg@mail.gmail.com>
	<loom.20110901T032036-733@post.gmane.org>
	<CALxPEfwJ99bvmSXkqSKutAYbcD9OLcyMcKQQO6G+Yxi9RQ1DFA@mail.gmail.com>
	<CALxPEfyQrwWh1AWY-fwwCeMzDEeK390Eof9PwrsN6C11Wnt9=A@mail.gmail.com>
	<loom.20110906T201030-97@post.gmane.org>
	<87mxed7u3s.fsf_-_@spindle.srvr.nix> <4E71397A.9060708@tuxonice.net>
Reply-To: TuxOnIce users' list <tuxonice-users@lists.tuxonice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tuxonice-users-bounces@lists.tuxonice.net>
In-Reply-To: <4E71397A.9060708@tuxonice.net> (Nigel Cunningham's message of
	"Thu, 15 Sep 2011 09:32:10 +1000")
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
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>, TuxOnIce users' list <tuxonice-users@tuxonice.net>
List-Id: linux-raid.ids

On 15 Sep 2011, Nigel Cunningham stated:

> Please try/review the attached patch.

That works perfectly. No oops, no panic, md a happy bunny on resume.
(Haven't tried non-resuming a hibernated kernel on the grounds that I'd
rather not kick off an umpty hour long automatic array rebuild right
now.)

-- 
NULL && (void)
