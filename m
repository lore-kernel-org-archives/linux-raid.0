From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Raid5/6 journal re-add
Date: Sun, 19 Nov 2017 19:06:38 -0700
Message-ID: <CAJCQCtQ35HC34EdwPU-ZVJFYGe_+21HaE55jZOOyEC8cCAvXhA@mail.gmail.com>
References: <4752eee7-7b05-55fc-9e0b-d9446ef4328d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4752eee7-7b05-55fc-9e0b-d9446ef4328d@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Larkin Lowrey <llowrey@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Nov 19, 2017 at 4:00 PM, Larkin Lowrey <llowrey@gmail.com> wrote:
> I did a 'pull-the-drive' test on a raid6 array with a write-journal and
> found that mdadm (v4.0-218-gfe05dc4 - 2017-11-09) would not let me --re-add
> the drive so I add to --add it.
>
> mdadm: --re-add for /dev/sdq1 to /dev/md124 is not possible
>
> My expectation was that the drive would be recognized as being the missing
> member and would be re-added and only out-of-sync regions would be resync'd.
>
> When I --add'ed the drive to the array the resync process started for the
> entire array, not just for the out-of-sync regions. Is this correct behavior
> for arrays with write journals? Are there plans to perform a selective
> re-sync rather than a full re-sync?

Needs to be in the mdadm.conf for this array, see 'man mdadm.conf'

-- 
Chris Murphy
