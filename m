From: Roman Mamedov <rm@romanrm.net>
Subject: Re: My MD is too big to resize ext4.
Date: Sat, 8 Jul 2017 16:15:13 +0500
Message-ID: <20170708161513.37b09dbc@natsu>
References: <6c827d07-19d8-017b-ca95-5e6f84b7821a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6c827d07-19d8-017b-ca95-5e6f84b7821a@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 7 Jul 2017 19:41:13 -0500
Ram Ramesh <rramesh2400@gmail.com> wrote:

> On the web, I only found one solution that required upgrading kernel to 
> some very recent one (not in my distro) and getting the bleeding edge 
> resize2fs. This makes me nervous. Is there a solution that avoids this.

Considering the other possible options that have been mentioned, using the
Ext4 built-in larger devices support (which has been implemented recently)
seems to be your best bet.
https://askubuntu.com/questions/779754/how-do-i-resize-an-ext4-partition-beyond-the-16tb-limit

The required e2fsprogs version 1.43 is included in Ubuntu 16.10 by now, so you
don't even need to build it from the source.
https://packages.ubuntu.com/yakkety/e2fsprogs

But really, if you have everything on one array with a single huge filesystem
and no backups, that's just asking for trouble and a complete data loss.

-- 
With respect,
Roman
