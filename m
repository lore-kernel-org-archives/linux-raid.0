From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Is there any way to delay reconstruction
Date: Wed, 25 May 2005 09:58:13 -0700
Message-ID: <4294AEA5.6090801@h3c.com>
References: <Pine.LNX.4.61.0505250811520.16854@desktop.agenda.si> <eaa6dfe0505250825295cb284@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <eaa6dfe0505250825295cb284@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Derek Piper <derek.piper@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


He mentioned he was on linux 2.4 - an unclean reboot will almost always
cause reconstruction there, as opposed to the aggressively clean 2.6
which almost never reconstructs.

I'd imagine with 800+ boxen, there's a few reboots a day no matter what
you're doing

-Mike

Derek Piper wrote:
> Why would rebooting the machines cause raid reconstruction? that
> sounds pretty bad to need to do that. Shouldn't that be addressed
> first? Then you might not need to worry about reconstruction so much.
> 
> Derek
> 
> On 5/25/05, danci@agenda.si <danci@agenda.si> wrote:
> 
> 
>>The problem is that usually fails with 'hdX: lost interrupt' if the disks
>>are busy due to RAID reconstruction - which happens a lot as some of the
>>800+ machines get rebooted for various reasons...
>>
> 
> 
> 
