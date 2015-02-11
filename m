From: Adam Thompson <athompso@athompso.net>
Subject: Re: [Board] dead RAID6 array on CentOS6.6 / kernel 3.19
Date: Tue, 10 Feb 2015 21:37:36 -0600
Message-ID: <54DACE80.3010004@athompso.net>
References: <b8upe28pe441l7y4sd2vv61c.1423623489558@email.android.com>
Reply-To: athompso@athompso.net
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b8upe28pe441l7y4sd2vv61c.1423623489558@email.android.com>
Sender: linux-raid-owner@vger.kernel.org
To: Trevor Cordes <trevor@tecnopolis.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2015-02-10 08:58 PM, Trevor Cordes wrote:
> The big first question is was it lying when it said starting bg recon. 
> Probably. How can it rebuild a 3+ drive failure.
>
> If so it should be possible to really force. As in wild wacky stuff. 
> I've done that before.
>
> I can look at it more after the meeting our tomorrow morning.
>
> Was the reboot a clean or a sysreq? Did it sync first?

Manually initiated by reboot(8), which is a link to telinit(8), which 
merely sends a signal to init(8), which actually did the reboot.
No idea if /dev/md127 correctly stopped or not, syslogd stops before 
those messages get logged, and I was working remotely through SSH 
instead of to the virtual console connection.
I would assume the sync(2) happened correctly; this is breakage way down 
at the MD layer, not the FS layer.

You're right, RAID6 can't rebuild from a 3-drive failure.  I've gone 
back through the messages I sent, and it looks like there was no 
hot-spare, so I suspect this is just the default code path, where it 
tries to rebuild anything it can, then figures out it can't.


-- 
-Adam Thompson
  athompso@athompso.net
  +1 (204) 291-7950 - cell
  +1 (204) 489-6515 - fax

