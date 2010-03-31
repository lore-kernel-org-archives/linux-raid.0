From: Asdo <asdo@shiftmail.org>
Subject: Re: Array 'freezes' for some time after large writes?
Date: Wed, 31 Mar 2010 18:37:42 +0200
Message-ID: <4BB37A56.80008@shiftmail.org>
References: <dead81ad1003301007h4015ac57x99f36d232bb705b6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <dead81ad1003301007h4015ac57x99f36d232bb705b6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Duchek <jim.duchek@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jim Duchek wrote:
> Hi all.  Regularly after a large write to the disk (untarring a very
> large file, etc), my RAID5 will 'freeze' for a period of time --
> perhaps around a minute.  My system is completely responsive otherwise
> during this time,

Why don't you
  cat /proc/<pid of blocked process>/stack
to see what was the process doing?
Maybe more than once to see if it hangs always on the same syscalls...

I believe this is more useful if there is only 1 access to the array, 
not concurrent access. You need to freeze it with e.g. the tar only,

This might identify filesystem problems. Other problems might be more 
difficult.
