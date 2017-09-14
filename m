From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Encrypted software RAID1 with Debian Stretch
Date: Thu, 14 Sep 2017 18:39:32 +0500
Message-ID: <20170914183932.001ffe25@natsu>
References: <28c61e8c14f44ec6727b8f3fb3c80c98@riseup.net>
        <59A92C91.7010508@youngman.org.uk>
        <87y3pjv6jw.fsf@esperi.org.uk>
        <3a85ea27-602a-3f5b-3537-d4159a56c2ed@thelounge.net>
        <87377qvh7t.fsf@esperi.org.uk>
        <59B95891.9040809@youngman.org.uk>
        <87r2v9sfkm.fsf@esperi.org.uk>
        <59BA6FAF.9020501@youngman.org.uk>
        <878thhsa0w.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <878thhsa0w.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Wols Lists <antlists@youngman.org.uk>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 14 Sep 2017 14:08:15 +0100
Nix <nix@esperi.org.uk> wrote:

> Backups based on not-yet-reliable filesystems are, uh, less effective.

You're just grasping for straws at this point. Single-device Btrfs and
its core features like snapshotting and compression are very solid, it is
silly trying to "cast doubt" on those. Thousands of people use Btrfs for their
primary storage, it is certainly more than stable enough to be used for
backups (which by definition are just a copy of stuff also existing elsewhere).

And yeah rsync+Btrfs snapshotting are an amazing combination, it works really
well for backups, and the easiness of the workflow to access older versions of
a file or the whole dir tree is unsurpassed by anything imaginable.

-- 
With respect,
Roman
