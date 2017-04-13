From: Roman Mamedov <rm@romanrm.net>
Subject: Re: disk initialize priority
Date: Thu, 13 Apr 2017 14:37:36 +0500
Message-ID: <20170413143736.5ac148d0@natsu>
References: <CAC6SzHJAM-AbCiK7rqhgk4CJcyZ4C-yW0kt_rr3hgk+F-WMCiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC6SzHJAM-AbCiK7rqhgk4CJcyZ4C-yW0kt_rr3hgk+F-WMCiQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: d tbsky <tbskyd@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 13 Apr 2017 16:13:41 +0800
d tbsky <tbskyd@gmail.com> wrote:

> in past the disk initialize
> speed will down to slow speed when there are other disk IO, but it
> seems not the case in rhel 7.3.

It was changed some time ago with:

  "md: allow resync to go faster when there is competing IO"
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ac8fa4196d205ac8fff3f8932bddbad4f16e4110

and a problem like you describe has been reported:

  https://www.spinics.net/lists/raid/msg51363.html

Some patches have been discussed, but apparently there is no fix for it up to
this day, as the current code in question looks the same as in the above patch.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/md/md.c#n8138

-- 
With respect,
Roman
