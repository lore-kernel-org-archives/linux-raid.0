From: danci@agenda.si
Subject: Re: Is there any way to delay reconstruction
Date: Thu, 26 May 2005 08:59:00 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0505260848320.22131@desktop.agenda.si>
References: <Pine.LNX.4.61.0505250811520.16854@desktop.agenda.si>
 <eaa6dfe0505250825295cb284@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <eaa6dfe0505250825295cb284@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Derek Piper <derek.piper@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 25 May 2005, Derek Piper wrote:

> Why would rebooting the machines cause raid reconstruction? that
> sounds pretty bad to need to do that. Shouldn't that be addressed
> first? Then you might not need to worry about reconstruction so much.

Rebooting the 'clean' way (CTRL-ALT-DEL or 'shutdown -r now') is no 
problem - it doesn't require reconstruction.

It's 'cold' (or hardware) resets (such as power outages, silly users, 
etc.) that cause that - I don't think there is much you can do about that. 

 D.

