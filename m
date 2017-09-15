From: Nix <nix@esperi.org.uk>
Subject: Re: Encrypted software RAID1 with Debian Stretch
Date: Fri, 15 Sep 2017 12:38:52 +0100
Message-ID: <87fubop4xf.fsf@esperi.org.uk>
References: <28c61e8c14f44ec6727b8f3fb3c80c98@riseup.net>
        <59A92C91.7010508@youngman.org.uk> <87y3pjv6jw.fsf@esperi.org.uk>
        <3a85ea27-602a-3f5b-3537-d4159a56c2ed@thelounge.net>
        <87377qvh7t.fsf@esperi.org.uk> <59B95891.9040809@youngman.org.uk>
        <87r2v9sfkm.fsf@esperi.org.uk> <59BA6FAF.9020501@youngman.org.uk>
        <878thhsa0w.fsf@esperi.org.uk> <59BAB4D5.4040507@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59BAB4D5.4040507@youngman.org.uk> (Wols Lists's message of "Thu,
        14 Sep 2017 17:56:53 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 14 Sep 2017, Wols Lists spake thusly:

> On 14/09/17 14:08, Nix wrote:
>> Ah, so it's like bup only immediately accessible without Python and FUSE
>> installed, and probably less reliable (but hopefully this will change.)
>> Except it doesn't do full deduplication (if you change a file, it gets
>> backed up, even if you change it to the same contents as it had before:
>> yeah, perhaps this is a tad contrived).
>
> Actually, yes it does ... at least the way I suggested.
>
> The whole point of an in-place rsync is it does a comparison, and only
> writes the data IF IT CHANGES. So a "change it to itself" change will be
> detected and ignored by rsync (okay, it may well update the inode, but
> then that HAS changed :-)

That's not full deduplication. It can't even deduplicate the results of
a "cp -a", let alone changes of smoething from A to B and back to A
again, or a change of something to something else present elsewhere in
history, or a change of something to something in part containing
something seen elsewhere in history. The rsync rolling-hash algorithm is
the key to spotting all of these, but just because the algorithm can
chunk things properly doesn't mean you're going to spot duplicates
across time unless you try. And rsync (by design) doesn't do anything
like that.

... anyway, this has nothing to do with RAID anymore: I dragged things
so far off topic you need a telescope to see the topic now. Sorry about
that.

-- 
NULL && (void)
