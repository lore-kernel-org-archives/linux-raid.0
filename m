From: Jiri Kosina <jikos@jikos.cz>
Subject: Re: oops on 2.6.19-rc6-mm2: deref of 0x28 at permission+0x7
Date: Sun, 10 Dec 2006 20:30:24 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0612102027350.1665@twin.jikos.cz>
References: <457A0F4C.9060601@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <457A0F4C.9060601@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, mingo@redhat.com, neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 9 Dec 2006, Jiri Slaby wrote:

> I got this oops on 2.6.19-rc6-mm2 when starting the system. It happened 
> only once -- when echo "raidautorun /dev/md0" | nash --quiet was 
> executed. 

Hi,

this nash thing is exactly the command which triggers a bit different oops 
in my case. On my side, the oops is fully reproducible. If you manage to 
make your case also reproducible, could you please try to revert 
md-change-lifetime-rules-for-md-devices.patch? This made the oops vanish 
in my case. I think Neil is working on it.

-- 
Jiri Kosina
