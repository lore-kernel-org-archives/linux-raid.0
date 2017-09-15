From: Nix <nix@esperi.org.uk>
Subject: Re: Encrypted software RAID1 with Debian Stretch
Date: Fri, 15 Sep 2017 12:35:41 +0100
Message-ID: <87k210p52q.fsf@esperi.org.uk>
References: <28c61e8c14f44ec6727b8f3fb3c80c98@riseup.net>
        <59A92C91.7010508@youngman.org.uk> <87y3pjv6jw.fsf@esperi.org.uk>
        <3a85ea27-602a-3f5b-3537-d4159a56c2ed@thelounge.net>
        <87377qvh7t.fsf@esperi.org.uk> <59B95891.9040809@youngman.org.uk>
        <87r2v9sfkm.fsf@esperi.org.uk> <59BA6FAF.9020501@youngman.org.uk>
        <878thhsa0w.fsf@esperi.org.uk> <20170914183932.001ffe25@natsu>
        <87wp51qq60.fsf@esperi.org.uk> <20170914212206.272b1289@natsu>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170914212206.272b1289@natsu> (Roman Mamedov's message of "Thu,
        14 Sep 2017 21:22:06 +0500")
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: Wols Lists <antlists@youngman.org.uk>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 14 Sep 2017, Roman Mamedov said:

> On Thu, 14 Sep 2017 16:02:31 +0100
> Nix <nix@esperi.org.uk> wrote:
>
>> I would never consider snapshots on the same filesystem to be a backup
>> of anything, except possibly as a defence against 'oh whoops I rm'ed the
>> wrong tree'.
>
> No one proposed that.

Oh I thought that was what people were proposing as the compelling btrfs
advantage.

>                       The scenario is that the backup server would have its
> rsync destination dir (from multiple other systems) periodically snapshotted,
> providing a historic view of what it contained 1-2-3 months ago. Just like
> "bup" does in userspace, I guess? -- or like rdiff-backup did, which I used
> before. But now we have that directly in filesystem, no need to cling to
> userspace crutches anymore.

I'm fairly sure that can't deduplicate anywhere near as effectively. No
dedup within files; no dedup across trees (very important if you have
duplicated data on multipl systems you are backing up); no dedup
anywhere except in immediate history. That's all rdiff-backup could do,
but the state of the art is better now.

-- 
NULL && (void)
