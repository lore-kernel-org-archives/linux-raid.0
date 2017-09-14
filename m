From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Encrypted software RAID1 with Debian Stretch
Date: Thu, 14 Sep 2017 21:22:06 +0500
Message-ID: <20170914212206.272b1289@natsu>
References: <28c61e8c14f44ec6727b8f3fb3c80c98@riseup.net>
        <59A92C91.7010508@youngman.org.uk>
        <87y3pjv6jw.fsf@esperi.org.uk>
        <3a85ea27-602a-3f5b-3537-d4159a56c2ed@thelounge.net>
        <87377qvh7t.fsf@esperi.org.uk>
        <59B95891.9040809@youngman.org.uk>
        <87r2v9sfkm.fsf@esperi.org.uk>
        <59BA6FAF.9020501@youngman.org.uk>
        <878thhsa0w.fsf@esperi.org.uk>
        <20170914183932.001ffe25@natsu>
        <87wp51qq60.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87wp51qq60.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Wols Lists <antlists@youngman.org.uk>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 14 Sep 2017 16:02:31 +0100
Nix <nix@esperi.org.uk> wrote:

> I would never consider snapshots on the same filesystem to be a backup
> of anything, except possibly as a defence against 'oh whoops I rm'ed the
> wrong tree'.

No one proposed that. The scenario is that the backup server would have its
rsync destination dir (from multiple other systems) periodically snapshotted,
providing a historic view of what it contained 1-2-3 months ago. Just like
"bup" does in userspace, I guess? -- or like rdiff-backup did, which I used
before. But now we have that directly in filesystem, no need to cling to
userspace crutches anymore.

-- 
With respect,
Roman
