From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Bug#784070: Newly-created arrays don't auto-assemble - related to hostname change?
Date: Wed, 23 Nov 2016 12:03:49 +0300
Message-ID: <c7f7e076-0fed-eb51-3291-f93cf66a49a3@msgid.tls.msk.ru>
References: <20161117150954.GH21587@bitfolk.com>
 <87d1hthgm7.fsf@notabene.neil.brown.name> <20161118023144.GC1804@bitfolk.com>
 <87poltfq2d.fsf@notabene.neil.brown.name>
 <20161118034716.GI21587@bitfolk.com>
 <87k2c1fn0o.fsf@notabene.neil.brown.name> <20161118041759.GE1804@bitfolk.com>
 <877f7xe9lh.fsf@notabene.neil.brown.name> <20161121060256.GL1804@bitfolk.com>
 <87shqkcuhv.fsf@notabene.neil.brown.name> <20161122060105.GS1804@bitfolk.com>
 <87wpfuc4ab.fsf@notabene.neil.brown.name>
Reply-To: Michael Tokarev <mjt@tls.msk.ru>, 784070@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <bounce-debian-bugs-rc=glddbr-debian-bugs-rc=gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.784070.B784070.14798918374553@bugs.debian.org>
In-Reply-To: <87wpfuc4ab.fsf@notabene.neil.brown.name>
List-URL: <https://lists.debian.org/debian-bugs-rc/>
List-Post: <mailto:debian-bugs-rc@lists.debian.org>
List-Help: <mailto:debian-bugs-rc-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-rc-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-rc-request@lists.debian.org?subject=unsubscribe>
To: NeilBrown <neilb@suse.com>, 784070@bugs.debian.org, Andy Smith <andy@strugglers.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

23.11.2016 05:34, NeilBrown wrote:
> On Tue, Nov 22 2016, Andy Smith wrote:
> 
>> Hi Neil,
>>
>> On Tue, Nov 22, 2016 at 09:56:28AM +1100, NeilBrown wrote:
>>> Thanks.  Sorry this is taking a lot of back-and-forth...
>>
>> No worries. This is very interesting to me and I'd also like to know
>> what is going wrong even if I have a work-around.
> 
> Thanks.
> I tried this on a scratch Debian VM I had lying around, and found I
> could exactly reproduce your symptoms.
> I found that, unlike on the first Debian system I looked at, there is a
> line in  /lib/udev/rules.d/64-md-raid-assembly.rules 
> 
>   # Disable incremental assembly to fix Debian bug #784070
>   GOTO="md_inc_end"
> 
> Remove that and the problem goes away.  Arrgg...
> 
> I wish people maintainers would *ask* upstream when they don't
> understand, rather than just breaking things.

Neil, with all my respect, this is a bit over-reaction :)

It was long ago when we disabled incremental assembly when
you turned it on by default, and kept old static way to
assemble arrays, because neither our initrd nor regular
userpsace weren't ready for that.  At the time jessie come
out, we didn't have enough time to sort it out, so we kept
it for jessie too.

After restoring your (upstream) rules, things WILL break in
other place.  Someone already tried that and had to revert
it back to what we have now. Initrd should have some
initial infrastructure for event-based work before this will
be possible.

I wanted to fix it all for stretch. But once I had a conflict
with the d-i team I don't work on mdadm (or any other package
touching d-i) anymore.

Thanks,

/mjt
