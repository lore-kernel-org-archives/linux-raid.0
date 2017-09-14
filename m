From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Encrypted software RAID1 with Debian Stretch
Date: Thu, 14 Sep 2017 17:56:53 +0100
Message-ID: <59BAB4D5.4040507@youngman.org.uk>
References: <28c61e8c14f44ec6727b8f3fb3c80c98@riseup.net>
 <59A92C91.7010508@youngman.org.uk> <87y3pjv6jw.fsf@esperi.org.uk>
 <3a85ea27-602a-3f5b-3537-d4159a56c2ed@thelounge.net>
 <87377qvh7t.fsf@esperi.org.uk> <59B95891.9040809@youngman.org.uk>
 <87r2v9sfkm.fsf@esperi.org.uk> <59BA6FAF.9020501@youngman.org.uk>
 <878thhsa0w.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <878thhsa0w.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 14/09/17 14:08, Nix wrote:
> Ah, so it's like bup only immediately accessible without Python and FUSE
> installed, and probably less reliable (but hopefully this will change.)
> Except it doesn't do full deduplication (if you change a file, it gets
> backed up, even if you change it to the same contents as it had before:
> yeah, perhaps this is a tad contrived).

Actually, yes it does ... at least the way I suggested.

The whole point of an in-place rsync is it does a comparison, and only
writes the data IF IT CHANGES. So a "change it to itself" change will be
detected and ignored by rsync (okay, it may well update the inode, but
then that HAS changed :-)

Cheers,
Wol
