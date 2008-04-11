From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: emergency recovery
Date: Fri, 11 Apr 2008 10:35:02 -0400
Message-ID: <47FF7716.7010306@tmr.com>
References: <51c8a7be0804092329i3353055ai6216dc0e6b4066ea@mail.gmail.com>	 <ftkclu$t6f$1@ger.gmane.org> <47FE3BB8.5010300@gmail.com>	 <51c8a7be0804101613k4d01ad02hc20ba685268a2b5a@mail.gmail.com> <51c8a7be0804101645k207bc08bu45ecc16a589e7b27@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51c8a7be0804101645k207bc08bu45ecc16a589e7b27@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: jeff sacksteder <jsacksteder@gmail.com>
Cc: john <john4lists@gmail.com>, Mario 'BitKoenig' Holbe <Mario.Holbe@tu-ilmenau.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

jeff sacksteder wrote:
> I should also note that I'm doing this from a liveCD and though I have
> modprobe-ed the appropriate modules, I still don't see the node in
> /dev for md0.

You can try doing an assemble with force after backing up whatever you 
feel you should (or can). Assuming you get an array at that point, you 
can do an information only file system check (fsck -n) to see what the 
state of the f/s might be. You can also run the 'check' action to see 
how unhappy mdadm thinks things are.

By that time you will have information to use or report back to the list 
for more ideas.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


