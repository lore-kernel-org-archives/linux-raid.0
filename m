From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: conf->min_offset_diff calculation timing of growing raid5
Date: Tue, 2 Jan 2018 06:57:35 +0000
Message-ID: <5A4B2D5F.8090505@youngman.org.uk>
References: <CAJtTb3GYuEL-tco3Uy7L0G3ssTFez3=Qwghd5DzqTU5y-snh3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJtTb3GYuEL-tco3Uy7L0G3ssTFez3=Qwghd5DzqTU5y-snh3Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Amy Chiang <amychiang@qnap.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/01/18 03:49, Amy Chiang wrote:
> I didn't specify --backup-file because I thought mdadm would give me a
> warning if there's a possibility that I might lose my data if this
> operation crash.

I'm slightly surprised at your results (although I shouldn't be :-).
Backup files are now almost entirely legacy - a modern setup should
pretty much never need them - which is why I'm surprised at your
results, I would have expected mdadm to ignore the backup-file option.

In the old days, a reshape used to copy a stripe to backup, and then
rewrite it. Rinse, lather and repeat. So the i/o overhead was high. Now,
with "data offset" and superblock 1, mdadm calculates where the reshaped
array is going to be, then starts copying from the old to array to where
the new array does not overlap the old array. This makes a window where
there are two copies of the data. When it runs out of space, it moves
the window to create more space and carries on copying. As you can see,
this is a lot less work ...

Cheers,
Wol
